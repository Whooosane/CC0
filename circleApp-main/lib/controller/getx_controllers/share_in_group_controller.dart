import 'dart:developer';
import 'package:circleapp/controller/api/share_in_group_apis.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:get/get.dart';
class ShareInGroupController extends GetxController{
  ///Share In Group Controller
  RxBool shareLoading=false.obs;
  Future<void>shareInGroupController(  {required List<String> circleIds,
    required String itineraryId,
    required String type,
    required String token,
    required String itemIdKey,
  })
  async{
    try{
      shareLoading.value=true;
      await ShareInGroupApi().shareInGroupApiMethod(
          circleIds: circleIds,
          itemId: itineraryId,
          type: type,
          token: token,
          itemIdKey: itemIdKey);
      shareLoading.value=false;
    }catch(e){
      log("Share In Group Api Error :$e");
      customScaffoldMessenger("Share In Group Api Error :$e");
    }
}
}