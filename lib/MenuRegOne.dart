import 'package:flutter/material.dart';
import 'MenuItem.dart';

class MenuRegOne extends StatefulWidget {
  final Function(MenuItem) onSave;

  MenuRegOne({required this.onSave});

  @override
  _MenuRegOneState createState() => _MenuRegOneState();
}

class _MenuRegOneState extends State<MenuRegOne> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _originController = TextEditingController();

  void _save() {
    final String name = _nameController.text;
    final int price = int.parse(_priceController.text);
    final String description = _descriptionController.text;
    final String origin = _originController.text;
    final MenuItem item = MenuItem(
      name: name,
      price: price,
      description: description,
      origin: origin,
    );
    widget.onSave(item);
    Navigator.pop(context);
  }

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
                controller: _nameController,
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
                controller: _priceController,
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
                controller: _descriptionController,
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
                controller: _originController,
                decoration: InputDecoration(),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _save,
                child: Text('등록'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
