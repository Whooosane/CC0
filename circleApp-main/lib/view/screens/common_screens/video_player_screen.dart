import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';
class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerScreen({super.key, required this.videoUrl});
  @override
  VideoPlayerScreenState createState() {
    return VideoPlayerScreenState();
  }
}

class VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final VideoPlayerController _controller;
  final RxBool isPlaying = false.obs;
  final RxBool isBuffering = false.obs;
  final RxBool isCompleted = false.obs;
  final RxDouble progress = 0.0.obs;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        _controller.addListener(() {
          progress.value = _controller.value.position.inMilliseconds.toDouble();
          isBuffering.value = _controller.value.isBuffering;
          isCompleted.value = _controller.value.isCompleted;
          isPlaying.value = _controller.value.isPlaying;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.black.withOpacity(0.7),
      ),
      body: GestureDetector(
        onTap: () => isPlaying.value ? _pause() : _play(),
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  Obx(
                        () => isBuffering.value && !isCompleted.value
                        ? LoadingAnimationWidget.progressiveDots(
                      color: Colors.white,
                      size: 50,
                    )
                        : !isPlaying.value
                        ? Container(
                      width: 80.px,
                      height: 80.px,
                      padding: EdgeInsets.all(12.px),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.mainColorYellow,
                            AppColors.secondaryColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 28.px,
                        shadows: [
                          Shadow(
                            color: AppColors.primaryColor.withOpacity(0.4),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    )
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
            Obx(
                  () => Container(
                padding: EdgeInsets.all(8.px),
                color: Colors.black.withOpacity(0.5),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isPlaying.value ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: () => isPlaying.value ? _pause() : _play(),
                    ),
                    Text(
                      _formatDuration(_controller.value.position),
                      style: const TextStyle(color: Colors.white),
                    ),
                    Expanded(
                      child: Slider(
                        value: progress.value,
                        min: 0,
                        max: _controller.value.duration.inMilliseconds.toDouble(),
                        activeColor: AppColors.mainColorYellow,
                        inactiveColor: AppColors.secondaryColor,
                        onChanged: (value) => _controller.seekTo(Duration(milliseconds: value.toInt())),
                      ),
                    ),
                    Text(
                      _formatDuration(_controller.value.duration),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _play() {
    isPlaying.value = true;
    _controller.play();
  }

  void _pause() {
    isPlaying.value = false;
    _controller.pause();
  }

  String _formatDuration(Duration duration) {
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }
}