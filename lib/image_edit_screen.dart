
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:crop_your_image/crop_your_image.dart';

class ImageEditScreen extends StatefulWidget {
  final Uint8List imageBytes;

  ImageEditScreen({required this.imageBytes});

  @override
  _ImageEditScreenState createState() => _ImageEditScreenState();
}

class _ImageEditScreenState extends State<ImageEditScreen> {
  Uint8List? _imageBytes;
  img.Image? _image;
  bool _isCropping = true; // Directly open crop adjust screen
  final CropController _cropController = CropController();

  @override
  void initState() {
    super.initState();
    _imageBytes = widget.imageBytes;
    _image = img.decodeImage(_imageBytes!)!;
  }

  void _rotateImage() {
    setState(() {
      _image = img.copyRotate(_image!, 90);
      _imageBytes = Uint8List.fromList(img.encodeJpg(_image!));
    });
  }

  void _flipHorizontally() {
    setState(() {
      _image = img.flipHorizontal(_image!);
      _imageBytes = Uint8List.fromList(img.encodeJpg(_image!));
    });
  }

  void _flipVertically() {
    setState(() {
      _image = img.flipVertical(_image!);
      _imageBytes = Uint8List.fromList(img.encodeJpg(_image!));
    });
  }

  void _onCrop(Uint8List croppedData) {
    setState(() {
      _imageBytes = croppedData;
      _image = img.decodeImage(croppedData)!;
      _isCropping = false;
    });
    Navigator.pop(context, croppedData); // Pass the cropped image back to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        backgroundColor: Color(0xDD000000),
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.rotate_right, color: Colors.white),
            onPressed: _rotateImage,
          ),
          PopupMenuButton<String>(
            color: Colors.black,
            icon: Icon(Icons.flip, color: Colors.white),
            onSelected: (String value) {
              if (value == 'Flip Horizontally') {
                _flipHorizontally();
              } else if (value == 'Flip Vertically') {
                _flipVertically();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Flip Horizontally',
                child: Text('Flip Horizontally',style: TextStyle(color: Colors.white),),
              ),
              const PopupMenuItem<String>(
                value: 'Flip Vertically',
                child: Text('Flip Vertically',style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
          TextButton(
            onPressed: () => _cropController.crop(),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Adjust padding as needed
            ),
            child: Text(
              'CROP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0, // Adjust font size as needed
                fontWeight: FontWeight.bold, // Optional: Set font weight if needed
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: _isCropping
            ? Column(
          children: [
            Expanded(
              child: Crop(
                image: _imageBytes!,
                controller: _cropController,
                onCropped: _onCrop,
              ),
            ),
          ],
        )
            : Center(
          child: _imageBytes == null
              ? Text('No image selected.', style: TextStyle(color: Colors.white))
              : Image.memory(_imageBytes!),
        ),
      ),
    );
  }
}
