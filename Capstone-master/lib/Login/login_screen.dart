import 'package:capstone_agomin/Home/tap_screen.dart';
import 'package:flutter/material.dart';

import 'package:capstone_agomin/Helper/repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _repository = Repository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/loginBackground.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              Expanded(flex: 4, child: SizedBox()),
              Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xFF4285F4),
                            border: Border.all(color: Colors.black)),
                        child: Row(
                          children: <Widget>[
                            Image.asset('assets/google_icon.jpg'),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text('Sign in with Google',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0)),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        _repository.signIn().then((user) {
                          if (user != null) {
                            authenticateUser(user);
                          } else {
                            print("Error");
                          }
                        });
                      },
                    ),
                  )),
              Expanded(flex: 2, child: SizedBox()),
            ],
          )),
    );
  }

  void authenticateUser(User user) {
    print("Inside Login Screen -> authenticateUser");
    _repository.authenticateUser(user).then((value) {
      if (value) {
        print("VALUE : $value");
        print("INSIDE IF");
        _repository.addDataToDb(user).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        });
      } else {
        print("INSIDE ELSE");
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
    });
  }
}
