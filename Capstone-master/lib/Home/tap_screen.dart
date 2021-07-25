import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';
import '../Upload/upload_screen.dart';
import '../Follower/follow_feed_screen.dart';
import '../Profile/profile_screen.dart';
import '../Search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

PageController pageController;

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
    pageController = new PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new PageView(
        children: [
          new Container(color: Colors.white, child: ActivityScreen()),
          new Container(
            color: Colors.white,
            child: FollowFeedScreen(),
          ),
          new Container(color: Colors.white, child: SearchScreen()),
          new Container(
            color: Colors.white,
            child: UploadScreen(),
          ),
          new Container(color: Colors.white, child: ProfileScreen()),
        ],
        controller: pageController,
        physics: new NeverScrollableScrollPhysics(),
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: new CupertinoTabBar(
        backgroundColor: Color.fromRGBO(222, 235, 247, 1.0),
        // activeColor: Colors.orange,
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
              icon: new Icon(Icons.star,
                  color: (_page == 0) ? Colors.black : Colors.grey),
              // ignore: deprecated_member_use
              title: new Container(height: 0.0),
              backgroundColor: Colors.white),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.home,
                  color: (_page == 1) ? Colors.black : Colors.grey),
              // ignore: deprecated_member_use
              title: new Container(height: 0.0),
              backgroundColor: Colors.white),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.search,
                  color: (_page == 2) ? Colors.black : Colors.grey),
              // ignore: deprecated_member_use
              title: new Container(height: 0.0),
              backgroundColor: Colors.white),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.add_circle,
                  color: (_page == 3) ? Colors.black : Colors.grey),
              // ignore: deprecated_member_use
              title: new Container(height: 0.0),
              backgroundColor: Colors.white),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.person,
                  color: (_page == 5) ? Colors.black : Colors.grey),
              // ignore: deprecated_member_use
              title: new Container(height: 0.0),
              backgroundColor: Colors.white),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}
