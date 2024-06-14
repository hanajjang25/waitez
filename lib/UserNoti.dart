import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification.dart';

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
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      smsAlert = prefs.getBool('smsAlert') ?? false;
      appAlert = prefs.getBool('appAlert') ?? false;
    });
  }

  void _savePreference(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  void _toggleAppAlert() {
    if (!mounted) return;
    setState(() {
      appAlert = !appAlert;
      _savePreference('appAlert', appAlert);
      debugPrint("App Alert: $appAlert");
    });
  }

  void _toggleSmsAlert() {
    if (!mounted) return;
    setState(() {
      smsAlert = !smsAlert;
      _savePreference('smsAlert', smsAlert);
      debugPrint("SMS Alert: $smsAlert");
    });
  }

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
                _toggleSmsAlert();
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text('앱 알림'),
            trailing: Switch(
              value: appAlert,
              onChanged: (value) {
                _toggleAppAlert();
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
                '불참횟수',
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
          SizedBox(height: 50),
          Text(
            '1번',
            style: TextStyle(
              color: Color(0xFF1C1C21),
              fontSize: 18,
              fontFamily: 'Epilogue',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleAppAlert,
        child: Icon(
            appAlert ? Icons.notifications_active : Icons.notifications_off),
      ),
    );
  }
}
