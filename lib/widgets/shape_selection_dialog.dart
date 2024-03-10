import 'package:flutter/material.dart';

import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'dart:math';
import 'dart:io';


enum Shape {
  square,
  rectangle,
  circle,
  heart,
  original,
}

class ShapeSelectionDialog extends StatefulWidget {
  final File originalFile;
  final img.Image modifiedImage;
  final VoidCallback onUseThisImage;

  const ShapeSelectionDialog({
    Key? key,
    required this.originalFile,
    required this.modifiedImage,
    required this.onUseThisImage,
  }) : super(key: key);

  @override
  _ShapeSelectionDialogState createState() => _ShapeSelectionDialogState();
}

class _ShapeSelectionDialogState extends State<ShapeSelectionDialog> {
  img.Image? _currentImage;

  @override
  void initState() {
    super.initState();
    _currentImage = img.copyResize(widget.modifiedImage, width: 300, height: 300);
  }

  void _applyShape(Shape shape) {
    img.Image image = img.copyResize(widget.modifiedImage, width: 300, height: 300);

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
      case Shape.heart:
        _applyHeartShape(image);
        break;
      case Shape.original:
        break;
    }

    setState(() {
      _currentImage = image;
    });
  }

  void _useThisImage() {
    widget.onUseThisImage();
    Navigator.pop(context, _currentImage);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                color: Colors.black,
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const Text('Uploaded Image'),
        ],
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.memory(
            Uint8List.fromList(img.encodePng(_currentImage!)),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => _applyShape(Shape.original),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Container(
                      height: 30,
                      width: 60,
                      child: Center(child: Text("Original")),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _applyShape(Shape.heart),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Container(
                      height: 30,
                      width: 30,
                      child: Image.asset('assets/user_image_frame_1.png'),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _applyShape(Shape.square),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Container(
                      height: 30,
                      width: 30,
                      child: Image.asset('assets/user_image_frame_2.png'),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _applyShape(Shape.circle),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Container(
                      height: 30,
                      width: 30,
                      child: Image.asset('assets/user_image_frame_3.png'),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _applyShape(Shape.rectangle),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: Container(
                      height: 30,
                      width: 30,
                      child: Image.asset('assets/user_image_frame_4.png'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Center(
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            onPressed: _useThisImage,
            child: const Text('Use This Image'),
          ),
        ),
      ],
    );
  }

  void _applySquareShape(img.Image image) {
    int size = image.width < image.height ? image.width : image.height;
    int center = size ~/ 2;
    int radius = size ~/ 3;

    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        double distance = _calculateDistance(x, y, center, center);

        if (distance > radius && x > center - radius && x < center + radius && y > center - radius && y < center + radius) {
          // image.setPixel(x, y, img.getColor(255, 255, 255));
        }
      }
    }
  }

  void _applyHeartShape(img.Image image) {
    int width = image.width;
    int height = image.height;

    int hWidth = width ~/ 2;
    int hHeight = height ~/ 2;
    int hBase = width ~/ 4;
    int hTop = height ~/ 5;

    Path heartPath = Path()
      ..moveTo(hWidth.toDouble(), hHeight.toDouble() - hTop.toDouble())
      ..cubicTo(
        hWidth.toDouble() + hBase.toDouble(),
        hHeight.toDouble() - 2 * hTop.toDouble(),
        hWidth.toDouble() + 2 * hBase.toDouble(),
        hHeight.toDouble(),
        hWidth.toDouble(),
        hHeight.toDouble() + 2 * hTop.toDouble(),
      )
      ..cubicTo(
        hWidth.toDouble() - 2 * hBase.toDouble(),
        hHeight.toDouble(),
        hWidth.toDouble() - hBase.toDouble(),
        hHeight.toDouble() - 2 * hTop.toDouble(),
        hWidth.toDouble(),
        hHeight.toDouble() - hTop.toDouble(),
      );


    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        if (heartPath.contains(Offset(x.toDouble(), y.toDouble()))) {
          image.setPixel(x, y, _currentImage!.getPixel(x, y));
        } else {
          image.setPixel(x, y, img.getColor(255, 255, 255));
        }
      }
    }
  }


  void _applyRectangleShape(img.Image image) {
    int width = image.width;
    int height = image.height;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        if (y > height ~/ 2) {
          image.setPixel(x, y, img.getColor(255, 255, 255));
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

        if (distance >= radius) {
          image.setPixel(x, y, img.getColor(255, 255, 255));
        }
      }
    }
  }

  double _calculateDistance(int x1, int y1, int x2, int y2) {
    return sqrt((x1 - x2).toDouble() * (x1 - x2) + (y1 - y2).toDouble() * (y1 - y2));
  }
}
