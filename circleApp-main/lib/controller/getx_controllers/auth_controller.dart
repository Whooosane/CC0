import 'dart:convert';
import 'dart:io';
import 'package:circleapp/controller/api/auth_apis.dart';
import 'package:circleapp/controller/utils/global_variables.dart';
import 'package:circleapp/controller/utils/preference_keys.dart';
import 'package:circleapp/controller/utils/shared_preferences.dart';
import 'package:circleapp/models/all_users_model.dart';
import 'package:circleapp/models/current_user_model.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final BuildContext context;

  // TextEditingControllers
  final forgotPasswordTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final userNameTextController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final phoneNumberTextController = TextEditingController();
  final otpCodeTextController = TextEditingController();
  final loginEmailTextController = TextEditingController();
  final loginPasswordTextController = TextEditingController();

  // Rx Observables
  RxBool isLoading = false.obs;
  RxBool loginLoading = false.obs;
  RxBool uploadImageLoading = false.obs;
  RxBool loading = false.obs;
  Rxn<CurrentUserModel> currentUserModel = Rxn<CurrentUserModel>();
  Rxn<AllUsersModel> allUsersModel = Rxn<AllUsersModel>();

  AuthController(this.context);

  Future<void> forgotPasswordApi(String email)
  async {
    try {
      isLoading.value = true;
      await AuthApis(context).forgotPasswordApi(email);
    } catch (e) {
      if (context.mounted) customScaffoldMessenger('Forgot password failed. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginApi(String email, String password)
  async {
    try {
      loginLoading.value = true;
      await AuthApis(context).loginApi(email, password);
    } catch (e) {
      if (context.mounted) customScaffoldMessenger('Login failed. Please try again.');
    } finally {
      loginLoading.value = false;
    }
  }

  Future<void> uploadProfilePicture({
    required File imageFile,
    required String token,
    required String userName,
  })
  async {
    try {
      uploadImageLoading.value = true;
      print('Starting uploadProfilePicture with file: ${imageFile.path}');
      String? profileImage = await AuthApis(context).uploadProfilePicture(imageFile: imageFile);
      print('Returned profileImage: $profileImage');
      var currentUserJson = MySharedPreferences.getString(currentUserKey);
      print('Current user JSON from SharedPreferences: $currentUserJson');
      currentUserModel.value = CurrentUserModel.fromJson(jsonDecode(currentUserJson));
      print('Current user model before update: ${currentUserModel.value!.data.profilePicture}');
      currentUserModel.value!.data.profilePicture = (profileImage ?? '').isNotEmpty ? profileImage! : userimagePlaceholder;
      print('Updated profilePicture: ${currentUserModel.value!.data.profilePicture}');
      MySharedPreferences.setString(currentUserKey, jsonEncode(currentUserModel.value!.toJson()));
      print('Saved to SharedPreferences: ${jsonEncode(currentUserModel.value!.toJson())}');
      currentUserModel.refresh();

      if (profileImage != null && profileImage.isNotEmpty) {
        print('Upload successful, calling editProfileController...');
        await editProfileController(
          token: token,
          userName: userName,
          profile: profileImage,
        );
        print('editProfileController completed');
      } else {
        print('No valid image URL returned, skipping editProfileController');
      }
    } catch (e) {
      print('Error during upload: $e');
      if (context.mounted) customScaffoldMessenger('Upload failed. Please try again.');
    } finally {
      uploadImageLoading.value = false;
    }
  }

  Future<void> editProfileController({
    required String token,
    required String userName,
    required String profile,
  })
  async {
    try {
      uploadImageLoading.value = true;
      print('Starting editProfileController with token: $token, userName: $userName, profile: $profile');
      await AuthApis(context).editProfileApi(token: token, profile: profile, userName: userName);
      print('editProfileApi completed successfully');
    } catch (e) {
      print('Error in editProfileController: $e');
      if (context.mounted) customScaffoldMessenger('Profile edit failed. Please try again.');
    } finally {
      uploadImageLoading.value = false;
    }
  }

  Future<void> resendOtpApi(String phoneNumber)
  async {
    try {
      loginLoading.value = true;
      await AuthApis(context).resendOtpApi(phoneNumber);
    } catch (e) {
      if (context.mounted) customScaffoldMessenger('OTP resend failed. Please try again.');
    } finally {
      loginLoading.value = false;
    }
  }

  Future<void> resetPasswordApi(String phoneNumber, String otpCode, String password)
  async {
    try {
      isLoading.value = true;
      await AuthApis(context).resetPasswordApi(phoneNumber, otpCode, password);
    } catch (e) {
      if (context.mounted) customScaffoldMessenger('Reset password failed. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signup({
    required bool load,
    required String userName,
    required String email,
    required String phoneNumber,
    required String password,
  })
  async {
    try {
      if (load) isLoading.value = true;
      await AuthApis(context).signupApi(
        userName: userName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      );
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (context.mounted) customScaffoldMessenger('Signup failed. Please try again.');
    }
  }

  Future<void> verifyOtpApi(String phoneNumber, String code)
  async {
    try {
      isLoading.value = true;
      await AuthApis(context).verifyOtpApi(phoneNumber, code);
    } catch (e) {
      if (context.mounted) customScaffoldMessenger('OTP verification failed. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCurrentUser()
  async {
    try {
      loading.value = MySharedPreferences.getString(currentUserKey).isEmpty;
      if (MySharedPreferences.getString(currentUserKey).isNotEmpty) {
        currentUserModel.value = CurrentUserModel.fromJson(jsonDecode(MySharedPreferences.getString(currentUserKey)));
      }
      currentUserModel.value = await AuthApis(context).getCurrentUser();
    } catch (e) {
      if (context.mounted) customScaffoldMessenger('Failed to fetch current user.');
    } finally {
      loading.value = false;
    }
  }

  Future<void> getAllUsers()
  async {
    try {
      loading.value = true;
      allUsersModel.value = await AuthApis(context).getAllUsers();
    } catch (e) {
      if (context.mounted) customScaffoldMessenger('Failed to fetch users.');
    } finally {
      loading.value = false;
    }
  }
}