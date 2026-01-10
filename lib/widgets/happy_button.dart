import 'package:flutter/material.dart';

class HappyButton extends StatefulWidget {
  final VoidCallback onPressed;

  const HappyButton({super.key, required this.onPressed});

  @override
  State<HappyButton> createState() => _HappyButtonState();
}

class _HappyButtonState extends State<HappyButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) {
        setState(() => isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => isPressed = false),
      child: SizedBox(
        width: 94,
        height: 102,
        child: Image.asset(
          isPressed
              ? 'assets/MoodHappySelected.png'
              : 'assets/MoodHappy.png',
        ),
      ),
    );
  }
}
