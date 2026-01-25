// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;

void main() {
  print('Generating app icon...');

  const size = 1024;
  const primaryBlue = 0xFF2563EB;
  const white = 0xFFFFFFFF;

  // Create image with transparent background initially
  final image = img.Image(width: size, height: size);

  // Fill with primary blue color
  for (var y = 0; y < size; y++) {
    for (var x = 0; x < size; x++) {
      image.setPixelRgba(x, y,
        (primaryBlue >> 16) & 0xFF,  // R
        (primaryBlue >> 8) & 0xFF,   // G
        primaryBlue & 0xFF,          // B
        255                          // A
      );
    }
  }

  // Draw two curved swap arrows
  final center = size ~/ 2;
  final arrowRadius = size * 0.28;
  final arrowWidth = size * 0.08;

  // Draw circular arrow paths (representing exchange/swap)
  _drawSwapArrows(image, center, arrowRadius.toInt(), arrowWidth.toInt(), white);

  // Save the image
  final outputPath = 'assets/icons/app_icon.png';
  final outputFile = File(outputPath);
  outputFile.parent.createSync(recursive: true);
  outputFile.writeAsBytesSync(img.encodePng(image));

  print('App icon generated at: $outputPath');
}

void _drawSwapArrows(img.Image image, int center, int radius, int width, int color) {
  final r = (color >> 16) & 0xFF;
  final g = (color >> 8) & 0xFF;
  final b = color & 0xFF;

  // Draw two semi-circular arrows representing exchange
  // Top-right arrow (going clockwise)
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

  // Draw arrowhead for top arrow
  _drawArrowHead(image, center, radius, 150.0, width, r, g, b);

  // Bottom-left arrow (going counter-clockwise, offset by 180 degrees)
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

  // Draw arrowhead for bottom arrow
  _drawArrowHead(image, center, radius, 330.0, width, r, g, b);
}

void _drawArrowHead(img.Image image, int center, int radius, double angle, int width, int r, int g, int b) {
  final rad = angle * pi / 180;
  final tipX = center + (radius * cos(rad)).toInt();
  final tipY = center + (radius * sin(rad)).toInt();

  final arrowSize = width * 2;

  // Draw triangular arrowhead
  for (var i = 0; i < arrowSize; i++) {
    for (var j = -i; j <= i; j++) {
      // Rotate the arrowhead to point in the direction of movement
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