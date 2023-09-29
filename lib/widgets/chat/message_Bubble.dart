import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final Key key;
  final String message;
  final String userName;
  final String userImage;
  final bool isMe;

  const MessageBubble(
      {required this.key,
      required this.message,
      required this.userName,
      required this.userImage,
      required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: isMe ? Colors.tealAccent[700] : Colors.grey,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(15),
                    topRight: const Radius.circular(15),
                    bottomLeft: isMe
                        ? const Radius.circular(0)
                        : const Radius.circular(15),
                    bottomRight: !isMe
                        ? const Radius.circular(0)
                        : const Radius.circular(15),
                  )),
              width: 150,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isMe ? Colors.black : Colors.black),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe ? Colors.black : Colors.black,
                    ),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            )
          ],
        ),
        Positioned(
            top: 0,
            left: isMe ? 120 : null,
            right: !isMe ? 120 : null,
            child: CircleAvatar(
              backgroundImage: NetworkImage(userImage),
            ))
      ],
    );
  }
}
