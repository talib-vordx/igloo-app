import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:igloo/chat_room/chat_screen.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../Create_and_Post/comment_screen.dart';
import '../chat_room/chatRoomScreen.dart';
import '../chat_room/chat_lists.dart';


class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Fetch Post From Firebase
  Stream<List<Post>> fetchPosts() {
    return FirebaseFirestore.instance
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Post.fromMap(doc.data(), doc.id))
        .toList());
  }

  int shareCount = 0; // State variable for the share count
  // Share Button Functionality
  String msg = 'Check This Amazing Post That I Share https://flutter.dev/';
  void shareText() {
    Share.share(msg).then((_) {
      // Increment the share count after sharing
      setState(() {
        shareCount++;
      });
    });
  }

  // Add a vote to a post
  Future<void> votePost(String postId, String userId, bool vote) async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);

    if (vote) {
      // Add vote (or update if it already exists)
      await postRef.set({
        'votes': {userId: true},
      }, SetOptions(merge: true));
    } else {
      // Remove vote only if it exists
      await postRef.update({
        'votes.$userId': FieldValue.delete(),
      });
    }
  }

// Check if the user has already voted
  Future<bool> hasUserVoted(String postId, String userId) async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    final doc = await postRef.get();
    final data = doc.data() as Map<String, dynamic>?;
    final votes = data?['votes'] as Map<String, dynamic>? ?? {};
    return votes.containsKey(userId);
  }

  // Method to get the vote count for a specific post
  Stream<int> getVoteCount(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .snapshots()
        .map((doc) {
      final data = doc.data() as Map<String, dynamic>?;
      final votes = data?['votes'] as Map<String, dynamic>? ?? {};
      return votes.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120.h,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            MaterialButton(onPressed: (){
              ChatRoomsScreen();
            },
              child: Image.asset('res/images/splashLogo.png',width: 60.w,height: 60.h,),),
            const Spacer(),
            Text('Aston University',
                style: TextStyle(
                    fontFamily: 'Karla',
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 26.sp)),
            const Spacer(),
        MaterialButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>  PostListScreen(),));
          },
          child: SizedBox(
            height: 40.h,
            width: 40.w,
            child: SvgPicture.asset('res/images/tabler_send.svg'),
          ),
        )

        ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
                controller: _tabController,
                labelColor: Colors.black, // Active tab color
                unselectedLabelColor: Colors.grey,
                indicator: UnderlineTabIndicator(
                    insets: EdgeInsets.symmetric(horizontal: 130.w),
                    borderSide: BorderSide(
                      width: 3.w,
                      color: const Color(0xFF27D4C1),
                    )),
                tabs: [
                  Tab(
                    child: Row(
                      children: <Widget>[
                       // SizedBox(width: 5.w),
                        SizedBox(
                          height: 30.h,
                          width: 30.w,
                          child: SvgPicture.asset(
                            color: _tabController.index == 0
                                ? Colors.black
                                : Colors.grey,
                            'res/images/appfirsticon.svg',
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Text('Top',
                            style: TextStyle(
                                fontFamily: '',
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                            height: 25.h,
                            width: 25.w,
                            child: SvgPicture.asset(
                                'res/images/pepicons-pencil_stars.svg',
                                color: _tabController.index == 1
                                    ? Colors.black
                                    : Colors.grey)),
                        SizedBox(width: 5.w),
                        Text('New',
                            style: TextStyle(
                                fontSize: 22.sp,
                                fontFamily: '',
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                            height: 25.h,
                            width: 25.w,
                            child: SvgPicture.asset(
                                'res/images/followicon.svg',
                                color: _tabController.index == 2
                                    ? Colors.black
                                    : Colors.grey)),
                        SizedBox(width: 5.w),
                        Text('Following',
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontFamily: '',
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ]),
            Expanded(
              child: TabBarView(
                  controller: _tabController,
                  children: [
                StreamBuilder<QuerySnapshot>(
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
                          .map((doc) => Post.fromMap(
                          doc.data() as Map<String, dynamic>, doc.id))
                          .toList();
                      return ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return Padding(
                            padding: EdgeInsets.all(5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Row(
                                  children: [
                                    post.userProfileUrl != null
                                        ? CircleAvatar(
                                      backgroundImage:
                                      NetworkImage(post.userProfileUrl!),
                                    )
                                        :  CircleAvatar(child: Icon(Icons.person)),
                                    SizedBox(width: 20.w),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(post.userName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22.sp),),
                                        Text(
                                          post.getFormattedTime(), // Display "Today 12:20 PM" or "22 Nov 2024 12:20 PM"
                                          style: TextStyle(fontSize: 12, color: Colors.grey),
                                        ),

                                      ],
                                    ),
                                    Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Align(
                                              alignment: Alignment.topRight, // Center or any position you prefer
                                              child: Material(
                                                borderRadius: BorderRadius.circular(10.0), // Optional rounded corners
                                                color: Colors.white,
                                                child: Container(
                                                  width: 185.w, // Set the exact width here
                                                  padding: EdgeInsets.all(16.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {},
                                                            icon: Icon(Icons.report, size: 30.sp),
                                                          ),
                                                          Text(
                                                            "Report",
                                                            style: TextStyle(fontSize: 25.sp, color: Colors.black),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {},
                                                            icon: Icon(Icons.block, size: 30.sp),
                                                          ),
                                                          Text(
                                                            "Block",
                                                            style: TextStyle(fontSize: 25.sp, color: Colors.black),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );

                                      },
                                      icon: Icon(Icons.flag_outlined, size: 28.sp),
                                    ),
                                  ],
                                ),
                                subtitle:Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 320.w, child: Text(post.content)),
                                      SizedBox(height: 5.h),
                                      Row(
                                        children: <Widget>[
                                          IconButton(
                                            onPressed: () {
                                              if (post.id != null) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => CommentScreen(postId: post.id!),
                                                  ),
                                                );
                                              }
                                            },
                                            icon: SizedBox(
                                              height: 30.h,
                                              width: 30.w,
                                              child: SvgPicture.asset('res/images/commentbutton.svg'),
                                            ),
                                          ),
                                          StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('posts')
                                                .doc(post.id)
                                                .collection('comments')
                                                .snapshots(),
                                            builder: (context, commentSnapshot) {
                                              if (commentSnapshot.connectionState == ConnectionState.waiting) {
                                                return Text("0");
                                              } else if (commentSnapshot.hasData) {
                                                return Text(
                                                  commentSnapshot.data!.docs.length.toString(),
                                                  style: TextStyle(fontWeight: FontWeight.w700),
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
                                            icon: SizedBox(
                                                height: 30.h,
                                                width: 30.w,
                                                child: SvgPicture.asset('res/images/Vector.svg')),
                                          ),
                                          Text("$shareCount", style: TextStyle(fontWeight: FontWeight.w700)),
                                          SizedBox(width: 20.w),
                                          IconButton(
                                            onPressed: () async {
                                              final currentUser = FirebaseAuth.instance.currentUser;

                                              if (currentUser == null) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Please log in to chat.')),
                                                );
                                                return;
                                              }

                                              // Generate a unique chat room ID
                                              String generateChatRoomId(String userId1, String userId2) {
                                                return userId1.hashCode <= userId2.hashCode
                                                    ? '$userId1-$userId2'
                                                    : '$userId2-$userId1';
                                              }

                                              // Create the chat room ID
                                              final chatRoomId = generateChatRoomId(currentUser.uid, post.userId);

                                              // Ensure chat room exists in Firestore
                                              await FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomId).set({
                                                'chatRoomId': chatRoomId,
                                                'users': [currentUser.uid, post.userId],
                                                'postContent': post.content, // Optionally include post content
                                                'lastMessage': '',
                                                'updatedAt': Timestamp.now(),
                                              });
                                              // Navigate to ChatScreen
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ChatScreen(chatRoomId: chatRoomId),
                                                ),
                                              );
                                            },
                                            icon: SizedBox(
                                                    height: 30.h,
                                                    width: 30.w,
                                                    child: SvgPicture.asset('res/images/forwaedbutton.svg')
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          final userId = "loggedInUserId"; // Replace with the actual logged-in user's ID
                                          final hasVoted = await hasUserVoted(post.id!, userId);

                                          if (!hasVoted) {
                                            // User has not voted yet, so they can only add a vote
                                            await votePost(post.id!, userId, true); // Add vote
                                          } else {
                                            // User has voted, so they can only remove their vote
                                            await votePost(post.id!, userId, false); // Remove vote
                                          }
                                        },
                                        icon: Icon(
                                          Icons.keyboard_arrow_up,
                                          size: 45.sp,
                                          color: Colors.black, // Color can be changed based on voting status
                                        ),
                                      ),
                                      StreamBuilder<int>(
                                        stream: getVoteCount(post.id!),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Text("0");
                                          } else if (snapshot.hasData) {
                                            return Text(
                                              snapshot.data!.toString(),
                                              style: TextStyle(
                                                fontSize: 31.sp,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF27D4C1),
                                              ),
                                            );
                                          } else {
                                            return Text("0");
                                          }
                                        },
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          final userId = "loggedInUserId"; // Replace with actual user ID
                                          final hasVoted = await hasUserVoted(post.id!, userId);

                                          if (!hasVoted) {
                                            // User has not voted yet, so they can only add a vote
                                            await votePost(post.id!, userId, true); // Add vote
                                          } else {
                                            // User has voted, so they can only remove their vote
                                            await votePost(post.id!, userId, false); // Remove vote
                                          }
                                        },
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_outlined,
                                          size: 45.sp,
                                          color: Colors.black, // Color can be changed based on voting status
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                           ),
                         );
                        },
                      );
                    }
                  },
                ),
                StreamBuilder<QuerySnapshot>(
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
                          .map((doc) => Post.fromMap(
                          doc.data() as Map<String, dynamic>, doc.id))
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
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Row(
                                  children: [
                                    post.userProfileUrl != null
                                        ? CircleAvatar(
                                      backgroundImage:
                                      NetworkImage(post.userProfileUrl!),
                                    )
                                        :  CircleAvatar(child: Icon(Icons.person)),
                                    SizedBox(width: 20.w),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(post.userName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22.sp),),
                                        Text(
                                          post.createdAt.toString(),
                                          style: TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Align(
                                              alignment: Alignment.topRight, // Center or any position you prefer
                                              child: Material(
                                                borderRadius: BorderRadius.circular(10.0), // Optional rounded corners
                                                color: Colors.white,
                                                child: Container(
                                                  width: 185.w, // Set the exact width here
                                                  padding: EdgeInsets.all(16.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {},
                                                            icon: Icon(Icons.report, size: 30.sp),
                                                          ),
                                                          Text(
                                                            "Report",
                                                            style: TextStyle(fontSize: 25.sp, color: Colors.black),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {},
                                                            icon: Icon(Icons.block, size: 30.sp),
                                                          ),
                                                          Text(
                                                            "Block",
                                                            style: TextStyle(fontSize: 25.sp, color: Colors.black),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );

                                      },
                                      icon: Icon(Icons.flag_outlined, size: 28.sp),
                                    ),
                                  ],
                                ),
                                subtitle:Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 320.w, child: Text(post.content)),
                                      SizedBox(height: 5.h),
                                      Row(
                                        children: <Widget>[
                                          IconButton(
                                            onPressed: () {
                                              if (post.id != null) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => CommentScreen(postId: post.id!),
                                                  ),
                                                );
                                              }
                                            },
                                            icon: SizedBox(
                                              height: 30.h,
                                              width: 30.w,
                                              child: SvgPicture.asset('res/images/commentbutton.svg'),
                                            ),
                                          ),
                                          StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('posts')
                                                .doc(post.id)
                                                .collection('comments')
                                                .snapshots(),
                                            builder: (context, commentSnapshot) {
                                              if (commentSnapshot.connectionState == ConnectionState.waiting) {
                                                return Text("0");
                                              } else if (commentSnapshot.hasData) {
                                                return Text(
                                                  commentSnapshot.data!.docs.length.toString(),
                                                  style: TextStyle(fontWeight: FontWeight.w700),
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
                                            icon: SizedBox(
                                                height: 30.h,
                                                width: 30.w,
                                                child: SvgPicture.asset('res/images/Vector.svg')),
                                          ),
                                          Text("$shareCount", style: TextStyle(fontWeight: FontWeight.w700)),
                                          SizedBox(width: 20.w),
                                          IconButton(
                                            onPressed: () async {
                                              final currentUser = FirebaseAuth.instance.currentUser;

                                              if (currentUser == null) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Please log in to chat.')),
                                                );
                                                return;
                                              }

                                              // Generate a unique chat room ID
                                              String generateChatRoomId(String userId1, String userId2) {
                                                return userId1.hashCode <= userId2.hashCode
                                                    ? '$userId1-$userId2'
                                                    : '$userId2-$userId1';
                                              }

                                              // Create the chat room ID
                                              final chatRoomId = generateChatRoomId(currentUser.uid, post.userId);

                                              // Ensure chat room exists in Firestore
                                              await FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomId).set({
                                                'chatRoomId': chatRoomId,
                                                'users': [currentUser.uid, post.userId],
                                                'postContent': post.content, // Optionally include post content
                                                'lastMessage': '',
                                                'updatedAt': Timestamp.now(),
                                              });
                                              // Navigate to ChatScreen
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ChatScreen(chatRoomId: chatRoomId),
                                                ),
                                              );
                                            },
                                            icon: SizedBox(
                                                    height: 30.h,
                                                    width: 30.w,
                                                    child: SvgPicture.asset('res/images/forwaedbutton.svg')
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          final userId = "loggedInUserId"; // Replace with the actual logged-in user's ID
                                          final hasVoted = await hasUserVoted(post.id!, userId);

                                          if (!hasVoted) {
                                            // User has not voted yet, so they can only add a vote
                                            await votePost(post.id!, userId, true); // Add vote
                                          } else {
                                            // User has voted, so they can only remove their vote
                                            await votePost(post.id!, userId, false); // Remove vote
                                          }
                                        },
                                        icon: Icon(
                                          Icons.keyboard_arrow_up,
                                          size: 45.sp,
                                          color: Colors.black, // Color can be changed based on voting status
                                        ),
                                      ),
                                      StreamBuilder<int>(
                                        stream: getVoteCount(post.id!),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Text("0");
                                          } else if (snapshot.hasData) {
                                            return Text(
                                              snapshot.data!.toString(),
                                              style: TextStyle(
                                                fontSize: 31.sp,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF27D4C1),
                                              ),
                                            );
                                          } else {
                                            return Text("0");
                                          }
                                        },
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          final userId = "loggedInUserId"; // Replace with actual user ID
                                          final hasVoted = await hasUserVoted(post.id!, userId);

                                          if (!hasVoted) {
                                            // User has not voted yet, so they can only add a vote
                                            await votePost(post.id!, userId, true); // Add vote
                                          } else {
                                            // User has voted, so they can only remove their vote
                                            await votePost(post.id!, userId, false); // Remove vote
                                          }
                                        },
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_outlined,
                                          size: 45.sp,
                                          color: Colors.black, // Color can be changed based on voting status
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10.w)
                                ],
                              ),

                            ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
                StreamBuilder<QuerySnapshot>(
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
                          .map((doc) => Post.fromMap(
                          doc.data() as Map<String, dynamic>, doc.id))
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
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: Row(
                                  children: [
                                    post.userProfileUrl != null
                                        ? CircleAvatar(
                                      backgroundImage:
                                      NetworkImage(post.userProfileUrl!),
                                    )
                                        :  CircleAvatar(child: Icon(Icons.person)),
                                    SizedBox(width: 20.w),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(post.userName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22.sp),),
                                        Text(
                                          post.createdAt.toString(),
                                          style: TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Align(
                                              alignment: Alignment.topRight, // Center or any position you prefer
                                              child: Material(
                                                borderRadius: BorderRadius.circular(10.0), // Optional rounded corners
                                                color: Colors.white,
                                                child: Container(
                                                  width: 185.w, // Set the exact width here
                                                  padding: EdgeInsets.all(16.0),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {},
                                                            icon: Icon(Icons.report, size: 30.sp),
                                                          ),
                                                          Text(
                                                            "Report",
                                                            style: TextStyle(fontSize: 25.sp, color: Colors.black),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          IconButton(
                                                            onPressed: () {},
                                                            icon: Icon(Icons.block, size: 30.sp),
                                                          ),
                                                          Text(
                                                            "Block",
                                                            style: TextStyle(fontSize: 25.sp, color: Colors.black),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );

                                      },
                                      icon: Icon(Icons.flag_outlined, size: 28.sp),
                                    ),
                                  ],
                                ),
                                subtitle:Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 320.w, child: Text(post.content)),
                                      SizedBox(height: 5.h),
                                      Row(
                                        children: <Widget>[
                                          IconButton(
                                            onPressed: () {
                                              if (post.id != null) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => CommentScreen(postId: post.id!),
                                                  ),
                                                );
                                              }
                                            },
                                            icon: SizedBox(
                                              height: 30.h,
                                              width: 30.w,
                                              child: SvgPicture.asset('res/images/commentbutton.svg'),
                                            ),
                                          ),
                                          StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('posts')
                                                .doc(post.id)
                                                .collection('comments')
                                                .snapshots(),
                                            builder: (context, commentSnapshot) {
                                              if (commentSnapshot.connectionState == ConnectionState.waiting) {
                                                return Text("0");
                                              } else if (commentSnapshot.hasData) {
                                                return Text(
                                                  commentSnapshot.data!.docs.length.toString(),
                                                  style: TextStyle(fontWeight: FontWeight.w700),
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
                                            icon: SizedBox(
                                                height: 30.h,
                                                width: 30.w,
                                                child: SvgPicture.asset('res/images/Vector.svg')),
                                          ),
                                          Text("$shareCount", style: TextStyle(fontWeight: FontWeight.w700)),
                                          SizedBox(width: 20.w),
                                          IconButton(
                                            onPressed: () async {
                                              final currentUser = FirebaseAuth.instance.currentUser;

                                              if (currentUser == null) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('Please log in to chat.')),
                                                );
                                                return;
                                              }

                                              // Generate a unique chat room ID
                                              String generateChatRoomId(String userId1, String userId2) {
                                                return userId1.hashCode <= userId2.hashCode
                                                    ? '$userId1-$userId2'
                                                    : '$userId2-$userId1';
                                              }

                                              // Create the chat room ID
                                              final chatRoomId = generateChatRoomId(currentUser.uid, post.userId);

                                              // Ensure chat room exists in Firestore
                                              await FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomId).set({
                                                'chatRoomId': chatRoomId,
                                                'users': [currentUser.uid, post.userId],
                                                'postContent': post.content, // Optionally include post content
                                                'lastMessage': '',
                                                'updatedAt': Timestamp.now(),
                                              });
                                              // Navigate to ChatScreen
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ChatScreen(chatRoomId: chatRoomId),
                                                ),
                                              );
                                            },
                                            icon: SizedBox(
                                                    height: 30.h,
                                                    width: 30.w,
                                                    child: SvgPicture.asset('res/images/forwaedbutton.svg')
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          final userId = "loggedInUserId"; // Replace with the actual logged-in user's ID
                                          final hasVoted = await hasUserVoted(post.id!, userId);

                                          if (!hasVoted) {
                                            // User has not voted yet, so they can only add a vote
                                            await votePost(post.id!, userId, true); // Add vote
                                          } else {
                                            // User has voted, so they can only remove their vote
                                            await votePost(post.id!, userId, false); // Remove vote
                                          }
                                        },
                                        icon: Icon(
                                          Icons.keyboard_arrow_up,
                                          size: 45.sp,
                                          color: Colors.black, // Color can be changed based on voting status
                                        ),
                                      ),
                                      StreamBuilder<int>(
                                        stream: getVoteCount(post.id!),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return Text("0");
                                          } else if (snapshot.hasData) {
                                            return Text(
                                              snapshot.data!.toString(),
                                              style: TextStyle(
                                                fontSize: 31.sp,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF27D4C1),
                                              ),
                                            );
                                          } else {
                                            return Text("0");
                                          }
                                        },
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          final userId = "loggedInUserId"; // Replace with actual user ID
                                          final hasVoted = await hasUserVoted(post.id!, userId);

                                          if (!hasVoted) {
                                            // User has not voted yet, so they can only add a vote
                                            await votePost(post.id!, userId, true); // Add vote
                                          } else {
                                            // User has voted, so they can only remove their vote
                                            await votePost(post.id!, userId, false); // Remove vote
                                          }
                                        },
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_outlined,
                                          size: 45.sp,
                                          color: Colors.black, // Color can be changed based on voting status
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10.w)
                                ],
                              ),

                            ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ]),
            )
          ],
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

  /// Format timestamp into a user-friendly string.
  String getFormattedTime() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final postDate = DateTime(createdAt.year, createdAt.month, createdAt.day);

    if (postDate == today) {
      return "Today ${DateFormat.jm().format(createdAt)}";
    } else if (postDate == today.subtract(const Duration(days: 1))) {
      return "Yesterday ${DateFormat.jm().format(createdAt)}";
    } else {
      return DateFormat("MMM d, yyyy 'at' h:mm a").format(createdAt);
    }
  }

  /// Generate unique chatRoomId
  String _generateChatRoomId(String userId1, String userId2) {
    return userId1.hashCode <= userId2.hashCode
        ? '$userId1-$userId2'
        : '$userId2-$userId1';
  }

  /// Button method to navigate to the chat screen
  Widget chatButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        final currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You need to be logged in to start a chat.')),
          );
          return;
        }

        final chatRoomId = _generateChatRoomId(currentUser.uid, userId);

        // Ensure the chat room exists in Firestore
        await FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomId).set({
          'chatRoomId': chatRoomId,
          'users': [currentUser.uid, userId],
          'postContent': content, // Optionally store the post content
          'lastMessage': '',
          'updatedAt': Timestamp.now(),
        });

        // Navigate to the ChatScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(chatRoomId: chatRoomId),
          ),
        );
      },
      icon: Icon(Icons.chat),
      label: Text('Chat with $userName'),
    );
  }
}







