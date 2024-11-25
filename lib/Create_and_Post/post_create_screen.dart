import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../Notification/notification.dart';

class PostCreateScreen extends StatelessWidget {
  PostCreateScreen({super.key});

  final TextEditingController _postContentController = TextEditingController();
  final NotificationServices notificationServices = NotificationServices();

  Future<void> createPost(String content, BuildContext context) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final post = Post(
        content: content,
        userId: currentUser.uid,
        userName: currentUser.displayName ?? 'Anonymous',
        userProfileUrl: currentUser.photoURL,
        createdAt: DateTime.now(),
      );

      try {
        final postsCollection = FirebaseFirestore.instance.collection('posts');
        await postsCollection.add(post.toMap());
        print('Post added successfully');

        // Trigger notification after post creation
        await notificationServices.showNotification(RemoteMessage(
          notification: RemoteNotification(
            title: 'Post Created!',
            body: 'Your post has been successfully added!',
          ),
        ));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post created successfully!')),
        );
      } catch (e) {
        print('Error adding post: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create post.')),
        );
      }
    } else {
      print('No user is logged in');
    }
  }

  void _submitPost(BuildContext context) {
    final content = _postContentController.text.trim();
    if (content.isNotEmpty) {
      createPost(content, context); // Save post to Firestore
      _postContentController.clear(); // Clear the input field
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: 130.h,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset('res/images/CencelButton.svg'),
            ),
            const Spacer(),
            Text(
              'Create Post',
              style: TextStyle(
                  fontSize: 24.sp, fontWeight: FontWeight.w700, color: Colors.black),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('res/images/tabler_send.svg'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.r),
        child: SingleChildScrollView(
          child: Container(
            height: 600.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  blurRadius: 3,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 20.w),
                      PhysicalModel(
                        color: Colors.black,
                        clipBehavior: Clip.antiAlias,
                        shape: BoxShape.circle,
                        child: Image.asset(
                          'res/images/appicon.png',
                          width: 60.w,
                          height: 60.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Padding(
                        padding: EdgeInsets.only(top: 80.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 250.w,
                              child: TextFormField(
                                controller: _postContentController,
                                minLines: 1,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  hintText:
                                  'Uni help? Secret Crush? Confession? Share what’s on your mind...',
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              children: <Widget>[
                                SvgPicture.asset('res/images/Post1nd.svg'),
                                SizedBox(width: 25.w),
                                SvgPicture.asset('res/images/Post2nd.svg'),
                                SizedBox(width: 25.w),
                                SvgPicture.asset('res/images/Post3nd.svg'),
                                SizedBox(width: 25.w),
                                SvgPicture.asset('res/images/Post4nd.svg'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 60.h),
                  Padding(
                    padding: EdgeInsets.only(right: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        MaterialButton(
                          color: const Color(0xFF27D4C1),
                          minWidth: 140.w,
                          height: 45.h,
                          onPressed: () {
                            _submitPost(context);
                          },
                          child: const Text(
                            'POST',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Post {
  String? id;
  final String content;
  final String userId;
  final String userName;
  final String? userProfileUrl;
  final DateTime createdAt;

  Post({
    this.id,
    required this.content,
    required this.userId,
    required this.userName,
    this.userProfileUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'userId': userId,
      'userName': userName,
      'userProfileUrl': userProfileUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static Post fromMap(Map<String, dynamic> map, String id) {
    return Post(
      id: id,
      content: map['content'],
      userId: map['userId'],
      userName: map['userName'],
      userProfileUrl: map['userProfileUrl'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
