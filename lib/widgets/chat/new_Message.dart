import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final controller = TextEditingController();

  String enterMessage = '';

  sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': enterMessage,
      'createAt': Timestamp.now(),
      'username': userData['username'],
      'userImage': userData['image_url'],
      'userId': user.uid,
    });
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Send a message....'),
            onChanged: (val) {
              setState(() {
                enterMessage = val;
              });
            },
          )),
          IconButton(
            onPressed: enterMessage.trim().isEmpty ? null : sendMessage,
            icon: const Icon(Icons.send),
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
