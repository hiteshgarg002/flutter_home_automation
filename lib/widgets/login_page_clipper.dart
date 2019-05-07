import 'package:flutter/material.dart';

class LoginPageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // final Path path = Path();
    // path.lineTo(0.0, size.height);

    // var firstEndPoint = Offset(size.width * .5, size.height - ((4.064 * height) / 100));
    // var firstControlpoint = Offset(size.width * 0.25, size.height - 50.0);
    // path.quadraticBezierTo(firstControlpoint.dx, firstControlpoint.dy,
    //     firstEndPoint.dx, firstEndPoint.dy);

    // var secondEndPoint = Offset(size.width, size.height - 80.0);
    // var secondControlPoint = Offset(size.width * .75, size.height - 10);
    // path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
    //     secondEndPoint.dx, secondEndPoint.dy);

    // path.lineTo(size.width, 0.0);
    // path.close();
    // return path;

    // final Path path = Path();
    // path.lineTo(0.0, size.height-size.height*0.15);

    // var firstEndPoint = Offset(size.width * .70, size.height*0.76);
    // var firstControlpoint = Offset(size.width * 0.08, size.height*0.37);
    // path.quadraticBezierTo(firstControlpoint.dx, firstControlpoint.dy,
    //     firstEndPoint.dx, firstEndPoint.dy);

    // var secondEndPoint = Offset(size.width, size.height*0.70);
    // var secondControlPoint = Offset(size.width * .88, size.height-size.height*0.14);
    // path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
    //     secondEndPoint.dx, secondEndPoint.dy);

    // path.lineTo(size.width, 0.0);
    // path.close();
    // return path;

    final Path path = Path();
    path.lineTo(0.0, size.height);

    var firstEndPoint = Offset(size.width * .55, size.height*0.83);
    var firstControlpoint = Offset(size.width * 0.15, size.height*0.65);
    path.quadraticBezierTo(firstControlpoint.dx, firstControlpoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height*0.77);
    var secondControlPoint = Offset(size.width * .84, size.height);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return oldClipper != this;
  }
}
