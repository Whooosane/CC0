import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:circleapp/controller/getx_controllers/messenger_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Widget audioPlayerItem({
  Key? key,
  required BuildContext context,
  required MessengerController controller,
  required bool isCurrentUser,
  required VoidCallback buttonpress,
  required String messageId,
  required String audioUrl,
  required int index,
}) {
  return Obx(
        () => controller.currentPlayingIndex.value == index && controller.duration.value == Duration.zero
        ? Container(
      key: key,
      margin: EdgeInsets.symmetric(horizontal: 5.px, vertical: 5.px),
      padding: EdgeInsets.all(10.px),
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.blue.withOpacity(0.1) : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.px),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 30.px,
            height: 30.px,
            child: CircularProgressIndicator(
              color: isCurrentUser ? Colors.blue.withAlpha(700) : Colors.white,
              strokeWidth: 3,
              backgroundColor: Colors.grey.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                isCurrentUser ? Colors.blue.withAlpha(700) : Colors.white,
              ),
            ),
          ),
        ],
      ),
    )
        : Row(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: buttonpress,
          child: Icon(
            controller.isPlaying.value && controller.currentPlayingIndex.value == index
                ? Icons.pause_circle_rounded
                : Icons.play_circle_fill_rounded,
            color: isCurrentUser ? Colors.blue.withAlpha(700) : Colors.white,
            size: 35.px,
          ),
        ),
        Expanded(
          child: StreamBuilder<Duration?>(
            stream: controller.audioPlayer.onPositionChanged,
            builder: (context, snapshot) {
              final progress = controller.currentPlayingIndex.value == index
                  ? (snapshot.data ?? controller.position.value)
                  : Duration.zero;
              return Container(
                margin: EdgeInsets.only(right: 5.px, left: 5.px),
                child: ProgressBar(
                  thumbRadius: 7.px,
                  progressBarColor: isCurrentUser ? Colors.blue : Colors.white,
                  baseBarColor: const Color.fromARGB(255, 208, 204, 204),
                  thumbColor: isCurrentUser ? Colors.white : Colors.white,
                  barCapShape: BarCapShape.round,
                  timeLabelLocation: TimeLabelLocation.none,
                  timeLabelType: TimeLabelType.totalTime,
                  progress: progress,
                  buffered: Duration.zero,
                  total: controller.duration.value,
                  onSeek: (duration) {
                    if (controller.currentPlayingIndex.value == index) {
                      controller.seekAudio(duration);
                    }
                  },
                ),
              );
            },
          ),
        ),
        StreamBuilder<Duration?>(
          stream: controller.audioPlayer.onPositionChanged,
          builder: (context, snapshot) {
            final currentPosition =
            controller.currentPlayingIndex.value == index ? (snapshot.data ?? controller.position.value) : Duration.zero;
            final displayText = controller.currentPlayingIndex.value == index
                ? '${_formatDuration(currentPosition)}/${_formatDuration(controller.duration.value)}'
                : _formatDuration(controller.duration.value);
            return Text(
              displayText,
              style: TextStyle(
                color: isCurrentUser ? const Color(0xff383838) : Colors.white,
                fontSize: 12.sp,
              ),
            );
          },
        ),
      ],
    ),
  );
}

String _formatDuration(Duration duration) {
  return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
}