import 'dart:async';                                       
import 'dart:convert';                                        
import 'package:flutter/material.dart';                        
import 'package:google_maps_flutter/google_maps_flutter.dart'; 
import 'package:geolocator/geolocator.dart';                    
import 'package:permission_handler/permission_handler.dart';   
import 'package:http/http.dart' as http;                        
import 'package:cloud_firestore/cloud_firestore.dart';        
import 'package:firebase_auth/firebase_auth.dart';            

const String GOOGLE_API_KEY = 'AIzaSyAyc3lB3ln_EvyNTaecIVEi66ZV4CCIPoc';  // Google API 키

class MapPage extends StatefulWidget {                          // MapPage 상태 관리 클래스
  final String previousPage;                                    // 이전 페이지 이름을 저장할 변수

  MapPage({required this.previousPage});                        // 생성자에서 previousPage 초기화

  @override
  _MapPageState createState() => _MapPageState();               // _MapPageState 생성
}

class _MapPageState extends State<MapPage> {                    // MapPage 상태 관리 구현
  final Completer<GoogleMapController> _controller =            // GoogleMapController를 위한 Completer
      Completer<GoogleMapController>();
  CameraPosition _initialPosition = CameraPosition(             // 초기 맵 위치 설정
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 18.0,
  );

  String _currentAddress = "Getting location...";               // 현재 주소를 저장할 변수
  Position? _currentPosition;                                   // 현재 위치를 저장할 변수
  Marker? _userMarker;                                          // 사용자의 위치 마커
  bool _isMapMoving = false;                                    // 맵이 움직이고 있는지 확인하는 플래그
  TextEditingController _searchController = TextEditingController();  // 검색창 컨트롤러
  List<String> _suggestions = [];                               // 검색어 자동완성 결과를 저장할 리스트

  @override
  void initState() {                                            // 초기화 메서드
    super.initState();
    _requestLocationPermission();                               // 위치 권한 요청
    _searchController.addListener(_onSearchChanged);            // 검색어가 변경될 때마다 호출
  }

  @override
  void dispose() {                                              // 위젯 해제 시 호출
    _searchController.removeListener(_onSearchChanged);         // 검색 리스너 제거
    _searchController.dispose();                                // 검색 컨트롤러 해제
    super.dispose();
  }

  void _onSearchChanged() {                                     // 검색어가 변경될 때 호출
    if (_searchController.text.isNotEmpty) {
      _getSuggestions(_searchController.text);                  // 자동완성 결과를 가져옴
    } else {
      setState(() {
        _suggestions = [];                                      // 검색어가 없으면 결과 초기화
      });
    }
  }

  Future<void> _requestLocationPermission() async {             // 위치 권한 요청 메서드
    PermissionStatus status = await Permission.locationWhenInUse.request();

    if (status == PermissionStatus.granted) {                   // 권한이 허용된 경우
      _getCurrentLocation();                                    // 현재 위치 가져오기
    } else if (status == PermissionStatus.denied) {             // 권한이 거부된 경우
      _showPermissionDeniedDialog();                            // 권한 거부 다이얼로그 표시
    } else if (status == PermissionStatus.permanentlyDenied) {  // 권한이 영구적으로 거부된 경우
      openAppSettings();                                        // 앱 설정 열기
    }
  }

