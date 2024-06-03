import 'package:flutter/material.dart';

class noti extends StatefulWidget {
  const noti({super.key});

  @override
  State<noti> createState() => _NotiState();
}

class _NotiState extends State<noti> {
  bool smsAlert = false;
  bool appAlert = false;

  final List<String> notifications = [
    "You have a new message from John.",
    "Your order has been shipped.",
    "Meeting at 3 PM.",
    "Don't forget to water the plants.",
    "New comment on your post.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('알림'),
      ),
      body: Column(
        children: [
          Divider(),
          ListTile(
            title: Text('SMS알림'),
            trailing: Switch(
              value: smsAlert,
              onChanged: (value) {
                setState(() {
                  smsAlert = value;
                });
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text('앱 알림'),
            trailing: Switch(
              value: appAlert,
              onChanged: (value) {
                setState(() {
                  appAlert = value;
                });
              },
            ),
          ),
          Divider(),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(children: [
              SizedBox(width: 15),
              Text(
                '알림',
                style: TextStyle(
                  color: Color(0xFF1C1C21),
                  fontSize: 18,
                  fontFamily: 'Epilogue',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ]),
          ),
          SizedBox(height: 10),
          Divider(color: Colors.black, thickness: 2.0),
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text(notifications[index]),
                  onTap: () {
                    // 각 알림을 클릭했을 때의 동작을 정의합니다.
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Notification"),
                          content: Text(notifications[index]),
                          actions: [
                            TextButton(
                              child: Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
