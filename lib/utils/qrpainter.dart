import 'package:flutter/material.dart';

class QrPainter extends CustomPainter {
  final List<List<int>> matrix;
  final Color color;
  final double pixelSize;

  QrPainter({
    required this.matrix,
    this.color = Colors.black,
    this.pixelSize = 10.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (int y = 0; y < matrix.length; y++) {
      for (int x = 0; x < matrix[y].length; x++) {
        if (matrix[y][x] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(QrPainter oldDelegate) {
    return oldDelegate.matrix != matrix ||
        oldDelegate.color != color ||
        oldDelegate.pixelSize != pixelSize;
  }
}