  void _showPermissionDeniedDialog() {                          // 권한 거부 다이얼로그
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Permission Denied'),            // 제목
          content: Text('Location permissions are required to use this feature.'), // 내용
          actions: <Widget>[
            TextButton(
              child: Text('Retry'),                             // 재시도 버튼
              onPressed: () {
                Navigator.of(context).pop();                    // 다이얼로그 닫기
                _requestLocationPermission();                   // 권한 재요청
              },
            ),
            TextButton(
              child: Text('Cancel'),                            // 취소 버튼
              onPressed: () {
                Navigator.of(context).pop();                    // 다이얼로그 닫기
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _getCurrentLocation() async {                    // 현재 위치 가져오기 메서드
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);              // 높은 정확도로 위치 가져오기
      setState(() {
        _currentPosition = position;                            // 위치 정보 저장
        _initialPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 18.0,
        );
        _userMarker = Marker(                                   // 사용자 위치 마커 생성
          markerId: MarkerId('userMarker'),
          position: LatLng(position.latitude, position.longitude),
          draggable: true,                                      // 마커를 드래그 가능하도록 설정
          onDragEnd: (newPosition) {                            // 드래그 종료 시 호출
            _getAddressFromLatLng(newPosition.latitude, newPosition.longitude);  // 새로운 위치의 주소 가져오기
          },
        );
      });

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_initialPosition)); // 카메라 이동
    } catch (e) {
      print('Failed to get current location: $e');              // 위치 가져오기 실패 시 출력
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('현재 위치를 가져오지 못했습니다.'),                // 에러 메시지 표시
      ));
    }
  }

  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {  // 위도, 경도에서 주소 가져오기
    try {
      String address = await getPlaceAddress(lat: latitude, lng: longitude);
      setState(() {
        _currentAddress = address;                              // 주소 업데이트
      });
    } catch (e) {
      print('Failed to get address: $e');                       // 주소 가져오기 실패 시 출력
    }
  }

  Future<String> getPlaceAddress({double lat = 0.0, double lng = 0.0}) async {  // 주소 가져오기 메서드
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY&language=ko';
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {                           // 요청이 성공한 경우
      var data = jsonDecode(response.body);
      if (data['results'].isNotEmpty) {                         // 결과가 있는 경우
        return data['results'][0]['formatted_address'];         // 첫 번째 결과의 주소 반환
      } else {
        throw Exception('No results found');                    // 결과가 없는 경우 예외 발생
      }
    } else {
      throw Exception('Failed to fetch address');               // 요청 실패 시 예외 발생
    }
  }

  Future<void> _getSuggestions(String query) async {            // 검색어 자동완성 메서드
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$GOOGLE_API_KEY&language=ko';
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {                           // 요청이 성공한 경우
      var data = jsonDecode(response.body);
      if (data['predictions'].isNotEmpty) {                     // 결과가 있는 경우
        setState(() {
          _suggestions = List<String>.from(
              data['predictions'].map((p) => p['description']));  // 자동완성 결과 저장
        });
      } else {
        setState(() {
          _suggestions = [];                                    // 결과가 없는 경우 리스트 초기화
        });
      }
    } else {
      throw Exception('Failed to fetch suggestions');           // 요청 실패 시 예외 발생
    }
  }

  Future<void> _searchAndNavigate(String searchText) async {    // 검색 후 위치 이동 메서드
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$searchText&key=$GOOGLE_API_KEY&language=ko';
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {                           // 요청이 성공한 경우
      var data = jsonDecode(response.body);
      if (data['results'].isNotEmpty) {                         // 결과가 있는 경우
        var location = data['results'][0]['geometry']['location'];
        LatLng searchedLocation = LatLng(location['lat'], location['lng']);
        setState(() {
          _initialPosition = CameraPosition(target: searchedLocation, zoom: 18.0);  // 검색한 위치로 카메라 이동
          _userMarker = Marker(
            markerId: MarkerId('searchedLocation'),
            position: searchedLocation,
            draggable: true,                                    // 마커를 드래그 가능하도록 설정
            onDragEnd: (newPosition) {                          // 드래그 종료 시 호출
              _getAddressFromLatLng(
                  newPosition.latitude, newPosition.longitude);  // 새로운 위치의 주소 가져오기
            },
          );
          _suggestions = [];                                    // 자동완성 결과 초기화
          _searchController.clear();                            // 검색창 초기화
        });

        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newCameraPosition(_initialPosition)); // 카메라 이동
        _getAddressFromLatLng(location['lat'], location['lng']);  // 주소 가져오기
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('주소를 찾을 수 없습니다.'),                    // 주소를 찾지 못한 경우 메시지 표시
        ));
      }
    } else {
      throw Exception('Failed to search location');              // 요청 실패 시 예외 발생
    }
  }

  void _navigateToAddressPage() {                                // 주소 페이지로 이동 메서드
    if (_currentPosition != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddressPage(
            address: _currentAddress,
            previousPage: widget.previousPage,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('현재 위치를 가져오지 못했습니다.'),                // 위치 정보를 가져오지 못한 경우 메시지 표시
      ));
    }
  }

  @override
  Widget build(BuildContext context) {                            // UI 빌드 메서드
    return Scaffold(
      appBar: AppBar(
        title: Text('위치'),                                        // 앱바 타이틀
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),                     // 여백 설정
            child: Column(
              children: [
                TextField(
                  controller: _searchController,                   // 검색창 컨트롤러 설정
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        _searchAndNavigate(_searchController.text); // 검색 버튼 클릭 시 위치 검색
                      },
                    ),
                    hintText: '위치 검색',                           // 힌트 텍스트 설정
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),     // 테두리 둥글게 설정
                    ),
                  ),
                ),
                if (_suggestions.isNotEmpty)
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 200),    // 최대 높이 설정
                    child: ListView.builder(
                      shrinkWrap: true,                             // 리스트뷰의 크기를 자식에 맞춤
                      itemCount: _suggestions.length,               // 자동완성 결과 수
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_suggestions[index]),         // 자동완성 결과 표시
                          onTap: () {
                            _searchAndNavigate(_suggestions[index]); // 결과 선택 시 위치 검색
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,                             // 맵 타입 설정
              initialCameraPosition: _initialPosition,             // 초기 카메라 위치 설정
              onMapCreated: (GoogleMapController controller) {     // 맵이 생성되었을 때 호출
                if (!_controller.isCompleted) {
                  _controller.complete(controller);                // 컨트롤러 완성
                }
              },
              myLocationEnabled: true,                             // 내 위치 버튼 활성화
              myLocationButtonEnabled: true,                       // 내 위치 버튼 보이기
              markers: _userMarker != null ? {_userMarker!} : {},  // 마커 표시
              onCameraMove: (CameraPosition position) {            // 카메라 이동 중 호출
                setState(() {
                  _isMapMoving = true;                             // 맵 이동 플래그 설정
                  _userMarker = _userMarker?.copyWith(
                    positionParam: position.target,                // 마커 위치 업데이트
                  );
                });
              },
              onCameraIdle: () async {                             // 카메라 이동 후 호출
                if (_isMapMoving && _userMarker != null) {
                  _isMapMoving = false;                            // 맵 이동 플래그 해제
                  await _getAddressFromLatLng(_userMarker!.position.latitude,
                      _userMarker!.position.longitude);            // 이동 후 위치의 주소 가져오기
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),                    // 여백 설정
            child: Column(
              children: [
                Text(
                  _currentAddress,                                 // 현재 주소 표시
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),                             // 간격 추가
                ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.blue[50],              // 버튼 배경 색상 설정
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),                       // 버튼 테두리 둥글게 설정
                      ),
                    ),
                  ),
                  onPressed: _navigateToAddressPage,               // 버튼 클릭 시 주소 페이지로 이동
                  child: Text(
                    '이 위치로 주소 설정',                          // 버튼 텍스트
                    style: TextStyle(
                      color: Color(0xFF1C1C21),
                      fontSize: 15,
                      fontFamily: 'Epilogue',
                      height: 0.07,
                      letterSpacing: -0.27,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddressPage extends StatelessWidget {                       // 주소 페이지 클래스
  final String address;                                           // 주소 저장할 변수
  final String previousPage;                                      // 이전 페이지 이름을 저장할 변수

  AddressPage({required this.address, required this.previousPage});  // 생성자에서 address와 previousPage 초기화

  Future<void> _updateUserLocation(String address) async {        // 사용자 위치를 Firestore에 업데이트하는 메서드
    User? user = FirebaseAuth.instance.currentUser;               // 현재 로그인된 사용자 가져오기
    if (user == null) {
      print('로그아웃되어있습니다.');                                 // 사용자 정보가 없으면 출력
      return;
    }

    if (user.isAnonymous) {                                       // 익명 사용자일 경우
      String uid = user.uid;

      // uid를 통해 Firestore에서 nonmember 문서 찾기
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('non_members')
          .where('uid', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {                        // 문서가 존재하면 업데이트
        DocumentReference nonMemberDoc = querySnapshot.docs[0].reference;
        await nonMemberDoc.update({'location': address}).catchError((error) {
          print('비회원 위치 업데이트 실패 : $error');                   // 업데이트 실패 시 오류 출력
        });
        print('비회원 위치 업데이트 성공 : $address');                   // 업데이트 성공 시 출력
      } else {
        print('회원정보를 찾을 수 없습니다.');                            // 문서를 찾지 못한 경우 출력
      }
    } else {                                                      // 비익명 사용자일 경우
      String email = user.email!;

      // 이메일을 통해 Firestore에서 사용자 문서 찾기
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {                        // 문서가 존재하면 업데이트
        DocumentReference userDoc = querySnapshot.docs[0].reference;
        await userDoc.update({'location': address}).catchError((error) {
          print('회원 위치 업데이트 실패 : $error');                     // 업데이트 실패 시 오류 출력
        });
        print('회원 위치 업데이트 성공 : $address');                     // 업데이트 성공 시 출력
      } else {
        print('회원정보를 찾을 수 없습니다.');                            // 문서를 찾지 못한 경우 출력
      }
    }
  }

  @override
  Widget build(BuildContext context) {                            // UI 빌드 메서드
    TextEditingController _detailAddressController = TextEditingController();  // 상세 주소 입력 컨트롤러

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '상세주소',                                               // 앱바 타이틀
          style: TextStyle(
            color: Color(0xFF1C1C21),
            fontSize: 18,
            fontFamily: 'Epilogue',
            fontWeight: FontWeight.w700,
            height: 0.07,
            letterSpacing: -0.27,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),                      // 여백 설정
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,           // 자식들을 왼쪽 정렬
          children: [
            Text(
              address,                                            // 주소 표시
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),                               // 간격 추가
            TextField(
              controller: _detailAddressController,               // 상세 주소 입력창 설정
              decoration: InputDecoration(
                labelText: '상세 주소 입력',                        // 힌트 텍스트 설정
                border: OutlineInputBorder(),                    // 테두리 설정
              ),
            ),
            SizedBox(height: 16.0),                               // 간격 추가
            ElevatedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.blue[50],                 // 버튼 배경 색상 설정
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),                          // 버튼 테두리 둥글게 설정
                  ),
                ),
              ),
              onPressed: () async {
                String detailAddress = _detailAddressController.text; // 상세 주소 가져오기
                print('Detail Address: $detailAddress');
                String fullAddress = "$address, $detailAddress";  // 전체 주소 생성

                // 사용자 위치를 Firestore에 업데이트
                await _updateUserLocation(fullAddress);

                // 이전 페이지로 돌아가기
                if (previousPage == 'UserSearch') {               // 검색 페이지로 돌아가기
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/search', (route) => false);
                } else if (previousPage == 'RestaurantReg') {     // 음식점 등록 페이지로 돌아가기
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/regRestaurant', (route) => false);
                } else if (previousPage == 'RestaurantEdit') {    // 음식점 편집 페이지로 돌아가기
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/editRestaurant', (route) => false);
                }
              },
              child: Text(
                '상세 주소 저장',                                    // 버튼 텍스트
                style: TextStyle(
                  color: Color(0xFF1C1C21),
                  fontSize: 15,
                  fontFamily: 'Epilogue',
                  height: 0.07,
                  letterSpacing: -0.27,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
