import 'dart:io';
import 'package:circleapp/controller/api/stories_apis.dart';
import 'package:circleapp/controller/api/upload_apis.dart';
import 'package:circleapp/controller/utils/media_enum.dart';
import 'package:circleapp/models/stories_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class StoryController extends GetxController {
  late final BuildContext context;

  StoryController(this.context);

  ///Variables
  RxBool loading = false.obs;
  Rxn<StoriesModel?> storiesModel = Rxn<StoriesModel>();

  ///Upload Stories Controller
  Future<void> uploadStory({
    required bool load,
    required String circleId,
    required String storyText,
    required File file,
    required MediaType mediaType,
  })
  async {
    if (load) {
      loading.value = true;
    }

    List<String>? mediaUrl = await UploadApis(context).uploadFile(file);
    if (mediaUrl != null) {
      if (mediaUrl.first.isNotEmpty) {
        await StoriesApis(context).uploadStory(circleId: circleId, mediaType: mediaType.toString(), text: storyText, mediaUrl: mediaUrl.first);
      }
    }

    loading.value = false;
  }

  ///Get Stories Controller
  Future<void> getStories({required bool load, required String circleId})
  async {
    if (load) {
      loading.value = true;
    }

    storiesModel.value = await StoriesApis(context).getStories(circleId: circleId);
    loading.value = false;
  }
}
