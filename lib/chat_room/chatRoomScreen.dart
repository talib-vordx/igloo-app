import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'chat_screen.dart';

class ChatRoomsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Chat Rooms')),
        body: Center(child: Text('You need to be logged in to view chat rooms.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Chat Rooms')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chatRooms')
            .where('users', arrayContains: currentUser.uid)
            .orderBy('updatedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No chat rooms available.'));
          }

          final chatRooms = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final chatRoom = chatRooms[index];
              final otherUserId = (chatRoom['users'] as List<dynamic>)
                  .firstWhere((id) => id != currentUser.uid);
              // Get the other user's data
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(otherUserId).get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const ListTile(title: Text('Loading...'));
                  }
                  final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                  final userName = userData['name'] ?? 'Unknown User';
                  final userProfileUrl = userData['profileUrl'];
                  final lastMessage = chatRoom['lastMessage'] ?? 'No messages yet';
                  final updatedAt = (chatRoom['updatedAt'] as Timestamp).toDate();
                  final formattedTime = DateFormat('dd MMM, hh:mm a').format(updatedAt);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: userProfileUrl != null
                          ? NetworkImage(userProfileUrl)
                          : null,
                      child: userProfileUrl == null ? Icon(Icons.person) : null,
                    ),
                    title: Text(userName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lastMessage),
                        Text(
                          'Last updated: $formattedTime',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChatScreen(chatRoomId: chatRoom['chatRoomId']),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
