import 'package:flutter/material.dart';

class ChatMessage extends StatefulWidget {
  ChatMessage({
    this.data,
    this.text,
    this.width,
  });

  final int data;
  final String text;
  final double width;

  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  Color myres = const Color(0xFFFEF01B);

  @override
  Widget build(BuildContext context) {
    if (widget.data == 0) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //아이콘
            Container(
              margin: const EdgeInsets.only(right: 6.0),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/agomin.jpg'),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //이름
                Text(
                  'Agomin',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                //내용
                Container(
                  constraints: BoxConstraints(
                      minWidth: 30,
                      maxWidth: MediaQuery.of(context).size.width * 0.6),
                  margin: const EdgeInsets.only(top: 5.0),
                  padding:
                      EdgeInsets.only(top: 2, bottom: 2, left: 6, right: 6),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(10)),
                    color: Colors.white,
                  ),
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          //아이콘
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                //이름
                Text('나',
                    style: TextStyle(
                      fontSize: 15,
                    )),
                //내용

                Container(
                  constraints: BoxConstraints(
                      minWidth: 30,
                      maxWidth: MediaQuery.of(context).size.width * 0.6),
                  padding:
                      EdgeInsets.only(top: 2, bottom: 2, left: 6, right: 6),
                  margin: const EdgeInsets.only(top: 5.0),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(0)),
                    color: myres,
                  ),
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    softWrap: true,
                    //overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(right: 2.0, left: 6.0),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/agomin.jpg'),
              ),
            ),
          ],
        ),
      );
    }
  }
}
