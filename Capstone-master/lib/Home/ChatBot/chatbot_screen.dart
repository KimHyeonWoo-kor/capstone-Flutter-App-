import 'package:flutter/material.dart';
import 'chatbot_detail.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

class AgominChat extends StatefulWidget {
  @override
  _AgominChatState createState() => _AgominChatState();
}

class _AgominChatState extends State<AgominChat> {
  List<ChatMessage> messages = <ChatMessage>[];

//messagInsert.text를 response함으로써 dialogflow에 대답 전달
  void response(query) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/agomin-cyws-55efe8b61e18.json")
            .build(); //API연동키 따로 넣어야될것
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.korean);
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    var containChatBot = ChatMessage(
      data: 0,
      text: aiResponse.getListMessage()[0]["text"]["text"][0].toString(),
      width:
          aiResponse.getListMessage()[0]["text"]["text"][0].length.toDouble(),
    );
    setState(() {
      messages.insert(0, containChatBot);
    });

    //print(containChatBot.width);
  }

  final messageInsert = TextEditingController();
  //리스트 형식으로 객체 생성
  Color bg = const Color(0xFF9BBBD4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   elevation: 0.0,
        //   backgroundColor: Color.fromRGBO(222, 235, 247, 1.0),
        //   centerTitle: true,
        //   title: Text('챗봇', style: TextStyle(color: Colors.black)),
        // ),
        body: Container(
            //밑에서 얼마나 띄어져있는지
            //padding: EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('assets/chatbotBackground.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: <Widget>[
                //채팅창 리스트
                Flexible(child: chatList()),
                //구분선
                Divider(
                  height: 3.0,
                ),
                //입력칸
                Container(
                  color: Colors.white,
                  //margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: inputText(),
                ),
              ],
            )));
  }

  //채팅
  Widget chatList() => ListView.builder(
      reverse: true,
      //최신 응답이 하단에 추가됨
      padding: EdgeInsets.all(10.0),
      itemCount: messages.length,
      //챗봇이 대답 OR 사람 채팅
      itemBuilder: (context, index) => messages[index]);

  //입력 칸
  Widget inputText() => Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: messageInsert,
              onSubmitted: handleSubmitted,
              decoration: InputDecoration.collapsed(hintText: " 입력하시오"),
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => handleSubmitted(messageInsert.text),
              ))
        ],
      );

  //제출 버튼
  void handleSubmitted(String text) {
    var containChat = ChatMessage(
      data: 1,
      text: text,
      width: text.length.toDouble(),
    );

    //print(containChat.width);

    if (messageInsert.text.isEmpty) {
      print("입력하지않음");
    } else {
      setState(() {
        messages.insert(0, containChat);
      });
      response(messages[0].text);
      messageInsert.clear();
    }
  }
}
