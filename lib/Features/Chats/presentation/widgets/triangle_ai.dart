import 'package:flutter/material.dart';
class TriangleClipperAi extends CustomClipper<Path> {


  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height*0.5);
    path.lineTo(size.width*0.55, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}