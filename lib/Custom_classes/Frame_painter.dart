import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';

// class FramePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..color = Colors.black;
//     final rect = Rect.fromLTWH(0, 0, size.width, size.height);

//     // Draw a darkened region outside the frame
//     canvas.drawRect(rect, paint);

//     // Draw a clear area inside the frame
//     final innerRect = Rect.fromLTWH(
//       size.width * 0.25,
//       size.height * 0.25,
//       size.width * 0.5,
//       size.height * 0.5,
//     );
//     canvas.drawRect(innerRect, Paint()..color = Colors.blue);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }

class FramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black.withOpacity(0.6); // Darkened region color

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );

    // Define the clear area inside the frame
    final clearArea = Rect.fromLTWH(
      size.width * 0.2,
      size.height * 0.2,
      size.width * 0.6,
      size.height * 0.6,
    );

    paint.color = Colors.transparent; // Set the clear area to transparent
    canvas.drawRect(clearArea, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
