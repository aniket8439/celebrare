import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:celebrare/utils/image_processing.dart';
import 'package:celebrare/widgets/shape_selection_dialog.dart';
import 'package:image/image.dart' as img;

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  File? _originalFile;
  img.Image? _modifiedImage;

  Future<void> _cropImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File originalFile = File(result.files.single.path!);

      try {
        ImageCropper imageCropper = ImageCropper();
        dynamic croppedResult = await imageCropper.cropImage(
          sourcePath: originalFile.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio16x9,
          ],
          aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 4),
        );

        if (croppedResult is CroppedFile) {
          File croppedFile = File(croppedResult.path);
          img.Image? image = img.decodeImage(croppedFile.readAsBytesSync());


          if (image != null) {
            setState(() {
              _originalFile = originalFile;
              _modifiedImage = image;
            });

            // Show the alert box with shape selection activity
            showDialog(
              context: context,
              builder: (BuildContext context) => ShapeSelectionDialog(
                originalFile: _originalFile!,
                modifiedImage: _modifiedImage!,
                onUseThisImage: () {
                   // Close the dialog
                },
              ),
            ).then((value) => {
              setState(() {
                _modifiedImage = value;
              })
            });
          } else {
            print("Error decoding the image.");
          }
        } else {
          print("Error cropping the image. Result is not a supported type.");
        }
      } catch (e) {
        print("Error during cropping: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(

          statusBarColor: Colors.green,

        ),
        title: const Center(child: Text('Add Image / Icon'),),
        backgroundColor: Colors.white,
        leading: const BackButton(
          color: Colors.black,
        ),
        elevation: 20,
      ),
      body: ListView(
        children: [
          Container(
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
                          const Text(
                            "Upload Image",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
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
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (_modifiedImage != null)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.memory(
                  Uint8List.fromList(img.encodePng(_modifiedImage!)),
                  height: 200,
                  width: 200,
                ),
              ],
            )
          else
            SizedBox.shrink(),
        ],
      ),
    );
  }
}
