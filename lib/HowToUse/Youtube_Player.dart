import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerScreen extends StatefulWidget {
  const YoutubePlayerScreen({super.key});

  @override
  State<YoutubePlayerScreen> createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  final videoUrl = "https://www.youtube.com/watch?v=1HNEv47ve_U";

  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoID = YoutubePlayer.convertUrlToId(videoUrl);
    if (videoID == null || videoID.isEmpty) {
      print("Error: Unable to extract video ID.");
    } else {
      print("Video ID: $videoID");
      _controller = YoutubePlayerController(
        initialVideoId: videoID,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F3F7),
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 100.h,
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_ios_new)),
        title: const Text("How to Use"),
      ),
      body: SingleChildScrollView(
        child: Padding(
         padding: REdgeInsets.symmetric(vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (_controller.initialVideoId.isNotEmpty)
                YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  onReady: () => debugPrint('Player is ready'),
                )
              else
                Center(
                  child: Text(
                    "Error loading video",
                    style: TextStyle(color: Colors.red, fontSize: 16.sp),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
