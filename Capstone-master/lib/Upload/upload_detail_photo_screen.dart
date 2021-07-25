import 'dart:async';
import 'dart:io';
import 'package:capstone_agomin/Helper/repository.dart';
import 'package:flutter/material.dart';

import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'dart:math';

import 'upload_screen.dart';

// ignore: must_be_immutable
class UploadDetailPhotoScreen extends StatefulWidget {
  File imageFile;
  UploadDetailPhotoScreen({this.imageFile});

  @override
  _UploadDetailPhotoScreenState createState() =>
      _UploadDetailPhotoScreenState();
}

class _UploadDetailPhotoScreenState extends State<UploadDetailPhotoScreen> {
  var _locationController;
  var _captionController;
  final _repository = Repository();

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController();
    _captionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _locationController?.dispose();
    _captionController?.dispose();
  }

  bool _visibility = true;

  void _changeVisibility(bool visibility) {
    setState(() {
      _visibility = visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Post',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: new Color(0xfff8faf8),
        elevation: 1.0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 20.0),
            child: GestureDetector(
              child: Text('Share',
                  style: TextStyle(color: Colors.blue, fontSize: 16.0)),
              onTap: () {
                // To show the CircularProgressIndicator
                _changeVisibility(false);

                _repository.getCurrentUser().then((currentUser) {
                  if (currentUser != null) {
                    compressImage();
                    _repository.retrieveUserDetails(currentUser).then((user) {
                      _repository
                          .uploadImageToStorage(widget.imageFile)
                          .then((url) {
                        _repository
                            .addPostToDb(user, url, _captionController.text,
                                _locationController.text)
                            .then((value) {
                          print("Post added to db");
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => UploadScreen())));
                        }).catchError((e) =>
                                print("Error adding current post to db : $e"));
                      }).catchError((e) {
                        print("Error uploading image to storage : $e");
                      });
                    });
                  } else {
                    print("Current User is null");
                  }
                });
              },
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 12.0),
                child: Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(widget.imageFile))),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                  child: TextField(
                    controller: _captionController,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Write a caption...',
                    ),
                    onChanged: ((value) {
                      setState(() {
                        value = _captionController.text;
                      });
                    }),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _locationController,
              onChanged: ((value) {
                setState(() {
                  value = _locationController.text;
                });
              }),
              decoration: InputDecoration(
                hintText: 'Add location',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: FutureBuilder(
                future: locateUser(),
                builder: ((context, AsyncSnapshot<List<Address>> addresses) {
                  //  if (snapshot.hasData) {
                  if (addresses.hasData) {
                    return Row(
                      // alignment: WrapAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          child: Chip(
                            label: Text(addresses.data.first.locality),
                          ),
                          onTap: () {
                            setState(() {
                              _locationController.text =
                                  addresses.data.first.locality;
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: GestureDetector(
                            child: Chip(
                              label: Text(addresses.data.first.adminArea +
                                  ", " +
                                  addresses.data.first.locality),
                            ),
                            onTap: () {
                              setState(() {
                                _locationController.text =
                                    addresses.data.first.adminArea +
                                        ", " +
                                        addresses.data.first.locality;
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    print("Connection State : ${addresses.connectionState}");
                    return CircularProgressIndicator();
                  }
                })),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Offstage(
              child: CircularProgressIndicator(),
              offstage: _visibility,
            ),
          )
        ],
      ),
    );
  }

  void compressImage() async {
    print('starting compression');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);

    Im.Image image = Im.decodeImage(widget.imageFile.readAsBytesSync());
    Im.copyResize(image, width: 500);

    var newim2 = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));

    setState(() {
      widget.imageFile = newim2;
    });
    print('done');
  }

  Future<List<Address>> locateUser() async {
    LocationData currentLocation;
    Future<List<Address>> addresses;

    Location location = new Location();

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      currentLocation = await location.getLocation();

      print(
          'LATITUDE : ${currentLocation.latitude} && LONGITUDE : ${currentLocation.longitude}');

      // From coordinates
      final coordinates =
          new Coordinates(currentLocation.latitude, currentLocation.longitude);

      addresses = Geocoder.local.findAddressesFromCoordinates(coordinates);
    } on PlatformException catch (e) {
      print('ERROR : $e');
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
      currentLocation = null;
    }
    return addresses;
  }
}
