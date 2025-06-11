import 'package:get/get.dart';

import '../../models/is_user_model.dart';
import '../api/user_services.dart';

class AddMemberController extends GetxController {
  RxList<IsUserModel> isUsers = <IsUserModel>[].obs;
  RxBool isLoading = false.obs;

  Future checkUsers() async {
    isLoading.value = true;
    await ApisServices().getApiData('/api/auth/check-users').then((value) {
      if (value != null) {
        isUsers.value = isUserModelFromJson(value);
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    });
  }
}
