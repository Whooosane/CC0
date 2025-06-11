import 'dart:async';
import 'dart:io';
import 'package:circleapp/controller/getx_controllers/chat_socket_controller.dart';
import 'package:circleapp/controller/getx_controllers/circle_controller.dart';
import 'package:circleapp/controller/getx_controllers/convos_controller.dart';
import 'package:circleapp/controller/getx_controllers/messenger_controller.dart';
import 'package:circleapp/controller/getx_controllers/picker_controller.dart';
import 'package:circleapp/controller/utils/app_colors.dart';
import 'package:circleapp/controller/utils/common_methods.dart';
import 'package:circleapp/controller/utils/global_variables.dart';
import 'package:circleapp/controller/utils/preference_keys.dart';
import 'package:circleapp/controller/utils/shared_preferences.dart';
import 'package:circleapp/controller/utils/style/customTextStyle.dart';
import 'package:circleapp/models/message_models/get_message_model.dart';
import 'package:circleapp/models/message_models/post_message_model.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:circleapp/view/custom_widget/media_widget.dart';
import 'package:circleapp/view/screens/common_screens/send_media_screen.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vibration/vibration.dart';
import 'circle_profile_screen.dart';
import 'package:circleapp/view/screens/explore_section/early_bird_offer.dart' as OfferDetails;

import 'offer_details_screen.dart';

class MessageDetailScreen extends StatefulWidget {
  const MessageDetailScreen({
    super.key,
    this.title,
    required this.itemId,
    required this.chatCircleImage,
    required this.chatCircleName,
  });

  final String? title;
  final String itemId, chatCircleImage, chatCircleName;

  @override
  State<MessageDetailScreen> createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
  late MessengerController messengerController;
  late CircleController circleController;
  late ConvosController convosController;
  final imagePickerController = Get.put(PickerController());
  final chatSocketService = Get.put(ChatSocketService());
  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final currentUserId = MySharedPreferences.getString(currentUserIdKey);
  final pinMessageIdsList = <String>[].obs;
  final messageLength = ''.obs;
  final _recorder = FlutterSoundRecorder();
  final isRecording = false.obs;
  final recordTimer = "00:00".obs;
  final isSending = false.obs;
  final isDraggingToCancel = false.obs;
  final showEmojiPicker = false.obs;
  final cancelRecordingFlag = false.obs;
  Timer? _timer;
  String? _audioFilePath;
  String? _audioFile;
  List<String> circleMemberNames = [];
  final token = MySharedPreferences.getString(userTokenKey).obs;
  bool _hasMicPermission = false;
  final f = DateFormat('dd/MM/yyy');

  @override
  void initState() {
    super.initState();
    messengerController = Get.put(MessengerController(context));
    circleController = Get.put(CircleController(context));
    convosController = Get.put(ConvosController(context));
    _initRecorder();
    _checkMicPermission();
    messengerController.getMessages(
      load: messengerController.messagesModel.value == null || messengerController.messagesModel.value?.circleId != widget.itemId,
      circleId: widget.itemId,
    ).then((_) => _scrollToEnd());
    _getCircleMembers();
    chatSocketService.removeMessageListeners();
    chatSocketService.listenForNewMessagesInChat((_, message) {
      try {
        if (message is Map<String, dynamic>) {
          final newMessage = MessageData.fromJson(message as Map<String, dynamic>);
          if (!messengerController.messagesModel.value!.data.any((m) => m.text == newMessage.text && m.sentAt == newMessage.sentAt)) {
            _scrollToEnd();
            messengerController.messagesModel.value!.data.add(newMessage);
            messengerController.messagesModel.refresh();
          }
        } else {
          debugPrint('Received message is not a Map<String, dynamic>: $message');
        }
      } catch (e) {
        debugPrint('Error processing socket message: $e');
      }
    });
    messageController.addListener(() => messageLength.value = messageController.text);
  }

  Future<void> _initRecorder() async {
    await _recorder.openRecorder();
    _recorder.setSubscriptionDuration(const Duration(milliseconds: 100));
  }

  Future<void> _checkMicPermission() async => _hasMicPermission = await Permission.microphone.isGranted || await Permission.microphone.request().isGranted;

