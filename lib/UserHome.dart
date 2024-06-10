import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'UserBottom.dart';
import 'UserSearch.dart';
import 'notification.dart';

class home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 80,
          automaticallyImplyLeading: false,
          title: Text(
            'waitez',
            style: TextStyle(
              color: Color(0xFF1C1C21),
              fontSize: 18,
              fontFamily: 'Epilogue',
              fontWeight: FontWeight.w700,
              height: 0.07,
              letterSpacing: -0.27,
            ),
          ), // 타이틀
          centerTitle: true, // 타이틀 텍스트를 가운데로 정렬 시킴
          actions: [
            // 우측의 액션 버튼들
            IconButton(onPressed: () {}, icon: Icon(Icons.refresh)),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/noti');
                },
                icon: Icon(Icons.notifications))
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/search');
                },
                child: Container(
                  width: screenWidth * 0.9,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: ShapeDecoration(
                    color: Color(0xFFEDEFF2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(width: 12),
                      Text(
                        '검색',
                        style: TextStyle(
                          color: Color(0xFF3D3F49),
                          fontSize: 16,
                          fontFamily: 'Epilogue',
                          fontWeight: FontWeight.w400,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                color: Colors.blue[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '예약하기',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'reservation',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.restaurant,
                            size: 40,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(Icons.queue, color: Colors.blue),
                            label: Text('예약하기'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue,
                              side: BorderSide(color: Colors.blue),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/search');
                            },
                          ),
                          SizedBox(width: 16),
                          ElevatedButton.icon(
                            icon: Icon(Icons.list_alt, color: Colors.blue),
                            label: Text('대기순번'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue,
                              side: BorderSide(color: Colors.blue),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/waitingNumber');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.blue[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '이력조회',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'history',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.view_list,
                                  size: 40,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  icon: Icon(Icons.queue, color: Colors.blue),
                                  label: Text('이력조회'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.blue,
                                    side: BorderSide(color: Colors.blue),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/historyList');
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Card(
                      color: Colors.blue[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '즐겨찾기',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'favorite',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.star_outline,
                                  size: 40,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  icon: Icon(Icons.queue, color: Colors.blue),
                                  label: Text('즐겨찾기'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.blue,
                                    side: BorderSide(color: Colors.blue),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/favorite');
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Card(
                color: Colors.blue[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '커뮤니티',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'community',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.people_alt,
                            size: 40,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(Icons.queue, color: Colors.blue),
                            label: Text('커뮤니티'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue,
                              side: BorderSide(color: Colors.blue),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/community');
                            },
                          ),
                          SizedBox(width: 16),
                          ElevatedButton.icon(
                            icon: Icon(Icons.list_alt, color: Colors.blue),
                            label: Text('글쓰기'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue,
                              side: BorderSide(color: Colors.blue),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/communityWrite');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                  onPressed: () => FlutterLocalNotification.showNotification(
                        'Button 3 Title',
                        '3 Body',
                      ),
                  child: Text("알림")),
              ElevatedButton(
                onPressed: () {
                  NotificationService.sendSmsNotification(
                      'Hello, this is a test message!', ['01023209299']);
                },
                child: Text('Send SMS'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: menuButtom(),
    );
  }
}
