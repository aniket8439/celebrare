import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

enum Shape {
  square,
  rectangle,
  circle,
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
    _currentImage = img.copyResize(widget.modifiedImage, width: 200, height: 200);
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
                  Navigator.pop(context); // Close the dialog
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
                onTap: () => _applyShape(Shape.square),
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
                onTap: () => _applyShape(Shape.circle),
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
                onTap: () => _applyShape(Shape.rectangle),
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
                onTap: () => _applyShape(Shape.square),
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

  void _applyShape(Shape shape) {
    img.Image image = img.copyResize(widget.modifiedImage, width: 200, height: 200);

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
      // Do nothing for the original shape
        break;
    }

    setState(() {
      _currentImage = image;
    });
  }

  void _useThisImage() {
    widget.onUseThisImage(); // Callback to close the dialog
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
}
