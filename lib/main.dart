import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';

enum Shape {
  square,
  rectangle,
  circle,
  original,
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.green,
        backgroundColor: Colors.white70,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 2),
          () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SecondScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Celebrare",
            style: TextStyle(
              fontSize: 30,
              color: Colors.black,
              fontWeight: FontWeight.w900,
              decoration: TextDecoration.none,
            ),
          )
        ],
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  File? _originalFile;
  CroppedFile? _croppedFile;

  Future<void> _cropImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File originalFile = File(result.files.single.path!);

      final ImageCropper imageCropper = ImageCropper();
      CroppedFile? croppedFile = await imageCropper.cropImage(
        cropStyle: CropStyle.rectangle, // Adjust this based on your preference
        sourcePath: originalFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: 1000,
        maxHeight: 1000,
        compressFormat: ImageCompressFormat.png,
      );

      if (croppedFile != null) {
        setState(() {
          _originalFile = originalFile;
          _croppedFile = croppedFile;
        });
      }
    }
  }


  void _showVignetteOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildVignetteButton('Square', Shape.square),
              _buildVignetteButton('Rectangle', Shape.rectangle),
              _buildVignetteButton('Circle', Shape.circle),
              _buildVignetteButton('Original', Shape.original),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Perform action to use the image with vignette
                  Navigator.pop(context);
                },
                child: Text('Use Image'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVignetteButton(String text, Shape shape) {
    return ElevatedButton(
      onPressed: () {
        // Perform action based on selected vignette shape
        // For example, apply vignette effect to _croppedFile
      },
      child: Text(text),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.green,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Image / Icon'),
        backgroundColor: Colors.white,
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Upload Image", style: TextStyle(fontStyle: FontStyle.italic)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: _cropImage,
                    child: const Text('Choose from Device'),
                  ),
                  const SizedBox(height: 20),
                if (_croppedFile != null)
            Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.file(
                File(_croppedFile!.path),
                height: 200,
                width: 200,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _showVignetteOptions(context),
                child: const Text('Add Image'),
              ),
            ],
          )
            else
            SizedBox.shrink(),
        ],
      ),
    ),
    ),
    ),
    ),
    );
  }
}