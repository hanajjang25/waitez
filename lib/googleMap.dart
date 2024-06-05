import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

const String GOOGLE_API_KEY = 'AIzaSyAyc3lB3ln_EvyNTaecIVEi66ZV4CCIPoc';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 18.0,
  );

  String _currentAddress = "Getting location...";
  Position? _currentPosition;
  Marker? _userMarker;
  bool _isMapMoving = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    PermissionStatus status = await Permission.locationWhenInUse.request();

    if (status == PermissionStatus.granted) {
      _getCurrentLocation();
    } else if (status == PermissionStatus.denied) {
      _showPermissionDeniedDialog();
    } else if (status == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Permission Denied'),
          content:
              Text('Location permissions are required to use this feature.'),
          actions: <Widget>[
            TextButton(
              child: Text('Retry'),
              onPressed: () {
                Navigator.of(context).pop();
                _requestLocationPermission();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
        _initialPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 18.0,
        );
        _userMarker = Marker(
          markerId: MarkerId('userMarker'),
          position: LatLng(position.latitude, position.longitude),
          draggable: true,
          onDragEnd: (newPosition) {
            _getAddressFromLatLng(newPosition.latitude, newPosition.longitude);
          },
        );
      });

      final GoogleMapController controller = await _controller.future;
      controller
          .animateCamera(CameraUpdate.newCameraPosition(_initialPosition));
    } catch (e) {
      print('Failed to get current location: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('현재 위치를 가져오지 못했습니다.'),
      ));
    }
  }

  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      String address = await getPlaceAddress(lat: latitude, lng: longitude);
      setState(() {
        _currentAddress = address;
      });
    } catch (e) {
      print('Failed to get address: $e');
    }
  }

  Future<String> getPlaceAddress({double lat = 0.0, double lng = 0.0}) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY&language=ko';
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['results'].isNotEmpty) {
        return data['results'][0]['formatted_address'];
      } else {
        throw Exception('No results found');
      }
    } else {
      throw Exception('Failed to fetch address');
    }
  }

  void _navigateToAddressPage() {
    if (_currentPosition != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddressPage(address: _currentAddress),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('현재 위치를 가져오지 못했습니다.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Map Example'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initialPosition,
              onMapCreated: (GoogleMapController controller) {
                if (!_controller.isCompleted) {
                  _controller.complete(controller);
                }
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _userMarker != null ? {_userMarker!} : {},
              onCameraMove: (CameraPosition position) {
                setState(() {
                  _isMapMoving = true;
                  _userMarker = _userMarker?.copyWith(
                    positionParam: position.target,
                  );
                });
              },
              onCameraIdle: () async {
                if (_isMapMoving && _userMarker != null) {
                  _isMapMoving = false;
                  await _getAddressFromLatLng(_userMarker!.position.latitude,
                      _userMarker!.position.longitude);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  _currentAddress,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: _navigateToAddressPage,
                  child: Text('이 위치로 주소 설정'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddressPage extends StatelessWidget {
  final String address;

  AddressPage({required this.address});

  @override
  Widget build(BuildContext context) {
    TextEditingController _detailAddressController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Address Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              address,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _detailAddressController,
              decoration: InputDecoration(
                labelText: '상세 주소 입력',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String detailAddress = _detailAddressController.text;
                print('Detail Address: $detailAddress');
              },
              child: Text('상세 주소 저장'),
            ),
          ],
        ),
      ),
    );
  }
}
