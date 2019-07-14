import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  Firestore.instance
      .collection("mensagens")
      .document()
      .setData({"from": "Daniel", "texto": "Ola!"});
  runApp(MyApp());
}

final googleSingIn = GoogleSignIn();
final auth = FirebaseAuth.instance;

Future<Null> _ensureLoggedIn() async {
  GoogleSignInAccount user = googleSingIn.currentUser;
  if (user == null) {
    user = await googleSingIn.signInSilently();
  }
  if (user == null) {
    user = await googleSingIn.signIn();
  }

  if (await auth.currentUser() == null) {
    GoogleSignInAuthentication credentials =
        await googleSingIn.currentUser.authentication;
    await auth.signInWithCredential(GoogleAuthProvider.getCredential(
        idToken: credentials.idToken, accessToken: credentials.accessToken));
  }
}

_handleSubmitted(String text) async {
  await _ensureLoggedIn();
  _sendMessage(text: text);
}

_sendMessage({String text, String url}) {
  Firestore.instance.collection("messages").add({
    "text": text,
    "img": url,
    "sendName": googleSingIn.currentUser.displayName,
    "sendPhoto": googleSingIn.currentUser.photoUrl
  });
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
              child: StreamBuilder(
                  stream: Firestore.instance.collection("messages").snapshots(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      default:
                        return ListView.builder(
                          itemBuilder: (contex, index) {
                            return ChatMessage(
                                snapshot.data.documents[index].data);
                          },
                          reverse: true,
                          itemCount: snapshot.data.documents.length,
                        );
                    }
                  })),
          Divider(
            height: 1,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
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
  final _textController = TextEditingController();

  void _reset() {
    _textController.clear();
    setState(() {
      _isCompose = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: <Widget>[
            Container(
              child: IconButton(
                  icon: Icon(Icons.photo_camera),
                  onPressed: () async {
                    await _ensureLoggedIn();
                    File imgFile =
                        await ImagePicker.pickImage(source: ImageSource.camera);
                    if (imgFile == null) return;

                    StorageUploadTask task = FirebaseStorage.instance
                        .ref()
                        .child(googleSingIn.currentUser.id.toString() +
                            DateTime.now().millisecondsSinceEpoch.toString())
                        .putFile(imgFile);
                    StorageTaskSnapshot taskSnapshot = await task.onComplete;
                    String url = await taskSnapshot.ref.getDownloadURL();
                    _sendMessage(url: url);
                  }),
            ),
            Expanded(
              child: TextField(
                controller: _textController,
                decoration:
                    InputDecoration.collapsed(hintText: "Enviar uma mensagem"),
                onChanged: (text) {
                  setState(() {
                    _isCompose = text.length > 0;
                  });
                },
                onSubmitted: (text) {
                  _handleSubmitted(text);
                  _reset();
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _isCompose
                      ? () {
                          _handleSubmitted(_textController.text);
                          _reset();
                        }
                      : null),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final Map<String, dynamic> data;

  ChatMessage(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundImage: NetworkImage(data["senderPhotoUrl"]),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  data["sanderName"],
                  style: Theme.of(context).textTheme.subhead,
                ),
                Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: data['imgUrl'] != null
                        ? Image.network(
                            data['imgUrl'],
                            width: 250,
                          )
                        : data['text'])
              ],
            ),
          )
        ],
      ),
    );
  }
}
