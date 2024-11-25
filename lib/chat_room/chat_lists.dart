import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../Create_and_Post/post_create_screen.dart';
import 'chat_screen.dart';

class PostListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No posts available.'));
          } else {
            final posts = snapshot.data!.docs
                .map((doc) => Post.fromMap(doc.data() as Map<String, dynamic>, doc.id))
                .toList();
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: MaterialButton(
                      onPressed: () async {
                        final currentUser = FirebaseAuth.instance.currentUser;

                        if (currentUser == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('You need to be logged in to start a chat.')),
                          );
                          return;
                        }

                        // Generate unique chat room ID
                        String generateChatRoomId(String userId1, String userId2) {
                          return userId1.hashCode <= userId2.hashCode
                              ? '$userId1-$userId2'
                              : '$userId2-$userId1';
                        }

                        final chatRoomId = generateChatRoomId(
                          currentUser.uid,
                          post.userId,
                        );

                        // Ensure the chat room exists
                        await FirebaseFirestore.instance
                            .collection('chatRooms')
                            .doc(chatRoomId)
                            .set({
                          'chatRoomId': chatRoomId,
                          'users': [currentUser.uid, post.userId],
                          'postContent': post.content, // Optional
                          'lastMessage': '',
                          'updatedAt': Timestamp.now(),
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(chatRoomId: chatRoomId),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Row(
                          children: [
                            post.userProfileUrl != null
                                ? CircleAvatar(
                              backgroundImage: NetworkImage(post.userProfileUrl!),
                            )
                                : CircleAvatar(child: Icon(Icons.person)),
                            SizedBox(width: 20.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.userName,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp),
                                ),
                                Text(
                                  post.getFormattedTime(), // Display "Today 12:20 PM" or "22 Nov 2024 12:20 PM"
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),

                              ],
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(post.content),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}


class Post {
  final String id;
  final String userId;
  final String userName;
  final String content;
  final String? userProfileUrl;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.content,
    this.userProfileUrl,
    required this.createdAt,
  });

  factory Post.fromMap(Map<String, dynamic> map, String id) {
    return Post(
      id: id,
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      content: map['content'] as String,
      userProfileUrl: map['userProfileUrl'] as String?,
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.parse(map['createdAt']),
    );
  }

  // Utility method to format the date and time
  String getFormattedTime() {
    final now = DateTime.now();
    final isToday = now.day == createdAt.day &&
        now.month == createdAt.month &&
        now.year == createdAt.year;

    final timeFormatter = DateFormat('hh:mm a'); // Example: 12:20 PM
    final dateFormatter = DateFormat('dd MMM yyyy'); // Example: 22 Nov 2024

    if (isToday) {
      return 'Today ${timeFormatter.format(createdAt)}';
    } else {
      return '${dateFormatter.format(createdAt)} ${timeFormatter.format(createdAt)}';
    }
  }
}
