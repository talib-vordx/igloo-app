import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';

import '../BottomNavBarPages/first_screen_home.dart';
import 'comment_screen.dart';

class UserPostsScreen extends StatefulWidget {

  @override
  State<UserPostsScreen> createState() => _UserPostsScreenState();
}

class _UserPostsScreenState extends State<UserPostsScreen> {
  Stream<List<Post>> getUserPosts() {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Stream.value([]); // If the user is not logged in, return an empty list.
    }

    final userId = currentUser.uid;

    // Fetch posts where the 'userId' matches the current user's ID
    return FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: userId) // Match posts by current user
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Post.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  int shareCount = 0;
 // State variable for the share count
  String msg = 'Check This Amazing Post That I Share https://flutter.dev/';

  void shareText() {
    Share.share(msg).then((_) {
      // Increment the share count after sharing
      setState(() {
        shareCount++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F3F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back_ios_new)),
        title: const Text('My Posts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<Post>>(
          stream: getUserPosts(), // Stream that fetches user's posts
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final userPosts = snapshot.data!;
            if (userPosts.isEmpty) {
              return const Center(child: Text('You have no posts yet.'));
            }
            return ListView.builder(
              itemCount: userPosts.length,
              itemBuilder: (context, index) {
                final post = userPosts[index];

                return Card(
                 // elevation: 5,
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Row(
                      children: [
                        post.userProfileUrl != null
                            ? CircleAvatar(
                          backgroundImage: NetworkImage(
                              post.userProfileUrl!),
                        )
                            : const CircleAvatar(
                            child: Icon(Icons.person)),
                        SizedBox(width: 20.w),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.userName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.sp),
                            ),
                            Text(
                              post.getFormattedTime(), // Display "Today 12:20 PM" or "22 Nov 2024 12:20 PM"
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(height: 10.h,),
                                SizedBox(
                                  width: 300.w,
                                  child:Text(post.content,),
                                ),
                                Row(
                                  children: <Widget>[
                                    IconButton(
                                      onPressed: () {
                                        if (post.id != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CommentScreen(
                                                      postId: post.id!),
                                            ),
                                          );
                                        }
                                      },
                                      icon: SvgPicture.asset(
                                          'res/images/commentbutton.svg'),
                                    ),
                                    StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('posts')
                                          .doc(post.id)
                                          .collection('comments')
                                          .snapshots(),
                                      builder:
                                          (context, commentSnapshot) {
                                        if (commentSnapshot
                                            .connectionState ==
                                            ConnectionState.waiting) {
                                          return Text("0");
                                        } else if (commentSnapshot
                                            .hasData) {
                                          return Text(
                                            commentSnapshot
                                                .data!.docs.length
                                                .toString(),
                                            style: TextStyle(
                                                fontWeight:
                                                FontWeight.w700),
                                          );
                                        } else {
                                          return Text("0");
                                        }
                                      },
                                    ),
                                    SizedBox(width: 20.w),
                                    IconButton(
                                      onPressed: () {
                                        shareText();
                                      },
                                      icon: SvgPicture.asset(
                                          'res/images/Vector.svg'),
                                    ),
                                    Text("$shareCount",
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.w700)),

                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

