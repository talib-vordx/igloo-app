import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommentScreen extends StatefulWidget {
  final String postId;

  const CommentScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot? postSnapshot; // Store the original post data
  int _commentCount = 0; // Store the comment count

  @override
  void initState() {
    super.initState();
    _fetchPostData(); // Fetch the post data when the screen is initialized
  }

  Future<void> _fetchPostData() async {
    try {
      postSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .get();
      _getCommentCount();
      setState(() {});
    } catch (e) {
      print('Error fetching post data: $e');
    }
  }

  Future<void> _getCommentCount() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .get();
      setState(() {
        _commentCount = snapshot.docs.length;
      });
    } catch (e) {
      print('Error fetching comment count: $e');
    }
  }

  Future<void> _postComment() async {
    if (_commentController.text.trim().isEmpty) {
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .add({
        'userId': user?.uid,
        'userName': user?.displayName ?? 'Anonymous',
        'userProfileUrl': user?.photoURL,
        'content': _commentController.text.trim(),
        'createdAt': Timestamp.now(),
      });

      _commentController.clear();
      _getCommentCount(); // Refresh the comment count
    } catch (e) {
      print('Error posting comment: $e');
    }
  }

  String formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate().toString();
    } else if (timestamp is String) {
      return timestamp;
    } else {
      return 'Unknown time';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensures UI adjusts with keyboard
      backgroundColor: Colors.grey[200],
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
              icon: const Icon(Icons.arrow_back_ios),
            ),
            const Spacer(),
            Text(
              "Comments",
              style: TextStyle(
                  fontSize: 24.sp, color: Colors.black, fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('res/images/ThireDotButton.svg'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10.h, left: 15.w, right: 15.w),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r), topRight: Radius.circular(12.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.8),
              ),
            ],
          ),
          child: Column(
            children: [
              if (postSnapshot != null)
                ListTile(
                  title: Row(
                    children: [
                      postSnapshot!['userProfileUrl'] != null
                          ? CircleAvatar(
                          backgroundImage:
                          NetworkImage(postSnapshot!['userProfileUrl']))
                          : const CircleAvatar(child: Icon(Icons.person)),
                      SizedBox(width: 25.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(postSnapshot!['userName'] ?? 'Anonymous'),
                          Text(
                            formatTimestamp(postSnapshot!['createdAt']),
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Text(postSnapshot!['content']),
                  ),
                ),
              const Divider(),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Comments ($_commentCount)',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(widget.postId)
                      .collection('comments')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No comments available.'));
                    } else {
                      return ListView(
                        children: snapshot.data!.docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return ListTile(
                            leading: data['userProfileUrl'] != null
                                ? CircleAvatar(
                                backgroundImage:
                                NetworkImage(data['userProfileUrl']))
                                : const CircleAvatar(child: Icon(Icons.person)),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['userName'] ?? 'Anonymous',
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10.h),
                                Text(data['content']),
                                SizedBox(height: 10.h),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AnimatedPadding(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: BottomAppBar(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, ),
            child: TextFormField(
              controller: _commentController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                hintText: "Write a comment...",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    _postComment();
                  },
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(50.r),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
