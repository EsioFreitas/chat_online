import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  Firestore.instance
      .collection("mensagens")
      .document()
      .setData({"from": "Daniel", "texto": "Ola!"});
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat app",
      debugShowCheckedModeBanner: false,
      home: chatScreen(),
    );
  }
}

class chatScreen extends StatefulWidget {
  @override
  _chatScreenState createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat App"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView(
                children: <Widget>[
                  ChatMessage(),
                  ChatMessage(),
                  ChatMessage(),
                ],
              ),

          ),
          Divider(
            height: 1,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme
                  .of(context)
                  .cardColor,
            ),
            child: TextComposer(),
          )
        ],
      ),
    );
  }
}

class TextComposer extends StatefulWidget {
  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {
  bool _isCompose = false;

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme
          .of(context)
          .accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: <Widget>[
            Container(
              child:
              IconButton(icon: Icon(Icons.photo_camera), onPressed: () {}),
            ),
            Expanded(
              child: TextField(
                decoration:
                InputDecoration.collapsed(hintText: "Enviar uma mensagem"),
                onChanged: (text) {
                  setState(() {
                    _isCompose = text.length > 0;
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: IconButton(
                  icon: Icon(Icons.send), onPressed: _isCompose ? () {} : null),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://t3.ftcdn.net/jpg/02/76/19/80/240_F_276198003_Hrr4gw0CQ3jbU8jr17kecXw9TZpgE3xM.jpg"),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Amanda",
                  style: Theme
                      .of(context)
                      .textTheme
                      .subhead,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Text("Teste"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
