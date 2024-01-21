import 'package:flutter/material.dart';

class FlashlightButton extends StatelessWidget {
  final bool isFlashlightOn;
  final Function(bool) onPressed;

  const FlashlightButton({
    required this.isFlashlightOn,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFlashlightOn ? Icons.flash_off : Icons.flash_on,
        color: Color(0xFFF59B15),
        size: 30,
      ),
      onPressed: () => onPressed(!isFlashlightOn),
    );
  }
}
