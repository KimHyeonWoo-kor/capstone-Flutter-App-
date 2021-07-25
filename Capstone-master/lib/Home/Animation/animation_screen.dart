import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';

class AgominAnimation extends StatefulWidget {
  @override
  _AgominAnimationState createState() => _AgominAnimationState();
}

class _AgominAnimationState extends State<AgominAnimation> {
  AudioCache _player = AudioCache();
  AudioPlayer aaa = AudioPlayer();
  bool now = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/animaitionBackground.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            Expanded(flex: 3, child: SizedBox()),
            Expanded(
                flex: 1,
                child: Container(
                    child: ConstrainedBox(
                        constraints: BoxConstraints.expand(),
                        child: FlatButton(
                            onPressed: () {
                              _player.play('click.mp3');
                            },
                            padding: EdgeInsets.all(0.0),
                            child: Image.asset('assets/clicker.png'))))),
            Expanded(
                flex: 1,
                child: Container(
                    child: ConstrainedBox(
                        constraints: BoxConstraints.expand(),
                        child: FlatButton(
                            onPressed: () {
                              if (now == false) {
                                aaa.play('dancingMusic.m4a');
                                now = !now;
                              } else {
                                aaa.stop();
                                now = !now;
                              }
                            },
                            padding: EdgeInsets.all(0.0),
                            child: Image.asset('assets/dancingMusic.png'))))),
            Expanded(
                flex: 1,
                child: Container(
                    child: ConstrainedBox(
                        constraints: BoxConstraints.expand(),
                        child: FlatButton(
                            onPressed: () {
                              _player.play('sleepMusic.m4a');
                            },
                            padding: EdgeInsets.all(0.0),
                            child: Image.asset('assets/sleepMusic.png'))))),
          ],
        ),
      ),
    );
  }
}
