import 'dart:math';

import 'package:image/image.dart' as img;

enum Shape {
  square,
  rectangle,
  circle,
  original,
}

void applyShape(Shape shape, img.Image image) {
  switch (shape) {
    case Shape.square:
      _applySquareShape(image);
      break;
    case Shape.rectangle:
      _applyRectangleShape(image);
      break;
    case Shape.circle:
      _applyCircleShape(image);
      break;
    case Shape.original:
      break;
  }
}

void _applySquareShape(img.Image image) {
  int size = image.width < image.height ? image.width : image.height;
  int center = size ~/ 2;
  int radius = size ~/ 3;

  for (int y = 0; y < size; y++) {
    for (int x = 0; x < size; x++) {
      double distance = _calculateDistance(x, y, center, center);

      if (distance > radius) {
        image.setPixel(x, y, image.getPixel(center, center));
      }
    }
  }
}

void _applyRectangleShape(img.Image image) {
  int width = image.width;
  int height = image.height;

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      if (y > height ~/ 3) {
        image.setPixel(x, y, image.getPixel(x, y));
      }
    }
  }
}

void _applyCircleShape(img.Image image) {
  int width = image.width;
  int height = image.height;
  int center = width ~/ 2;
  int radius = width ~/ 3;

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      double distance = _calculateDistance(x, y, center, center);

      if (distance <= radius) {
        image.setPixel(x, y, image.getPixel(x, y));
      }
    }
  }
}

double _calculateDistance(int x1, int y1, int x2, int y2) {
  return sqrt((x1 - x2).toDouble() * (x1 - x2) + (y1 - y2).toDouble() * (y1 - y2));
}
