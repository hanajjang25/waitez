import 'package:flutter/material.dart';

class MenuEdit extends StatefulWidget {
  @override
  _MenuRegOneState createState() => _MenuRegOneState();
}

class _MenuRegOneState extends State<MenuEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '메뉴 등록',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              Text(
                '메뉴 정보',
                style: TextStyle(
                  color: Color(0xFF1C1C21),
                  fontSize: 18,
                  fontFamily: 'Epilogue',
                  height: 0.07,
                  letterSpacing: -0.27,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 20),
              Container(
                  width: 500,
                  child: Divider(color: Colors.black, thickness: 2.0)),
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 358,
                  height: 201,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/malatang.png"),
                        fit: BoxFit.fill),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Text(
                '메뉴명',
                style: TextStyle(
                  color: Color(0xFF1C1C21),
                  fontSize: 18,
                  fontFamily: 'Epilogue',
                  height: 0.07,
                  letterSpacing: -0.27,
                ),
              ),
              TextField(
                decoration: InputDecoration(),
              ),
              SizedBox(height: 50),
              Text(
                '가격',
                style: TextStyle(
                  color: Color(0xFF1C1C21),
                  fontSize: 18,
                  fontFamily: 'Epilogue',
                  height: 0.07,
                  letterSpacing: -0.27,
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  suffixText: '원',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 50),
              Text(
                '설명',
                style: TextStyle(
                  color: Color(0xFF1C1C21),
                  fontSize: 18,
                  fontFamily: 'Epilogue',
                  height: 0.07,
                  letterSpacing: -0.27,
                ),
              ),
              TextField(
                decoration: InputDecoration(),
              ),
              SizedBox(height: 50),
              Text(
                '원산지',
                style: TextStyle(
                  color: Color(0xFF1C1C21),
                  fontSize: 18,
                  fontFamily: 'Epilogue',
                  height: 0.07,
                  letterSpacing: -0.27,
                ),
              ),
              TextField(
                decoration: InputDecoration(),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {},
                child: Text('수정'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
