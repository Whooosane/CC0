import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:circleapp/controller/api/messenger_apis.dart';
import 'package:circleapp/controller/api/upload_apis.dart';
import 'package:circleapp/controller/getx_controllers/chat_socket_controller.dart';
import 'package:circleapp/controller/getx_controllers/convos_controller.dart';
import 'package:circleapp/controller/utils/preference_keys.dart';
import 'package:circleapp/controller/utils/shared_preferences.dart';
import 'package:circleapp/models/conversation_model.dart';
import 'package:circleapp/models/current_user_model.dart';
import 'package:circleapp/models/message_models/get_message_model.dart';
import 'package:circleapp/models/message_models/post_message_model.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'dart:developer';
import '../../models/message_models/get_message_model.dart' as CompleteDatum;
class MessengerController extends GetxController {
  late final BuildContext context;
  late final ConvosController convosController;
  MessengerController(this.context) {
    convosController = Get.put(ConvosController(context));
  }

  /// Variables
  RxBool loading = false.obs;
  Rxn<ConversationModel> conversationModel = Rxn<ConversationModel>();
  Rxn<GetMessageModel?> messagesModel = Rxn<GetMessageModel>();
  TextEditingController circleNameTextController = TextEditingController();
  TextEditingController circleDescriptionTextController =
      TextEditingController();
  CurrentUserModel currentUserModel = CurrentUserModel.fromJson(
      jsonDecode(MySharedPreferences.getString(currentUserKey)));
  final AudioPlayer _audioPlayer = AudioPlayer();
  Rx<Duration> duration = const Duration(seconds: 0).obs;
  Rx<Duration> position = const Duration(seconds: 0).obs;
  Rx<bool> isPlaying = false.obs;
  Rx<double> progress = 0.0.obs;
  RxInt currentPlayingIndex = (-1).obs; // Changed to index (int)
  final RxMap<String, VideoPlayerController> _videoControllerCache =
      <String, VideoPlayerController>{}.obs;
  RxList<int> unreadCount = <int>[].obs;
  AudioPlayer get audioPlayer => _audioPlayer;

  /// Audio Playback Methods
  Future<void> playAudio(String url, int index)
  async {
    try {
      if (currentPlayingIndex.value == index && isPlaying.value) {
        await _audioPlayer.pause();
        isPlaying.value = false;
        return;
      }

      // Clear previous audio state
      await _audioPlayer.stop();
      await _audioPlayer.release();
      position.value = Duration.zero;
      progress.value = 0.0;
      duration.value = Duration.zero;
      currentPlayingIndex.value = index;

      await _audioPlayer.play(UrlSource(url));
      isPlaying.value = true;

      _audioPlayer.onDurationChanged.listen((d) {
        duration.value = d;
      });
      _audioPlayer.onPositionChanged.listen((p) {
        position.value = p;
        progress.value = p.inMilliseconds.toDouble();
      });
      _audioPlayer.onPlayerStateChanged.listen((state) {
        if (state == PlayerState.completed) {
          isPlaying.value = false;
          currentPlayingIndex.value = -1;
          position.value = Duration.zero;
          progress.value = 0.0;
        }
      });
    } catch (e) {
      log('Audio playback error: $e');
      customScaffoldMessenger('Failed to play audio.');
      isPlaying.value = false;
      currentPlayingIndex.value = -1;
    }
  }

  ///Seek Audio
  Future<void> seekAudio(Duration pos)
  async {
    try {
      await _audioPlayer.seek(pos);
      position.value = pos;
      progress.value = pos.inMilliseconds.toDouble();
    } catch (e) {
      log('Audio seek error: $e');
    }
  }

  /// Video Controller Caching
  Future<VideoPlayerController> getVideoController(String url)
  async {
    if (_videoControllerCache.containsKey(url)) {
      return _videoControllerCache[url]!;
    }
    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    await controller.initialize();
    await controller.pause();
    _videoControllerCache[url] = controller;
    return controller;
  }

  ///Clear Video Cache
  void clearVideoCache() {
    for (var controller in _videoControllerCache.values) {
      controller.dispose();
    }
    _videoControllerCache.clear();
  }

  ///Send Message Controller Methods
  Future<void> sendMessage({
    required bool load,
    required PostMessageModel postMessageModel,
    required String token,
    required RxList<String> messagesId,
    bool isPinned = false,
  })
  async {
    if (load) {
      loading.value = true;
    }
    bool isSent = await MessengerApis(context)
        .sendMessage(postMessageModel: postMessageModel);

    if (isSent) {
      final message = CompleteDatum.MessageData(
        id: "",
        senderId: currentUserModel.data.id,
        text: postMessageModel.message,
        senderName: currentUserModel.data.name,
        senderProfilePicture: currentUserModel.data.profilePicture,
        sentAt: DateTime.now().toString(),
        media: postMessageModel.media
            .map((media) => CompleteDatum.Media(
                  type: media.type,
                  url: media.url,
                  mimetype: media.mimetype,
                ))
            .toList(),
        pinned: isPinned,
        type: "text",
      );
      Get.put(ChatSocketService()).sendMessage(
        postMessageModel.circleId,
        message,
      );
      messagesModel.value?.data.add(message);
      messagesModel.refresh();

      if (isPinned) {
        await convosController.addToConvos(
            circleId: postMessageModel.circleId,
            token: token,
            messageIds: messagesId);
      }
    } else {
      customScaffoldMessenger("Failed to Send");
    }
    loading.value = false;
  }

  ///Upload File Controller Method
  Future<String?> uploadFile({required bool load, required File file})
  async {
    if (load) {
      loading.value = true;
    }

    List<String>? response = await UploadApis(context).uploadFile(file);
    loading.value = false;
    if (response != null) {
      print("response :${response.first}");
      return response.first;
    } else {
      return null;
    }
  }

  ///Get Message Controller Method
  Future<void> getMessages({
    required bool load,
    required String circleId,
  }) async {
    try {
      loading.value = load;
      log("Circle Id is that $circleId");
      final result = await MessengerApis(context).getMessages(circleId: circleId);
      log("Result is that :$result");
      messagesModel.value = result ??
          GetMessageModel(
            success: false,
            data: [],
            circleId: circleId,
          );
      log("messagesModel.value :${messagesModel.value?.data.length} messages");
      loading.value = false;
    } catch (e) {
      loading.value = false;
      messagesModel.value = GetMessageModel(
        success: false,
        data: [],
        circleId: circleId,
      );
      log("Get Message Api Error :${e.toString()}");
    }
  }

  ///Get Conversation Controller Method
  Future<void> getConversations({required bool load})
  async {
    if (load) {
      loading.value = true;
    }

    conversationModel.value = await MessengerApis(context).getConversations();
    loading.value = false;
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    clearVideoCache();
    circleNameTextController.dispose();
    circleDescriptionTextController.dispose();
    super.onClose();
  }
}
