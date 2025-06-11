import 'package:cached_network_image/cached_network_image.dart';
import 'package:circleapp/controller/getx_controllers/messenger_controller.dart';
import 'package:circleapp/models/message_models/get_message_model.dart';
import 'package:circleapp/view/screens/common_screens/audio_player.dart';
import 'package:circleapp/view/screens/common_screens/full_screen_image.dart';
import 'package:circleapp/view/screens/common_screens/video_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';
import 'common_shimmer.dart';

Widget mediaWidget(
    List<Media> media, {
      required BuildContext context,
      MessengerController? messengerController,
      required bool isCurrentUser,
      String? messageId,
      required int index,
    }) {
  final MessengerController controller = messengerController ?? Get.find<MessengerController>();

  final imageAndVideo = media.where((m) => m.type == 'image' || m.type == 'video').toList();
  final audios = media.where((m) => m.type == 'audio').toList();

  if (imageAndVideo.isNotEmpty) {
    final mediaItem = imageAndVideo.first;
    if (mediaItem.type == 'image') {
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FullScreenImage(imageUrl: mediaItem.url??""),
          ),
        ),
        child: CachedNetworkImage(
          imageUrl: mediaItem.url??"",
          fit: BoxFit.cover,
          width: 55.w,
          height: 30.h,
          placeholder: (_, __) => commonShimmer(height: 30.h, width: 55.w),
          errorWidget: (_, __, ___) => const Icon(Icons.error),
        ),
      );
    } else {
      return FutureBuilder<VideoPlayerController>(
        future: controller.getVideoController(mediaItem.url??""),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
            final videoController = snapshot.data!;
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VideoPlayerScreen(videoUrl: mediaItem.url??""),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 55.w,
                    height: 30.h,
                    child: VideoPlayer(videoController),
                  ),
                  Container(
                    padding: EdgeInsets.all(6.px),
                    decoration:  BoxDecoration(
                      color: Colors.blue.withAlpha(700),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 30.px,
                    ),
                  ),
                ],
              ),
            );
          }
          return commonShimmer(height: 30.h, width: 55.w);
        },
      );
    }
  } else if (audios.isNotEmpty && messageId != null) {
    final audio = audios.first;
    return audioPlayerItem(
      key: ValueKey(messageId),
      context: context,
      controller: controller,
      isCurrentUser: isCurrentUser,
      buttonpress: () => controller.playAudio(audio.url??"", index),
      messageId: messageId,
      audioUrl: audio.url??"",
      index: index,
    );
  }
  return const SizedBox();
}