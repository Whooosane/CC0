import 'dart:io';
import 'package:circleapp/controller/getx_controllers/chat_socket_controller.dart';
import 'package:circleapp/controller/getx_controllers/messenger_controller.dart';
import 'package:circleapp/controller/getx_controllers/picker_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/common_methods.dart';
import 'package:circleapp/controller/utils/preference_keys.dart';
import 'package:circleapp/controller/utils/shared_preferences.dart';
import 'package:circleapp/controller/utils/style/customTextStyle.dart';
import 'package:circleapp/models/message_models/get_message_model.dart';
import 'package:circleapp/models/message_models/post_message_model.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';

class SendMediaScreen extends StatefulWidget {
  final String itemId;
  final RxList<String> messagesId;
  final String token;

  const SendMediaScreen({super.key, required this.itemId, required this.messagesId, required this.token});

  @override
  State<SendMediaScreen> createState() => _SendMediaScreenState();
}

class _SendMediaScreenState extends State<SendMediaScreen> {
  final TextEditingController messageController = TextEditingController();
  late MessengerController messengerController;
  late ChatSocketService chatSocketService;
  late String currentUserId;
  VideoPlayerController? _controller;
  Rx<bool> isPlaying = false.obs;
  Rx<bool> isBuffering = false.obs;
  Rx<bool> isCompleted = false.obs;
  Rx<double> progress = 0.0.obs;
  Rx<bool> isVideoInitialized = false.obs;
  Rx<String?> videoError = Rx<String?>(null);

  @override
  void initState() {
    super.initState();
    messengerController = Get.put(MessengerController(context));
    chatSocketService = Get.put(ChatSocketService());
    currentUserId = MySharedPreferences.getString(currentUserIdKey);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PickerController imagePickerController = Get.put(PickerController());
    return Obx(() => PopScope(
      canPop: false,
      onPopInvoked: (didPop) => imagePickerController.pickedImage.value = null,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          backgroundColor: Colors.black.withOpacity(0.7),
        ),
        body: Column(
          children: [
            if (isImageFile(imagePickerController.pickedImage.value)) ...[
              Expanded(
                child: PhotoView(
                  imageProvider: FileImage(File(imagePickerController.pickedImage.value!.path)),
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 1.8,
                  initialScale: PhotoViewComputedScale.contained,
                ),
              ),
            ] else ...[
              Expanded(
                child: buildVideoPlayer(
                  videoFile: File(imagePickerController.pickedImage.value!.path),
                  isSending: messengerController.loading.value,
                ),
              ),
              buildVideoControls(),
            ],
            Container(
              margin: EdgeInsets.only(right: 10.px, bottom: 10.px, left: 10.px),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10.px),
                      padding: EdgeInsets.symmetric(horizontal: .8.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.px),
                        color: AppColors.mainColor,
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/svg/icons.svg'),
                          getHorizentalSpace(.8.h),
                          Expanded(
                            child: TextFormField(
                              controller: messageController,
                              autocorrect: false,
                              enableSuggestions: false,
                              cursorHeight: 2.h,
                              style: CustomTextStyle.hintText,
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.px),
                                  borderSide: const BorderSide(color: AppColors.textFieldColor),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.textFieldColor),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.px),
                                  borderSide: const BorderSide(color: AppColors.textFieldColor),
                                ),
                                isCollapsed: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 1.6.h),
                                fillColor: AppColors.textFieldColor,
                                hintText: 'Write your message',
                                hintStyle: CustomTextStyle.hintText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  getHorizentalSpace(1.h),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.px),
                    child: GestureDetector(
                      onTap: () => _sendMedia(imagePickerController),
                      child: Container(
                        padding: EdgeInsets.all(13.px),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.mainColorYellow,
                        ),
                        child: messengerController.loading.value
                            ? SizedBox(
                          height: 15.px,
                          width: 15.px,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2.px,
                          ),
                        )
                            : Icon(Icons.send, size: 15.px),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget buildVideoPlayer({required File videoFile, required bool isSending}) {
    _controller?.dispose();
    _controller = VideoPlayerController.file(videoFile);
    isVideoInitialized.value = false;
    videoError.value = null;

    _controller!.initialize().then((_) {
      isVideoInitialized.value = true;
      _controller!.addListener(updateVideoState);
      isSending ? _controller!.pause() : _controller!.play();
    }).catchError((error) {
      videoError.value = "Failed to load video: $error";
    });

    return Obx(() {
      if (videoError.value != null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: 10),
              Text(
                videoError.value!,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }
      if (!isVideoInitialized.value) {
        return Center(
          child: Container(
            padding: EdgeInsets.all(20.px),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12.px),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 4.px,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  'Loading Video...',
                  style: CustomTextStyle.hintText.copyWith(color: Colors.white, fontSize: 14.sp),
                ),
              ],
            ),
          ),
        );
      }
      return AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: VideoPlayer(_controller!),
      );
    });
  }

  Widget buildVideoControls() {
    return Obx(() => isVideoInitialized.value
        ? Container(
      color: Colors.black,
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                isPlaying.value ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: () => isPlaying.value ? pause() : play(),
            ),
            Text(
              _formatDuration(_controller?.value.position ?? Duration.zero),
              style: const TextStyle(color: Colors.white),
            ),
            Expanded(
              child: Slider(
                value: progress.value.clamp(0.0, _controller!.value.duration.inMilliseconds.toDouble()),
                min: 0.0,
                max: _controller!.value.duration.inMilliseconds.toDouble() > 0
                    ? _controller!.value.duration.inMilliseconds.toDouble()
                    : 1.0,
                onChanged: (value) => _controller!.seekTo(Duration(milliseconds: value.toInt())),
              ),
            ),
            Text(
              _formatDuration(_controller?.value.duration ?? Duration.zero),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    )
        : const SizedBox());
  }

  void updateVideoState() {
    if (_controller!.value.isInitialized) {
      progress.value = _controller!.value.position.inMilliseconds.toDouble();
      isBuffering.value = _controller!.value.isBuffering;
      isCompleted.value = _controller!.value.isCompleted;
      isPlaying.value = _controller!.value.isPlaying;
    }
  }

  void play() {
    if (_controller!.value.isInitialized) {
      isPlaying.value = true;
      _controller!.play();
    }
  }

  void pause() {
    if (_controller!.value.isInitialized) {
      isPlaying.value = false;
      _controller!.pause();
    }
  }

  String _formatDuration(Duration duration) {
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  void _sendMedia(PickerController imagePickerController) {
    messengerController.uploadFile(load: true, file: File(imagePickerController.pickedImage.value!.path)).then((value) {
      if (value != null) {
        final file = imagePickerController.pickedImage.value;
        String type = isImageFile(file) ? "image" : "video";

        if (type == "video" && (_controller == null || !_controller!.value.isInitialized)) {
          customScaffoldMessenger("Video not ready");
          return;
        }

         Media(type: type, url: value, mimetype: "$type/${getFileExtension(file)}");
        imagePickerController.pickedImage.value = null;
        messengerController.sendMessage(
          token: widget.token,
          messagesId: widget.messagesId,
          load: false,
          postMessageModel: PostMessageModel(
            circleId: widget.itemId,
            message: messageController.text,
            media: [
              PostMedia(type: type, url: value, mimetype: "$type/${getFileExtension(file)}"),
            ],
          ),
        );
      } else {
        customScaffoldMessenger("Failed to Send");
      }
    });
  }
}