//이전버전 프로필

// import 'dart:io';

// import 'package:capstone_agomin/profile/profiledata.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class Profile extends StatefulWidget {
//   @override
//   _ProfileState createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   User _user;
//   File _image;
//   final picker = ImagePicker();

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();
//   final TextEditingController _speciesController = TextEditingController();

//   FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
//   String _profileImageURL = "";

//   //현재 유저 불러오기
//   Future<void> setUser() async {
//     _user = _firebaseAuth.currentUser;
//   }

//   Future getImage(ImageSource source) async {
//     final pickedFile = await picker.getImage(source: source);

//     //이미지 사진첩이나 카메라에서 경로 받아오기
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });

//     setUser();

//     // 프로필 사진을 업로드할 경로와 파일명을 정의. 사용자의 uid를 이용하여 파일명의 중복 가능성 제거
//     StorageReference storageReference =
//         _firebaseStorage.ref().child("profile/${_user.uid}");

//     // 파일 업로드
//     StorageUploadTask storageUploadTask = storageReference.putFile(_image);

//     // 파일 업로드 완료까지 대기
//     await storageUploadTask.onComplete;

//     print(storageReference.getDownloadURL());
//     // 업로드한 사진의 URL 획득
//     String downloadURL = (await storageReference.getDownloadURL()).toString();
//     print(downloadURL);
//     // 업로드된 사진의 URL을 페이지에 반영
//     setState(() {
//       _profileImageURL = downloadURL;
//     });
//   }

//   Widget _buildCameraButton() {
//     return InkWell(
//       child: Icon(
//         Icons.photo_camera,
//         color: Colors.white,
//       ),
//       onTap: () async {
//         await getImage(ImageSource.camera);
//       },
//     );
//   }

//   Widget _buildPhotoAlbumButton() {
//     return InkWell(
//       child: Icon(
//         Icons.photo_library,
//         color: Colors.white,
//       ),
//       onTap: () async {
//         await getImage(ImageSource.gallery);
//       },
//     );
//   }

//   Widget _inputImage() {
//     return Container(
//       width: 250,
//       height: 250,
//       padding: EdgeInsets.all(10),
//       child: Stack(
//         alignment: Alignment.bottomCenter,
//         children: <Widget>[
//           Container(
//             child: _image == null
//                 ? Image.asset('assets/logo.jpg', fit: BoxFit.cover)
//                 : Image.file(_image, fit: BoxFit.cover),
//             //이미지 초기 이미지는 로고 만약 저장됐으면 FIrebase에서 이미지
//           ),
//           Container(
//             color: Colors.black54,
//             height: 40,
//           ),
//           ButtonBar(
//             alignment: MainAxisAlignment.end,
//             children: <Widget>[
//               _buildCameraButton(),
//               _buildPhotoAlbumButton(),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget _inputForm(Size size) {
//     return Padding(
//       padding: EdgeInsets.all(size.width * 0.05),
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         elevation: 6,
//         child: Padding(
//           padding:
//               const EdgeInsets.only(left: 12.0, right: 16, top: 12, bottom: 32),
//           child: Form(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: InputDecoration(
//                     icon: Icon(Icons.assignment_ind),
//                     labelText: "이름",
//                   ),
//                 ),
//                 TextFormField(
//                   controller: _ageController,
//                   decoration: InputDecoration(
//                     icon: Icon(Icons.cake),
//                     labelText: "나이",
//                   ),
//                 ),
//                 TextFormField(
//                   controller: _speciesController,
//                   decoration: InputDecoration(
//                     icon: Icon(Icons.tag_faces),
//                     labelText: "견종",
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future _uploadFile(BuildContext context) async {
//     // 스토리지에 업로드할 파일 경로
//     final firebaseStorageRef = FirebaseStorage.instance
//         .ref()
//         .child('profile')
//         .child('${DateTime.now().millisecondsSinceEpoch}.png'); // 파일 경로

//     // 파일 업로드
//     final task = firebaseStorageRef.putFile(
//       _image,
//       StorageMetadata(contentType: 'image/png'),
//     );

//     // 완료까지 기다림
//     final storageTaskSnapshot = await task.onComplete;

//     // 업로드 완료 후 url
//     final downloadURL = await storageTaskSnapshot.ref.getDownloadURL();

//     // 문서 작성
//     await FirebaseFirestore.instance.collection('profile').add({
//       'email': _user.email,
//       'photoURL': downloadURL,
//       'name': _nameController.text,
//       'age': _ageController.text,
//       'species': _speciesController.text,
//     });

//     // 완료 후 앞 화면으로 이동
//     Navigator.pop(context);
//   }

//   Widget _inputData() {
//     return RaisedButton(
//       child: Text('저장하기'),
//       onPressed: () {
//         _uploadFile(context);
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;

//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.all(20),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               _inputImage(),
//               _inputForm(size),
//               SizedBox(
//                 height: 50,
//               ),
//               _inputData(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
