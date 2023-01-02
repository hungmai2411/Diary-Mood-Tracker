import 'package:flutter/material.dart';
import 'package:cs214/constants/app_colors.dart';

class SmilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var center = size / 2;
    var paint = Paint()..color = AppColors.textSecondColor;

    canvas.drawCircle(
      Offset(size.width * 0.35, center.height * 0.9),
      size.shortestSide * 0.06,
      paint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.65, center.height * 0.9),
      size.shortestSide * .06,
      paint,
    );

    var controlPoint1 = Offset(size.width * .45, size.height / 1.6);
    var controlPoint2 = Offset(size.width * .55, size.height / 1.6);

    var paint2 = Paint()
      ..color = AppColors.textSecondColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(controlPoint1, controlPoint2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