  Future<void> _getCircleMembers() async {
    await circleController.getCircleMembers(load: circleController.circleMembersModel.value == null, circleId: widget.itemId);
    circleMemberNames = circleController.circleMembersModel.value?.members.map((m) => m.name).toList() ?? [];
  }

  void _scrollToEnd() => WidgetsBinding.instance.addPostFrameCallback((_) {
    if (scrollController.hasClients && scrollController.position.maxScrollExtent > 0) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  });

  void _toggleEmojiPicker() {
    showEmojiPicker.value = !showEmojiPicker.value;
    showEmojiPicker.value ? FocusScope.of(context).unfocus() : FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<void> _startRecording() async {
    if (!_hasMicPermission) {
      _hasMicPermission = await Permission.microphone.request().isGranted;
      if (!_hasMicPermission) return customScaffoldMessenger('Microphone permission required.');
    }
    if (_recorder.isRecording) return;
    final dir = await getTemporaryDirectory();
    _audioFilePath = '${dir.path}/sound_${DateTime.now().millisecondsSinceEpoch}.aac';
    await _recorder.startRecorder(toFile: _audioFilePath, codec: Codec.aacADTS, bitRate: 64000, sampleRate: 32000);
    isRecording.value = true;
    cancelRecordingFlag.value = false;
    isDraggingToCancel.value = false;
    if (await Vibration.hasVibrator()) Vibration.vibrate(duration: 50);
    int seconds = -1;
    _timer?.cancel();
    void updateTimer() {
      seconds++;
      recordTimer.value = '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
      if (seconds >= 300) {
        _stopRecordingAndSend();
        customScaffoldMessenger('Maximum recording duration reached.');
      }
    }

    updateTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => updateTimer());
  }

  Future<void> _stopRecordingAndSend() async {
    if (!_recorder.isRecording || cancelRecordingFlag.value) return;
    isRecording.value = false;
    _timer?.cancel();
    recordTimer.value = "00:00";
    if (await Vibration.hasVibrator()) Vibration.vibrate(duration: 50);
    await _recorder.stopRecorder();
    if (_audioFilePath == null) return;
    isSending.value = true;
    final file = File(_audioFilePath!);
    if (await file.exists()) {
      _audioFile = await messengerController.uploadFile(load: true, file: file);
      if (_audioFile != null) {
        await messengerController.sendMessage(
          messagesId: pinMessageIdsList,
          token: token.value,
          load: messengerController.messagesModel.value == null,
          postMessageModel: PostMessageModel(
            circleId: widget.itemId,
            message: "",
            media: [PostMedia(type: "audio", url: _audioFile!, mimetype: 'audio/aac')],
          ),
        );
        customScaffoldMessenger('Voice message sent successfully.');
        _scrollToEnd();
      } else {
        customScaffoldMessenger('Failed to upload audio file.');
      }
      await _deleteFile(_audioFilePath);
    }
    isSending.value = false;
    _resetRecording();
  }

  Future<void> _cancelRecording() async {
    if (!_recorder.isRecording) return;
    isRecording.value = false;
    cancelRecordingFlag.value = true;
    isDraggingToCancel.value = false;
    _timer?.cancel();
    recordTimer.value = "00:00";
    await _recorder.stopRecorder();
    await _deleteFile(_audioFilePath);
    customScaffoldMessenger('Recording cancelled.');
    if (await Vibration.hasVibrator()) Vibration.vibrate(duration: 50);
    _resetRecording();
  }

  Future<void> _deleteFile(String? path) async {
    if (path != null && await File(path).exists()) await File(path).delete();
  }

  void _resetRecording() {
    _audioFilePath = null;
    _audioFile = null;
  }

  void _sendTextMessage() async {
    if (isSending.value || messageLength.value.trim().isEmpty) return;
    isSending.value = true;
    await messengerController.sendMessage(
      messagesId: pinMessageIdsList,
      token: token.value,
      load: messengerController.messagesModel.value == null,
      postMessageModel: PostMessageModel(circleId: widget.itemId, message: messageLength.value.trim(), media: []),
    );
    messageController.clear();
    messageLength.value = "";
    _scrollToEnd();
    isSending.value = false;
  }

