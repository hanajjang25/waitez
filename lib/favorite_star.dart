import 'package:flutter/material.dart';

class starButton extends StatefulWidget {
  const starButton({super.key});

  @override
  State<starButton> createState() => _starButtonState();
}

class _starButtonState extends State<starButton> {
  bool _isStarred = false;

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isStarred = !_isStarred; // Toggle the state
        });
      },
      child: Container(
        width: 15,
        height: 15,
        decoration: ShapeDecoration(
          color:
              _isStarred ? Colors.yellow : Colors.white, // Conditional coloring
          shape: StarBorder(
            side: BorderSide(
                width: 1, color: Colors.black), // Ensure the border is visible
            points: 5,
            innerRadiusRatio: 0.38,
            pointRounding: 0,
            valleyRounding: 0,
            rotation: 0,
            squash: 0,
          ),
        ),
      ),
    );
  }
}
