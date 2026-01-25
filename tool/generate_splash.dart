// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;

void main() {
  print('Generating splash icon...');

  // Splash icon should be smaller and centered
  const size = 512;
  const white = 0xFFFFFFFF;
  const primaryBlue = 0xFF2563EB;

  // Create transparent image
  final image = img.Image(width: size, height: size);

  // Fill with transparent
  for (var y = 0; y < size; y++) {
    for (var x = 0; x < size; x++) {
      image.setPixelRgba(x, y, 0, 0, 0, 0);
    }
  }

  // Draw a circle with the primary color
  final center = size ~/ 2;
  final circleRadius = size * 0.45;

  for (var y = 0; y < size; y++) {
    for (var x = 0; x < size; x++) {
      final dx = x - center;
      final dy = y - center;
      final dist = sqrt(dx * dx + dy * dy);
      if (dist <= circleRadius) {
        image.setPixelRgba(x, y,
          (primaryBlue >> 16) & 0xFF,
          (primaryBlue >> 8) & 0xFF,
          primaryBlue & 0xFF,
          255
        );
      }
    }
  }

  // Draw swap arrows inside the circle
  final arrowRadius = size * 0.22;
  final arrowWidth = size * 0.06;
  _drawSwapArrows(image, center, arrowRadius.toInt(), arrowWidth.toInt(), white);

  // Save the image
  final outputPath = 'assets/icons/splash_icon.png';
  final outputFile = File(outputPath);
  outputFile.parent.createSync(recursive: true);
  outputFile.writeAsBytesSync(img.encodePng(image));

  print('Splash icon generated at: $outputPath');
}

void _drawSwapArrows(img.Image image, int center, int radius, int width, int color) {
  final r = (color >> 16) & 0xFF;
  final g = (color >> 8) & 0xFF;
  final b = color & 0xFF;

  // Draw two semi-circular arrows
  for (var angle = -30.0; angle < 150.0; angle += 0.5) {
    final rad = angle * pi / 180;
    for (var w = -width ~/ 2; w <= width ~/ 2; w++) {
      final x = center + ((radius + w) * cos(rad)).toInt();
      final y = center + ((radius + w) * sin(rad)).toInt();
      if (x >= 0 && x < image.width && y >= 0 && y < image.height) {
        image.setPixelRgba(x, y, r, g, b, 255);
      }
    }
  }

  _drawArrowHead(image, center, radius, 150.0, width, r, g, b);

  for (var angle = 150.0; angle < 330.0; angle += 0.5) {
    final rad = angle * pi / 180;
    for (var w = -width ~/ 2; w <= width ~/ 2; w++) {
      final x = center + ((radius + w) * cos(rad)).toInt();
      final y = center + ((radius + w) * sin(rad)).toInt();
      if (x >= 0 && x < image.width && y >= 0 && y < image.height) {
        image.setPixelRgba(x, y, r, g, b, 255);
      }
    }
  }

  _drawArrowHead(image, center, radius, 330.0, width, r, g, b);
}

void _drawArrowHead(img.Image image, int center, int radius, double angle, int width, int r, int g, int b) {
  final rad = angle * pi / 180;
  final tipX = center + (radius * cos(rad)).toInt();
  final tipY = center + (radius * sin(rad)).toInt();
  final arrowSize = width * 2;

  for (var i = 0; i < arrowSize; i++) {
    for (var j = -i; j <= i; j++) {
      final perpRad = rad + pi / 2;
      final backRad = rad - pi;
      final px = tipX + (i * cos(backRad) + j * cos(perpRad) * 0.7).toInt();
      final py = tipY + (i * sin(backRad) + j * sin(perpRad) * 0.7).toInt();
      if (px >= 0 && px < image.width && py >= 0 && py < image.height) {
        image.setPixelRgba(px, py, r, g, b, 255);
      }
    }
  }
}