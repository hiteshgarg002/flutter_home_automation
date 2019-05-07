import 'package:flutter/material.dart';
import 'package:flutter_home_automation/utils/custom_colors.dart';
import 'package:pigment/pigment.dart';

Color mainBGColor = Color(0xFF652A78);
Color redColor = Color(0xFFDE3C10);
Color purpleColor = Color(0xFF8132AD);
Color cyan = Color(0xFF99D5E5);
Color orange = Color(0xFFE97A4D);

class LoginSignupTopCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;

    Paint paint = Paint();

    Path mainBGPath = Path();
    mainBGPath.addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    // paint.color = Colors.white.withOpacity(0.2);
    paint.color=CustomColors.darkGrey;
    canvas.drawPath(mainBGPath, paint);

    Path path = Path();
    path.lineTo(width, 0.0);
    path.lineTo(width, height * 0.85);
    path.quadraticBezierTo(
      width * 0.97,
      height * 0.52,
      width * 0.82,
      height * 0.50,
    );
    path.lineTo(width * 0.18, height * 0.50);
    path.quadraticBezierTo(
      width * 0.03,
      height * 0.48,
      0.0,
      height * 0.15,
    );
    path.close();

    paint.color = CustomColors.grey;
    // paint.shader = LinearGradient(
    //   colors: <Color>[
    //     Colors.purple,
    //     Colors.purple[700],
    //     Colors.purple[900],
    //   ],
    //   stops: [
    //     0.0,
    //     ((0.067 * height) / 100),
    //     // ((0.094 * height) / 100),
    //     // 0.9,
    //     1.0,
    //   ],
    // ).createShader(
    //   path.getBounds(),
    // );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
