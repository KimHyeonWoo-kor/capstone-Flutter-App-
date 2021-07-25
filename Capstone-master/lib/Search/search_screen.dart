import 'package:cached_network_image/cached_network_image.dart';
import 'package:capstone_agomin/Sns/post_detail_screen.dart';
import 'package:capstone_agomin/Helper/repository.dart';
import 'package:capstone_agomin/Helper/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//체크포인트
import 'package:flutter/material.dart';

import '../Sns/other_user_profile_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var _repository = Repository();
  List<DocumentSnapshot> list = List<DocumentSnapshot>(); //모든유저 post정보
  Member _user = Member();
  Member currentUser;
  List<Member> usersList = List<Member>();

  @override
  void initState() {
    super.initState();
    //현재 유저 불러오기
    _repository.getCurrentUser().then((user) {
      _user.uid = user.uid;
      _user.displayName = user.displayName;
      _user.photoUrl = user.photoURL;
      //currentUser에 uid업데이트
      _repository.fetchUserDetailsById(user.uid).then((user) {
        setState(() {
          currentUser = user;
        });
      });
      print("USER : ${user.displayName}");
      //자신빼고 모든 유저 post불러오기
      _repository.retrievePosts(user).then((updatedList) {
        setState(() {
          list = updatedList;
        });
      });
      //DocumentSnapShot에서 Member객체로 바꿔줌
      _repository.fetchAllUsers(user).then((list) {
        setState(() {
          usersList = list;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("INSIDE BUILD");
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color.fromRGBO(222, 235, 247, 1.0),
          centerTitle: true,
          title: Text(
            'Agomin',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: DataSearch(userList: usersList));
              },
            )
          ],
        ),
        body: Container(
          child: GridView.builder(
              itemCount: list.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0),
              itemBuilder: ((context, index) {
                print("LIST : ${list.length}");
                return GestureDetector(
                  child: CachedNetworkImage(
                    imageUrl: list[index].data()['imgUrl'],
                    placeholder: ((context, s) => Center(
                          child: CircularProgressIndicator(),
                        )),
                    width: 125.0,
                    height: 125.0,
                    fit: BoxFit.cover,
                  ),
                  onTap: () {
                    //클릭시 다른유저 피드로 이동
                    print("SNAPSHOT : ${list[index].reference.path}");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => PostDetailScreen(
                                  user: _user,
                                  currentuser: currentUser,
                                  documentSnapshot: list[index],
                                ))));
                  },
                );
              })),
        ));
  }
}

class DataSearch extends SearchDelegate<String> {
  List<Member> userList;
  DataSearch({this.userList});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
    // return Center(child: Container(width: 50.0, height: 50.0, color: Colors.red, child: Text(query),));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionsList = query.isEmpty
        ? userList
        : userList.where((p) => p.displayName.startsWith(query)).toList();
    return ListView.builder(
      itemCount: suggestionsList.length,
      itemBuilder: ((context, index) => ListTile(
            onTap: () {
              //   showResults(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => UserProfileScreen(
                          name: suggestionsList[index].displayName))));
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(suggestionsList[index].photoUrl),
            ),
            title: Text(suggestionsList[index].displayName),
          )),
    );
  }
}
