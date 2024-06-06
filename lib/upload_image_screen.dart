import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'image_edit_screen.dart'; // Import the ImageEditScreen

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  Uint8List? _imageBytes;
  String? _selectedShape;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final croppedImage = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageEditScreen(imageBytes: bytes),
        ),
      );
      if (croppedImage != null) {
        _showShapeSelectionPopup(croppedImage);
      }
    }
  }


  void _showShapeSelectionPopup(Uint8List croppedImageBytes) {
    setState(() {
      _selectedShape = 'Rect'; // Default shape
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0), // Remove circular corners
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateDialog) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Uploaded image',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ClipPath(
                    clipper: _getClipper(_selectedShape!),
                    child: Image.memory(
                      croppedImageBytes,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildShapeButton(
                          croppedImageBytes, 'Circle', setStateDialog),
                      _buildShapeButton(
                          croppedImageBytes, 'Rect', setStateDialog),
                      _buildShapeButton(
                          croppedImageBytes, 'Square', setStateDialog),
                      _buildShapeButton(
                          croppedImageBytes, 'Heart', setStateDialog),
                    ],
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _imageBytes =
                            croppedImageBytes; // Update _imageBytes with the new image data
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF004D40),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Adjust the value for different corner radius
                      ),
                    ),
                    child: Text('Use this image',style: TextStyle(color: Colors.white),),
                  ),
                  SizedBox(height: 10),
                ],
              );
            },
          ),
        );
      },
    );
  }


  Widget _buildShapeButton(
      Uint8List croppedImageBytes, String shape, StateSetter setStateDialog) {
    return GestureDetector(
      onTap: () {
        setStateDialog(() {
          _selectedShape = shape;
        });
      },
      child: ClipPath(
        clipper: _getClipper(shape),
        child: Image.memory(
          croppedImageBytes,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  CustomClipper<Path> _getClipper(String shape) {
    switch (shape) {
      case 'Circle':
        return CircleClipper();
      case 'Rect':
        return RectangleClipper();
      case 'Square':
        return SquareClipper();
      case 'Heart':
        return HeartClipper();
      default:
        return RectangleClipper();
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFF004D40), // Set the status bar color
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: AppBar(
            title: Text('Add Image / Icon',
                style: TextStyle(color: Colors.black54)),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black54,
              ),
              onPressed: () {},
              color: Colors.white,
            ),
            //backgroundColor: Color(0xFF004D40),
            elevation: 0.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 140,
              margin: EdgeInsets.all(20.0),
              padding: EdgeInsets.symmetric(vertical: 20.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Upload Image',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF004D40),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8), // Adjust the value for different corner radius
                      ),
                    ),
                    child: Text(
                      'Choose from Device',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            if (_imageBytes != null)
              Container(
                margin: EdgeInsets.all(20.0),
                child: ClipPath(
                  clipper: _getClipper(_selectedShape ?? 'Rect'),
                  child: Image.memory(_imageBytes!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height));
  }

  @override
  bool shouldReclip(CircleClipper oldClipper) => false;
}
class SquareClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double dimension = size.shortestSide;
    return Path()..addRect(Rect.fromLTWH(0, 0, dimension, dimension));
  }

  @override
  bool shouldReclip(SquareClipper oldClipper) => false;
}


class RectangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width + 20.0; // Increase the width of the rectangle
    double height = size.height;
    return Path()..addRect(Rect.fromLTWH(0, 0, width, height));
  }

  @override
  bool shouldReclip(RectangleClipper oldClipper) => false;
}


class HeartClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 2, size.height / 4);
    path.quadraticBezierTo(3 * size.width / 4, 0, size.width, size.height / 4);
    path.quadraticBezierTo(
        size.width, 3 * size.height / 4, size.width / 2, size.height);
    path.quadraticBezierTo(0, 3 * size.height / 4, 0, size.height / 4);
    path.quadraticBezierTo(size.width / 4, 0, size.width / 2, size.height / 4);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(HeartClipper oldClipper) => false;
}

