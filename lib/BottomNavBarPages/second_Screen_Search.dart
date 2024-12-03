import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBarScreen extends StatefulWidget {
  const SearchBarScreen({super.key});

  @override
  State<SearchBarScreen> createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

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
      backgroundColor: const Color(0xFFF5F3F7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: 130.h,
        title: TextFormField(
          controller: _searchController,
          decoration: InputDecoration(

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(60.r),
              borderSide: BorderSide(width: 0.8.w),
            ),
            hintText: 'Search...',
            prefixIcon: Icon(Icons.search, size: 40.sp),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value.trim();
            });
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No posts found.'));
          } else {
            final posts = snapshot.data!.docs.where((doc) {
              if (_searchQuery.isEmpty) return false;
              final data = doc.data() as Map<String, dynamic>;
              final content = data['content'] as String? ?? '';
              return content.toLowerCase().contains(_searchQuery.toLowerCase());
            }).toList();

            if (posts.isEmpty) {
              return const Center(child: Text('No posts match your search.'));
            }

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                final data = post.data() as Map<String, dynamic>;

                final content =
                    data['content'] as String? ?? 'No content available';
                final userName = data['userName'] as String? ?? 'Anonymous';
                final userProfileUrl = data['userProfileUrl'] as String?;
                final createdAt = data['createdAt'];

                // Check the type of 'createdAt' and parse accordingly
                DateTime? timestamp;
                if (createdAt is Timestamp) {
                  timestamp = createdAt.toDate(); // Timestamp to DateTime
                } else if (createdAt is String) {
                  timestamp =
                      DateTime.tryParse(createdAt); // String to DateTime
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4,
                    color: Colors.white,
                    child: ListTile(
                      title: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: userProfileUrl != null
                                ? NetworkImage(userProfileUrl)
                                : null,
                            child: userProfileUrl == null
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          SizedBox(width: 20.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.sp),
                              ),
                              Text(
                                timestamp != null
                                    ? getFormattedTime(timestamp, context)
                                    : 'No timestamp available',
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      subtitle: Row(
                        children: [
                          SizedBox(
                            width: 320.w,
                            child: _buildHighlightedText(content, _searchQuery),
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  final userId =
                                      "loggedInUserId"; // Replace with the actual logged-in user's ID
                                  final hasVoted =
                                      await hasUserVoted(post.id, userId);

                                  if (!hasVoted) {
                                    // User has not voted yet, so they can only add a vote
                                    await votePost(
                                        post.id, userId, true); // Add vote
                                  } else {
                                    // User has voted, so they can only remove their vote
                                    await votePost(
                                        post.id, userId, false); // Remove vote
                                  }
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_up,
                                  size: 35.sp,
                                ),
                              ),
                              StreamBuilder<int>(
                                stream: getVoteCount(post.id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Text("0");
                                  } else if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data!.toString(),
                                      style: TextStyle(
                                        fontSize: 32.sp,
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
                                  final userId =
                                      "loggedInUserId"; // Replace with actual user ID
                                  final hasVoted =
                                      await hasUserVoted(post.id, userId);

                                  if (!hasVoted) {
                                    // User has not voted yet, so they can only add a vote
                                    await votePost(
                                        post.id, userId, true); // Add vote
                                  } else {
                                    // User has voted, so they can only remove their vote
                                    await votePost(
                                        post.id, userId, false); // Remove vote
                                  }
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  size: 35.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        // Handle post click
                      },
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

String getFormattedTime(DateTime timestamp, BuildContext context) {
  final now = DateTime.now();

  if (timestamp.day == now.day &&
      timestamp.month == now.month &&
      timestamp.year == now.year) {
    return 'Today ${TimeOfDay.fromDateTime(timestamp).format(context)}';
  } else {
    return '${timestamp.day} ${_getMonthName(timestamp.month)} ${timestamp.year} ${TimeOfDay.fromDateTime(timestamp).format(context)}';
  }
}

String _getMonthName(int month) {
  const monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return monthNames[month - 1];
}

Widget _buildHighlightedText(String text, String query) {
  if (query.isEmpty) {
    return Text(text);
  }

  final queryLower = query.toLowerCase();
  final textLower = text.toLowerCase();

  final spans = <TextSpan>[];
  int start = 0;
  int index;

  while ((index = textLower.indexOf(queryLower, start)) != -1) {
    if (start != index) {
      spans.add(TextSpan(
        text: text.substring(start, index),
        style: const TextStyle(color: Colors.black),
      ));
    }

    spans.add(TextSpan(
      text: text.substring(index, index + query.length),
      style: const TextStyle(
        backgroundColor: Color(0xFFa6f7f1),
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ));

    start = index + query.length;
  }

  if (start < text.length) {
    spans.add(TextSpan(
      text: text.substring(start),
      style: const TextStyle(color: Colors.black),
    ));
  }

  return RichText(text: TextSpan(children: spans));
}
