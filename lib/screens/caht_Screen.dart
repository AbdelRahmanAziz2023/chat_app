import 'package:chatapp/widgets/chat/Message.dart';
import 'package:chatapp/widgets/chat/new_Message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Chat',
            style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 40),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            DropdownButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white70,
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ],
                onChanged: (_) {
                  FirebaseAuth.instance.signOut();
                })
          ],
        ),
        body: Column(
          children: [
            const Expanded(child: Message()),
            NewMessage(),
          ],
        ));
  }
}
