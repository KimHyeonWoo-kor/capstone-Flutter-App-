import 'package:capstone_agomin/Home/tap_screen.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'login_screen.dart';
import 'loading_page.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _handleCurrentScreen();
  }

  Widget _handleCurrentScreen() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // 연결 상태가 기다리는 중이라면 로딩 페이지를 반환
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingPage();
        } else {
          //연결되었고 데이터가 있다면
          if (snapshot.hasData) {
            print(
                '기존 아이디 로그인 사용자: ${FirebaseAuth.instance.currentUser.displayName}');
            return HomeScreen();
            //TabPage(snapshot.data);
          } else {
            return LoginScreen();
          }
        }
      },
    );
  }
}