  @override
  void dispose() {
    isMainChat = true;
    chatSocketService.leaveRoom(widget.itemId);
    messageController.dispose();
    scrollController.dispose();
    _timer?.cancel();
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Obx(
            () => imagePickerController.pickedImage.value != null
            ? SendMediaScreen(itemId: widget.itemId, messagesId: pinMessageIdsList, token: token.value)
            : Column(
          children: [
            SizedBox(height: 6.h),
            _buildAppBar(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Column(
                  children: [
                    Expanded(child: _buildMessageList(context)),
                    _buildInputArea(context),
                  ],
                ),
              ),
            ),
            AnimatedSlide(
              offset: showEmojiPicker.value ? Offset.zero : const Offset(0, 1),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Offstage(
                offstage: !showEmojiPicker.value,
                child: EmojiPicker(
                  onEmojiSelected: (_, emoji) {
                    messageController.text += emoji.emoji;
                    messageLength.value = messageController.text;
                  },
                  config: const Config(height: 256, emojiViewConfig: EmojiViewConfig(emojiSizeMax: 28)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() => Container(
    height: 50.px,
    padding: EdgeInsets.symmetric(horizontal: 1.5.h, vertical: 5.px),
    child: Row(
      children: [
        GestureDetector(
          onTap: () => pinMessageIdsList.isNotEmpty ? pinMessageIdsList.clear() : Get.back(),
          child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 2.5.h),
        ),
        SizedBox(width: 2.h),
        if (pinMessageIdsList.isNotEmpty) ...[
          Text("${pinMessageIdsList.length}", style: CustomTextStyle.buttonText.copyWith(color: Colors.white)),
          Expanded(child: SvgPicture.asset('assets/svg/pin.svg', alignment: Alignment.centerRight)),
          SizedBox(width: 1.h),
          Text('Pin', style: CustomTextStyle.headingStyle),
          SizedBox(width: 2.h),
          convosController.addConvosLoading.value
              ? LoadingAnimationWidget.progressiveDots(color: AppColors.mainColorYellow, size: 30.px)
              : GestureDetector(
            onTap: () => convosController
                .addToConvos(token: token.value, circleId: widget.itemId, messageIds: pinMessageIdsList)
                .then((_) => pinMessageIdsList.clear()),
            child: Text('Add to convos', style: CustomTextStyle.mediumTextTab),
          ),
          SizedBox(width: 1.h),
        ] else ...[
          messengerController.loading.value
              ? Shimmer.fromColors(
            baseColor: AppColors.shimmerColor1,
            highlightColor: AppColors.shimmerColor2,
            child: Container(width: 40, height: 40, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red)),
          )
              : GestureDetector(
            onTap: () => Get.to(() => CircleProfileScreen(circleId: widget.itemId)),
            child: widget.chatCircleImage.isEmpty
                ? CircleAvatar(
              radius: 20.px,
              backgroundColor: AppColors.textFieldColor,
              backgroundImage: const AssetImage('assets/png/members.png'),
            )
                : ClipOval(
              child: Image.network(
                widget.chatCircleImage,
                fit: BoxFit.cover,
                width: 40,
                height: 40,
                errorBuilder: (_, __, ___) => Image.network(circleImagePlaceholder, fit: BoxFit.cover, width: 40, height: 40),
              ),
            ),
          ),
          SizedBox(width: 1.5.h),
          GestureDetector(
            onTap: () => Get.to(() => CircleProfileScreen(circleId: widget.itemId)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.chatCircleName, style: CustomTextStyle.headingStyle.copyWith(fontSize: 12.px)),
                Container(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      circleMemberNames.join(', '),
                      style: TextStyle(fontSize: 10.px, fontWeight: FontWeight.w400, fontFamily: 'medium', color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    ),
  );

  Widget _buildMessageList(BuildContext context) => Obx(
        () => messengerController.loading.value
        ? Shimmer.fromColors(
      baseColor: AppColors.shimmerColor1,
      highlightColor: AppColors.shimmerColor2,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (_, __) => Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          height: 10.h,
          decoration: BoxDecoration(color: AppColors.mainColor, borderRadius: BorderRadius.circular(10.px)),
        ),
      ),
    )
        : (messengerController.messagesModel.value?.data.isEmpty ?? true)
        ? Center(
      child: Text(
        "No messages yet.",
        style: CustomTextStyle.messageDetailText,
      ),
    )
        : ListView.builder(
      controller: scrollController,
      itemCount: messengerController.messagesModel.value!.data.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final message = messengerController.messagesModel.value!.data[index];
        final isCurrentUser = message.senderId == currentUserId;
        final profilePicture = message.type == 'plan'
            ? (message.planDetails?.createdBy.profilePicture ?? message.senderProfilePicture)
            : message.type == 'itinerary'
            ? (message.senderProfilePicture)
            : message.type == 'offer'
            ? (message.offerDetails?.imageUrls[0] ?? message.senderProfilePicture)
            : message.senderProfilePicture;
        return GestureDetector(
          onTap: () => pinMessageIdsList.isNotEmpty
              ? pinMessageIdsList.contains(message.id)
              ? pinMessageIdsList.remove(message.id)
              : pinMessageIdsList.add(message.id)
              : null,
          onLongPress: () {
            !pinMessageIdsList.contains(message.id) ? pinMessageIdsList.add(message.id) : null;
            print("PinedMessage :$pinMessageIdsList");
          },
          child: Stack(
            children: [
              if (pinMessageIdsList.contains(message.id))
                Container(
                  padding: EdgeInsets.only(right: 2.h),
                  margin: EdgeInsets.only(top: 1.h),
                  alignment: isCurrentUser ? Alignment.centerLeft : Alignment.centerRight,
                  height: 7.7.h,
                  width: MediaQuery.of(context).size.width,
                  child: SvgPicture.asset('assets/svg/selected.svg'),
                ),
              Row(
                mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isCurrentUser) ...[
                    ClipOval(
                      child: Image.network(
                        profilePicture,
                        fit: BoxFit.cover,
                        width: 35,
                        height: 35,
                        errorBuilder: (_, __, ___) => Image.network(
                          circleImagePlaceholder,
                          fit: BoxFit.cover,
                          width: 35,
                          height: 35,
                        ),
                      ),
                    ),
                    SizedBox(width: 1.w),
                  ],
                  Flexible(
                    child: Column(
                      crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        _buildMessageContent(context, message, isCurrentUser, index),
                        Container(
                          margin: EdgeInsets.only(top: 5.px, bottom: 15.px),
                          child: Text(
                            getCurrentTimeIn12HourFormat(DateTime.parse(message.sentAt)),
                            style: CustomTextStyle.messageDetailDate,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isCurrentUser) ...[
                    SizedBox(width: 3.w),
                    ClipOval(
                      child: Image.network(
                        profilePicture,
                        fit: BoxFit.cover,
                        width: 35,
                        height: 35,
                        errorBuilder: (_, __, ___) => Image.network(
                          circleImagePlaceholder,
                          fit: BoxFit.cover,
                          width: 35,
                          height: 35,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    ),
  );

  Widget _buildMessageContent(BuildContext context, MessageData message, bool isCurrentUser, int index) {
    final borderRadius = BorderRadius.only(
      bottomLeft: const Radius.circular(10),
      bottomRight: const Radius.circular(10),
      topRight: isCurrentUser ? Radius.zero : const Radius.circular(10),
      topLeft: isCurrentUser ? const Radius.circular(10) : Radius.zero,
    );

    if (message.type == "plan") {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 2.2.h, vertical: 2.h),
        width: 60.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.textFieldColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  message.planDetails?.planName.toString() ?? "",
                  style: CustomTextStyle.headingStyle.copyWith(fontSize: 14.px),
                ),
                Text(
                  message.planDetails?.date != null
                      ? f.format(DateTime.parse(message.planDetails!.date.toString()))
                      : "",
                  style: CustomTextStyle.headingStyle.copyWith(fontSize: 14.px),
                ),
              ],
            ),
            SizedBox(height: 4.px),
            Text(
              message.planDetails?.description ?? "",
              style: CustomTextStyle.messageDetailText.copyWith(fontSize: 12.px, color: Colors.white70),
            ),
            SizedBox(height: 4.px),
            Row(
              children: [
                SvgPicture.asset("assets/svg/Location.svg"),
                Text(
                  message.planDetails?.location ?? "",
                  style: CustomTextStyle.messageDetailText.copyWith(fontSize: 12.px, color: Colors.white70),
                ),
              ],
            ),
            SizedBox(height: 10.px),
            Text(
              "Added members",
              style: CustomTextStyle.messageDetailText.copyWith(fontSize: 12.px, color: Colors.white, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10.px),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: message.planDetails?.members.take(3).map((member) {
                    // Access profilePicture as a map key
                    final profilePicture = member is Map<String, dynamic> && member['profilePicture'] != null
                        ? member['profilePicture']
                        : circleImagePlaceholder;
                    return Padding(
                      padding: EdgeInsets.only(right: 5.px),
                      child: ClipOval(
                        child: Image.network(
                          profilePicture,
                          fit: BoxFit.cover,
                          width: 25,
                          height: 25,
                          errorBuilder: (_, __, ___) => Image.network(
                            circleImagePlaceholder,
                            fit: BoxFit.cover,
                            width: 25,
                            height: 25,
                          ),
                        ),
                      ),
                    );
                  }).toList() ??
                      [],
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                  decoration: BoxDecoration(
                    color: AppColors.mainColorYellow,
                    borderRadius: BorderRadius.circular(100.px),
                    border: Border.all(color: AppColors.mainColorYellow),
                  ),
                  child: Text(
                    "Booked",
                    style: CustomTextStyle.messageDetailText.copyWith(fontSize: 12.px, color: AppColors.mainColorBackground),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (message.type == "offer") {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 1.5.h, vertical: 1.h),
        width: MediaQuery.of(context).size.width * 0.75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.textFieldColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.offerDetails?.title.toString() ?? "",
              style: CustomTextStyle.headingStyle.copyWith(fontSize: 14.px),
            ),
            SizedBox(height: 5.px),
            Text(
              message.offerDetails?.description ?? "",
              style: CustomTextStyle.messageDetailText.copyWith(fontSize: 12.px, color: Colors.white70),
            ),
            SizedBox(height: 10.px),
            if (message.offerDetails?.imageUrls.isNotEmpty ?? false) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: message.offerDetails!.imageUrls.take(3).map((url) {
                      return Padding(
                        padding: EdgeInsets.only(right: 5.px),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.px),
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                            width: 40,
                            height: 40,
                            errorBuilder: (_, __, ___) => Container(
                              width: 40,
                              height: 40,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("DEBUG: View offer details");
                      // Get.to(() => OfferDetails(offer: message.offerDetails,token: token.value ));
                      Get.to(OfferDetailsScreen(offer: message.offerDetails!,token: token.value,));

                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.px),
                        border: Border.all(color: AppColors.mainColorYellow),
                      ),
                      child: Text(
                        "View Details",
                        style: CustomTextStyle.messageDetailText.copyWith(fontSize: 12.px, color: AppColors.mainColorYellow),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    } else if (message.type == "itinerary") {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 2.2.h, vertical: 1.h),
        width: MediaQuery.of(context).size.width * 0.75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.textFieldColor.withOpacity(0.5),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.fiber_manual_record, size: 12.px, color: Colors.white),
                SizedBox(width: 10.px),
                Expanded(
                  child: Text(
                    message.itineraryDetails?.name ?? "Itinerary",
                    style: CustomTextStyle.messageDetailText.copyWith(fontSize: 12.px, color: Colors.white),
                  ),
                ),
                Text(
                  message.itineraryDetails?.time ?? "",
                  style: CustomTextStyle.messageDetailText.copyWith(fontSize: 12.px, color: Colors.white70),
                ),
                SizedBox(width: 10.px),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 6.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      message.itineraryDetails?.about ?? "",
                      style: CustomTextStyle.messageDetailText.copyWith(fontSize: 12.px, color: AppColors.mainColorYellow),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (message.media.isNotEmpty) {
      return Container(
        width: 60.w,
        padding: EdgeInsets.only(top: 5.px, left: 5.px, right: 5.px),
        decoration: BoxDecoration(
          color: isCurrentUser ? AppColors.mainColorYellow : AppColors.textFieldColor,
          borderRadius: borderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            mediaWidget(
              message.media,
              context: context,
              messengerController: messengerController,
              isCurrentUser: isCurrentUser,
              messageId: message.id,
              index: index,
            ),
            if (message.media.first.type != "audio" && message.text.isNotEmpty)
              Container(
                margin: EdgeInsets.symmetric(vertical: 15.px),
                child: Text(
                  message.text,
                  style: isCurrentUser ? CustomTextStyle.currentUserMessageDetailText : CustomTextStyle.messageDetailText,
                  overflow: TextOverflow.visible,
                ),
              )
            else
              SizedBox(height: 5.px),
          ],
        ),
      );
    }
    return Container(
      alignment: Alignment.center,
      width: 60.w,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      decoration: BoxDecoration(
        color: isCurrentUser ? AppColors.mainColorYellow : AppColors.textFieldColor,
        borderRadius: borderRadius,
      ),
      child: Text(
        message.text,
        style: isCurrentUser ? CustomTextStyle.currentUserMessageDetailText : CustomTextStyle.messageDetailText,
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) => Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isRecording.value)
            Expanded(
              child: GestureDetector(
                onHorizontalDragUpdate: (details) => details.delta.dx < 0 ? isDraggingToCancel.value = true : null,
                onHorizontalDragEnd: (_) {
                  isDraggingToCancel.value ? _cancelRecording() : _stopRecordingAndSend();
                  isDraggingToCancel.value = false;
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10.px, horizontal: 1.h),
                  padding: EdgeInsets.all(10.px),
                  decoration: BoxDecoration(color: AppColors.mainColorYellow.withOpacity(0.2), borderRadius: BorderRadius.circular(15.px)),
                  child: Row(
                    children: [
                      Icon(
                        isDraggingToCancel.value ? Icons.delete : Icons.mic,
                        color: isDraggingToCancel.value ? Colors.grey : Colors.red,
                        size: 2.5.h,
                      ),
                      SizedBox(width: 1.h),
                      Text(recordTimer.value, style: CustomTextStyle.hintText.copyWith(color: Colors.white)),
                      SizedBox(width: 1.h),
                      Text(
                        isDraggingToCancel.value ? "Release to cancel" : "Slide left to cancel",
                        style: CustomTextStyle.hintText.copyWith(color: isDraggingToCancel.value ? Colors.grey : Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.px),
                padding: EdgeInsets.symmetric(horizontal: .8.h),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.px), color: AppColors.mainColor),
                child: Row(
                  children: [
                    Semantics(
                      label: 'Open emoji picker',
                      child: GestureDetector(onTap: _toggleEmojiPicker, child: SvgPicture.asset('assets/svg/icons.svg')),
                    ),
                    SizedBox(width: .8.h),
                    Expanded(
                      child: TextFormField(
                        controller: messageController,
                        onChanged: (value) => messageLength.value = value,
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
                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.textFieldColor)),
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
                    SizedBox(width: .8.h),
                    Semantics(
                      label: 'Pick media',
                      child: GestureDetector(onTap: imagePickerController.pickImageOrVideo, child: SvgPicture.asset('assets/svg/camera.svg')),
                    ),
                  ],
                ),
              ),
            ),
          SizedBox(width: 1.h),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.px),
            child: Obx(
                  () => messageLength.value.trim().isEmpty && imagePickerController.pickedImage.value == null
                  ? Semantics(
                label: 'Record voice message',
                child: GestureDetector(
                  onLongPressStart: (_) => _startRecording(),
                  onLongPressEnd: (_) => !isDraggingToCancel.value ? _stopRecordingAndSend() : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.all(13.px),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isRecording.value ? Colors.red : AppColors.mainColorYellow,
                      boxShadow: [
                        BoxShadow(
                          color: (isRecording.value ? Colors.red : AppColors.mainColorYellow).withOpacity(0.3),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.mic,
                      size: 2.4.h,
                      weight: 100,
                      color: isRecording.value ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              )
                  : Semantics(
                label: 'Send message',
                child: GestureDetector(
                  onTap: _sendTextMessage,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.all(isSending.value ? 10.px : 13.px),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.mainColorYellow,
                      boxShadow: [
                        BoxShadow(color: AppColors.mainColorYellow.withOpacity(0.3), blurRadius: 5, spreadRadius: 1),
                      ],
                    ),
                    child: isSending.value
                        ? SizedBox(
                      width: 2.h,
                      height: 2.h,
                      child: const CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
                    )
                        : Icon(Icons.send, size: 2.h, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}