import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:private_chat/widgets/chats/message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());

        return StreamBuilder(
          stream: Firestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (ctx, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final chatDocs = chatSnapshot.data.documents;

              return ListView.builder(
                reverse: true,
                itemCount: chatDocs.length,
                itemBuilder: (ctx, i) => Container(
                  child: MessageBubble(
                    chatDocs[i]['text'],
                    chatDocs[i]['username'],
                    chatDocs[i]['userId'] == futureSnapshot.data.uid,
                    futureSnapshot.data.uid,
                    chatDocs[i]['userImage'],
                    key: ValueKey(chatDocs[i].documentID),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
