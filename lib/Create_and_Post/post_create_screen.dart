import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import '../BottomNavBarPages/first_screen_home.dart';
import '../Notification/notification.dart';

class PostCreateScreen extends StatefulWidget {
  const PostCreateScreen({super.key});

  @override
  State<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  final TextEditingController _postContentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final bool _showEmojiPicker = false;
  File? _selectedImage;

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
        await notificationServices.showNotification(
            RemoteMessage(
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

  void _toggleEmojiPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              setState(() {
                _postContentController.text += emoji.emoji;
              });
            },
          ),
        );
      },
    );
  }


  // Image Picker Functionality
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // GIF Picker Functionality
  void _pickGIF() {
    // Placeholder for GIF picker logic (can integrate giphy_get or similar library)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('GIF Picker feature coming soon!')),
    );
  }

  // Location Picker Functionality
  void _pickLocation() {
    // Placeholder for location picker logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Location Picker feature coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3F7),
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
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                _submitPost(context);
              },
              icon: SvgPicture.asset('res/images/tabler_send.svg'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.r),
        child: SingleChildScrollView(
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30.w,
                        backgroundImage: NetworkImage(
                          FirebaseAuth.instance.currentUser?.photoURL ??
                              'https://via.placeholder.com/150',
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: TextFormField(
                          controller: _postContentController,
                          minLines: 3,
                          maxLines: null,
                          decoration: const InputDecoration(
                            hintText: 'Uni help? Secret Crush? Confession? Share what’s on your mind...',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  if (_selectedImage != null)
                    Image.file(
                      _selectedImage!,
                      height: 150.h,
                      fit: BoxFit.cover,
                    ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: _toggleEmojiPicker,
                        icon: SvgPicture.asset('res/images/Post1nd.svg'),
                      ),
                      IconButton(
                        onPressed: _pickImage,
                        icon: SvgPicture.asset('res/images/Post2nd.svg'),
                      ),
                      IconButton(
                        onPressed: _pickGIF,
                        icon: SvgPicture.asset('res/images/Post3nd.svg'),
                      ),
                      IconButton(
                        onPressed: _pickLocation,
                        icon: SvgPicture.asset('res/images/Post4nd.svg'),
                      ),
                    ],
                  ),
                  if (_showEmojiPicker)
                    SizedBox(
                      height: 250.h,
                      child: EmojiPicker(
                        onEmojiSelected: (category, emoji) {
                          _postContentController.text += emoji.emoji;
                        },
                      ),
                    ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
