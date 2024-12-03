import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:igloo/chat_room/chat_screen.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../Create_and_Post/comment_screen.dart';
import '../Create_and_Post/other_user_details.dart';
import '../chat_room/chatRoomScreen.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> with TickerProviderStateMixin {
  Stream<QuerySnapshot> postStream = FirebaseFirestore.instance
      .collection('posts')
      .orderBy('createdAt', descending: true)
      .snapshots();
  DateTime? selectedDate;

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
  Future<void> votePost(String postId, String userId, bool isUpvote) async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);

    // Get the current post data
    final doc = await postRef.get();
    final data = doc.data();

    // Get current votes data
    final votes = data?['votes'] as Map<String, dynamic>? ?? {};

    // Check if the user has already voted
    final hasVoted = votes.containsKey(userId);
    final currentVote = votes[userId];

    if (hasVoted) {
      // If user has voted and clicked on downvote (retract their vote)
      if (currentVote == true && !isUpvote) {
        // Remove the user's vote if they clicked downvote (retract)
        await postRef.update({
          'votes.$userId': FieldValue.delete(),
        });
      }
    } else {
      // If user has not voted, cast the vote (upvote)
      if (isUpvote) {
        await postRef.update({
          'votes.$userId': true, // Add upvote
        });
      }
    }
  }

  // Check if the user has already voted
  Future<bool> hasUserVoted(String postId, String userId) async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    final doc = await postRef.get();
    final data = doc.data();

    final votes = data?['votes'] as Map<String, dynamic>? ?? {};
    return votes.containsKey(userId);  // Returns true if the user has voted
  }

  // Method to get the vote count for a specific post
  Stream<int> getVoteCount(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .snapshots()
        .map((doc) {
      final data = doc.data() ?? {};
      final votes = data['votes'] as Map<String, dynamic>? ?? {};

      // Count the number of upvotes
      int upvotes = 0;
      votes.forEach((key, value) {
        if (value == true) {
          upvotes++;
        }
      });

      return upvotes;  // Return the upvote count
    });
  }


  void filterByDay() {
    // Start of the current day (midnight)
    DateTime startOfDay = DateTime.now().subtract(
      Duration(
        hours: DateTime.now().hour,
        minutes: DateTime.now().minute,
        seconds: DateTime.now().second,
      ),
    );

    setState(() {
      postStream = FirebaseFirestore.instance
          .collection('posts')
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .orderBy('createdAt', descending: true)
          .snapshots();
    });
  }

  void filterByWeek() {
    DateTime startOfWeek = DateTime.now().subtract(
      Duration(days: DateTime.now().weekday - 1, hours: DateTime.now().hour, minutes: DateTime.now().minute, seconds: DateTime.now().second),
    );

    setState(() {
      postStream = FirebaseFirestore.instance
          .collection('posts')
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeek))
          .orderBy('createdAt', descending: true)
          .snapshots();
    });
  }

  void pickAnyDate(DateTime selectedDate) {
    DateTime startOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    setState(() {
      postStream = FirebaseFirestore.instance
          .collection('posts')
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(startOfDay.add(Duration(days: 1))))
          .orderBy('createdAt', descending: true)
          .snapshots();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F3F7),
      appBar: AppBar(
        toolbarHeight: 120.h,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'res/images/splashLogo.png',
              width: 60.w,
              height: 60.h,
            ),
            const Spacer(),
            Text('Aston University',
                style: TextStyle(
                    fontFamily: 'Karla',
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 26.sp)),
            const Spacer(),
            IconButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoomsScreen()));
            }, icon: SvgPicture.asset('res/images/tabler_send.svg')),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.h,left: 15.w,right: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              tabAlignment: TabAlignment.start,
              controller: _tabController,
              isScrollable: true,
              dividerColor: Colors.transparent,
              labelColor: Colors.black, // Active tab color
              unselectedLabelColor: Colors.grey, // Inactive tab color
              indicator: UnderlineTabIndicator(
                insets: EdgeInsets.symmetric(horizontal: 100.w),
                borderSide: BorderSide(
                  width: 3.w,
                  color: const Color(0xFF27D4C1),
                ),
              ),
              tabs: [
                Tab(
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        'res/images/ph_align-top.svg',
                        width: 30.w,
                        height: 30.h,
                        color: _tabController.index == 0 ? Colors.black : Colors.grey, // Change color based on tab index
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Top',
                        style: TextStyle(
                          fontFamily: '',
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                          color: _tabController.index == 0 ? Colors.black : Colors.grey, // Change color based on tab index
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        'res/images/pepicons-pencil_stars.svg',
                        width:  30.w,
                        height: 30.h,
                        color: _tabController.index == 1 ? Colors.black : Colors.grey, // Change color based on tab index
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        'New',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontFamily: '',
                          fontWeight: FontWeight.w600,
                          color: _tabController.index == 1 ? Colors.black : Colors.grey, // Change color based on tab index
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset('res/images/personicon.svg',
                        width: 30.w,
                        height: 30.h,
                        color: _tabController.index == 2 ? Colors.black : Colors.grey, // Change color based on tab index
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        'Following',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                          color: _tabController.index == 2 ? Colors.black : Colors.grey, // Change color based on tab index
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        'res/images/material-symbols_verified-outline.svg',
                        width: 30.w,
                        height: 30.h,
                        color: _tabController.index == 3 ? Colors.black : Colors.grey, // Change color based on tab index
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        'Verified',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontFamily: '',
                          fontWeight: FontWeight.w600,
                          color: _tabController.index == 3 ? Colors.black : Colors.grey, // Change color based on tab index
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  MaterialButton(
                    height: 60.h,
                    minWidth: 120.w,
                    color: const Color(0xFF27D4C1),
                    onPressed: (){},child: const Text('Day'),
                  ),
                  MaterialButton(
                    height: 60.h,
                    minWidth: 120.w,
                    color: Colors.white,
                    onPressed: (){},child: const Text('Week'),
                  ),
                  MaterialButton(
                    height: 60.h,
                    minWidth: 120.w,
                    color: Colors.white,
                    onPressed: (){},child: const Text('Anydate'),
                  ),
                ],
              ),
            SizedBox(height: 20.h,),
            Expanded(
              child: TabBarView(
                  controller: _tabController,
                  children: [
                    // First TabBar View
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
                        } else if (!snapshot.hasData ||
                            snapshot.data!.docs.isEmpty) {
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
                              final currentUser = FirebaseAuth.instance.currentUser;
                              return Card(
                                color: Colors.white,
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
                                      GestureDetector(
                                        child: Column(
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
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> UserDetailsScreen(userId: post.userId)));
                                        },
                                      ),
                                      Spacer(),
                                      // Only show IconButton if the current user is not the author of the post
                                      currentUser != null &&
                                          currentUser.uid != post.userId
                                          ? IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder:
                                                (BuildContext context) {
                                              return Padding(
                                                padding: EdgeInsets.only(right: 20.w,top: 100.h),
                                                child: Align(
                                                  alignment:
                                                  Alignment.topRight,
                                                  child: Material(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10.r),
                                                    color: Colors.white,
                                                    child: Container(
                                                      width: 185.w,
                                                      padding: EdgeInsets.all(
                                                          16.w),
                                                      child: Column(
                                                        mainAxisSize:
                                                        MainAxisSize.min,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              IconButton(
                                                                onPressed:
                                                                    () {},
                                                                icon: Icon(
                                                                    Icons
                                                                        .report,
                                                                    size: 30
                                                                        .sp),
                                                              ),
                                                              Text("Report",
                                                                  style: TextStyle(
                                                                      fontSize: 25
                                                                          .sp,
                                                                      color: Colors
                                                                          .black)),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              IconButton(
                                                                onPressed:
                                                                    () {},
                                                                icon: Icon(
                                                                    Icons
                                                                        .block,
                                                                    size: 30
                                                                        .sp),
                                                              ),
                                                              Text("Block",
                                                                  style: TextStyle(
                                                                      fontSize: 25
                                                                          .sp,
                                                                      color: Colors
                                                                          .black)),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        icon: Icon(Icons.flag_outlined,
                                            size: 28.sp),
                                      )
                                          : Container(), // Empty container when the user is the post owner
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
                                                  SizedBox(width: 20.w),

                                                  currentUser != null &&
                                                      currentUser.uid !=
                                                          post.userId
                                                      ? IconButton(
                                                    onPressed: () async {
                                                      if (currentUser == null) {
                                                        ScaffoldMessenger.of(
                                                            context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                              content: Text(
                                                                  'Please log in to chat.')),
                                                        );
                                                        return;
                                                      }

                                                      String generateChatRoomId(
                                                          String userId1,
                                                          String userId2) {
                                                        return userId1
                                                            .hashCode <=
                                                            userId2.hashCode
                                                            ? '$userId1-$userId2'
                                                            : '$userId2-$userId1';
                                                      }

                                                      final chatRoomId =
                                                      generateChatRoomId(
                                                          currentUser.uid,
                                                          post.userId);

                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                          'chatRooms')
                                                          .doc(chatRoomId)
                                                          .set({
                                                        'chatRoomId':
                                                        chatRoomId,
                                                        'users': [
                                                          currentUser.uid,
                                                          post.userId
                                                        ],
                                                        'postContent':
                                                        post.content,
                                                        'lastMessage': '',
                                                        'updatedAt':
                                                        Timestamp.now(),
                                                      });

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChatScreen(
                                                                  chatRoomId:
                                                                  chatRoomId),
                                                        ),
                                                      );
                                                    },
                                                    icon: SizedBox(
                                                      height: 30.h,
                                                      width: 30.w,
                                                      child: SvgPicture.asset(
                                                          'res/images/forwaedbutton.svg'),
                                                    ),
                                                  )
                                                      : Container(),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              // Upvote Button (Only to cast a vote)
                                              IconButton(
                                                onPressed: () async {
                                                  final currentUser = FirebaseAuth.instance.currentUser;
                                                  if (currentUser == null) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('Please log in to vote.')),
                                                    );
                                                    return;
                                                  }

                                                  final userId = currentUser.uid;
                                                  final hasVoted = await hasUserVoted(post.id!, userId);

                                                  if (!hasVoted) {
                                                    // If the user has not voted, cast an upvote
                                                    await votePost(post.id!, userId, true);
                                                  } else {
                                                    // If the user has already voted, do nothing
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('You have already voted.')),
                                                    );
                                                  }
                                                },
                                                icon: SvgPicture.asset('res/images/iconamoon_arrow-up-2-thin.svg'),
                                              ),

                                              // Vote Count
                                              StreamBuilder<int>(
                                                stream: getVoteCount(post.id!),
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return const Text("0");
                                                  }
                                                  return Text(snapshot.data.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24.sp, color: Color(0xFF27D4C1),),);
                                                },
                                              ),

                                              // Downvote Button (Only to retract a vote)
                                              IconButton(
                                                onPressed: () async {
                                                  final userId = FirebaseAuth.instance.currentUser!.uid;
                                                  final hasVoted = await hasUserVoted(post.id!, userId);

                                                  if (hasVoted) {
                                                    // If the user has voted, retract their vote (remove the vote)
                                                    await votePost(post.id!, userId, false);
                                                  } else {
                                                    // If the user has not voted yet, do nothing
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('You haven\'t voted yet.')),
                                                    );
                                                  }
                                                },
                                                icon: SvgPicture.asset('res/images/iconamoon_arrow-down-2-thin.svg'),
                                              ),
                                            ],
                                          )

                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                    // Second TabBar View
                    const Center(child: Text('No New Post')),
                    // Third TabBar View
                    const Center(child: Text('No Follower')),
                    // Fourth TabBar View
                    const Center(child: Text('No Verified')),
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
  final Map<String, bool>? votes; // Added votes field

  Post({
    this.id,
    required this.content,
    required this.userId,
    required this.userName,
    this.userProfileUrl,
    required this.createdAt,
    this.votes,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'userId': userId,
      'userName': userName,
      'userProfileUrl': userProfileUrl,
      'createdAt': createdAt.toIso8601String(),
      'votes': votes, // Include votes in Firestore
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
      votes: map['votes'] != null
          ? Map<String, bool>.from(map['votes'])
          : null, // Parse votes from Firestore
    );
  }

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
}
