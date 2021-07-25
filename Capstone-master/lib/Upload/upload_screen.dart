import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import 'upload_detail_photo_screen.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File imageFile;

  Future<File> _pickImage(String action) async {
    File selectedImage;

    if (action == 'Gallery') {
      selectedImage =
          // ignore: deprecated_member_use
          await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    // ignore: deprecated_member_use
    // : await ImagePicker.pickImage(source: ImageSource.camera);

    if (action == 'Camera') {
      selectedImage =
          // ignore: deprecated_member_use
          await ImagePicker.pickImage(source: ImageSource.camera);
    }
    // ignore: deprecated_member_use
    //   : await ImagePicker.pickImage(source: ImageSource.gallery);

    return selectedImage;
  }

  _showImageDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Choose from Gallery'),
                onPressed: () {
                  _pickImage('Gallery').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => UploadDetailPhotoScreen(
                                  imageFile: imageFile,
                                ))));
                  });
                },
              ),
              SimpleDialogOption(
                child: Text('Take Photo'),
                onPressed: () {
                  _pickImage('Camera').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => UploadDetailPhotoScreen(
                                  imageFile: imageFile,
                                ))));
                  });
                },
              ),
              SimpleDialogOption(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color.fromRGBO(222, 235, 247, 1.0),
          centerTitle: true,
          title: Text(
            'Agomin',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/UploadBackground.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: SizedBox(),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                        child: ConstrainedBox(
                            constraints: BoxConstraints.expand(),
                            child: FlatButton(
                                onPressed: () {
                                  _pickImage('Camera').then((selectedImage) {
                                    setState(() {
                                      imageFile = selectedImage;
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                UploadDetailPhotoScreen(
                                                  imageFile: imageFile,
                                                ))));
                                  });
                                },
                                padding: EdgeInsets.all(0.0),
                                child: Image.asset(
                                  'assets/takePicture.png',
                                ))))),
                Expanded(
                    flex: 1,
                    child: Container(
                        child: ConstrainedBox(
                            constraints: BoxConstraints.expand(),
                            child: FlatButton(
                                onPressed: () {
                                  _pickImage('Gallery').then((selectedImage) {
                                    setState(() {
                                      imageFile = selectedImage;
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                UploadDetailPhotoScreen(
                                                  imageFile: imageFile,
                                                ))));
                                  });
                                },
                                padding: EdgeInsets.all(0.0),
                                child:
                                    Image.asset('assets/loadPicture.png'))))),
              ],
            )));
  }
}

// RaisedButton.icon(
//             splashColor: Colors.yellow,
//             shape: StadiumBorder(),
//             color: Colors.black,
//             label: Text(
//               'Upload Image',
//               style: TextStyle(color: Colors.white),
//             ),
//             icon: Icon(
//               Icons.cloud_upload,
//               color: Colors.white,
//             ),
//             onPressed: _showImageDialog,
//           )
