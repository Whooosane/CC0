import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:circleapp/controller/utils/api_constants.dart';
import 'package:circleapp/controller/utils/global_variables.dart';
import 'package:circleapp/controller/utils/preference_keys.dart';
import 'package:circleapp/controller/utils/shared_preferences.dart';
import 'package:circleapp/models/all_users_model.dart';
import 'package:circleapp/models/current_user_model.dart';
import 'package:circleapp/view/check_invitation.dart';
import 'package:circleapp/view/custom_widget/customwidgets.dart';
import 'package:circleapp/view/screens/athentications/login_screen.dart';
import 'package:circleapp/view/screens/athentications/resetpassword_screen.dart';
import 'package:circleapp/view/screens/athentications/verIfymobilescreen.dart';
import 'package:circleapp/view/screens/bottom_navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, MultipartFile;
import 'package:http/http.dart' as http;

class AuthApis {
  final BuildContext context;
  AuthApis(this.context);

  Future<void> signupApi({
    required String userName,
    required String email,
    required String password,
    required String phoneNumber,
  })
  async {
    final response = await http.post(
      Uri.parse('$baseURL/$signUpEP'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': userName,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
      }),
    );
    if (response.statusCode == 201) {
      log("Response is that :${response.body}");
      log("Response is that :${response.statusCode}");
      Get.to(() => VerifyMobileScreen(),
          arguments: {'phoneNumber': phoneNumber});
    } else if (context.mounted) {
      log("Response is that :${response.body}");
      log("Response is that :${response.statusCode}");
      customScaffoldMessenger(
          jsonDecode(response.body)['error'] ?? 'Signup failed');
    }
  }

  Future<void> loginApi(String email, String password)
  async {
    final response = await http.post(
      Uri.parse('$baseURL/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      MySharedPreferences.setBool(isLoggedInKey, true);
      MySharedPreferences.setString(userTokenKey, data['token']);
      Get.offAll(() => const BottomNavigationScreen());
      customScaffoldMessenger(data["message"]);
    } else if (context.mounted) {
      customScaffoldMessenger(
          jsonDecode(response.body)['error'] ?? 'Login failed');
    }
  }

  Future<void> resendOtpApi(String phoneNumber)
  async {
    final response = await http.post(
      Uri.parse('$baseURL/api/auth/resend-code'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneNumber': phoneNumber}),
    );
    if (response.statusCode == 200) {
      customScaffoldMessenger('Verification code sent successfully');
    } else if (context.mounted) {
      customScaffoldMessenger(
          jsonDecode(response.body)['error'] ?? 'Failed to resend OTP');
    }
  }

  Future<void> verifyOtpApi(String phoneNumber, String code)
  async {
    final response = await http.post(
      Uri.parse('$baseURL/api/auth/verify'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneNumber': phoneNumber, 'code': code}),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success']) {
      userToken = data['token'];
      MySharedPreferences.setBool(isSignedUpKey, true);
      MySharedPreferences.setString(userTokenKey, data['token']);
      Get.offAll(() => const CheckInvitationScreen());
      customScaffoldMessenger(data['message']);
    } else if (context.mounted) {
      customScaffoldMessenger(data['message'] ?? 'OTP verification failed');
    }
  }

  Future<void> forgotPasswordApi(String phoneNumber)
  async {
    final response = await http.post(
      Uri.parse('$baseURL/api/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneNumber': phoneNumber}),
    );
    if (response.statusCode == 200) {
      customScaffoldMessenger('Verification code sent successfully');
      Get.off(() => const ResetPasswordScreen(),
          arguments: {'phoneNumber': phoneNumber});
    } else if (context.mounted) {
      customScaffoldMessenger(
          jsonDecode(response.body)['error'] ?? 'Failed to resend OTP');
    }
  }

  Future<void> resetPasswordApi(
      String phoneNumber, String otpCode, String password)
  async {
    final response = await http.post(
      Uri.parse('$baseURL/api/auth/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'phoneNumber': phoneNumber, 'code': otpCode, 'password': password}),
    );
    if (response.statusCode == 200) {
      customScaffoldMessenger('Password reset successfully');
      Get.offAll(() => const LoginScreen());
    } else if (context.mounted) {
      customScaffoldMessenger(
          jsonDecode(response.body)['error'] ?? 'Failed to reset password');
    }
  }

  Future<String?> uploadProfilePicture({
    required File imageFile,
  })
  async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseURL/$uploadImagesEp'),
    )
      ..headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $userToken',
      })
      ..files.add(await http.MultipartFile.fromPath('images', imageFile.path));
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);
      log('Parsed response data: $data');
      final imageUrls = data['imageUrls'] as List<dynamic>?;
      return imageUrls != null && imageUrls.isNotEmpty ? imageUrls.first as String : null;
    } else {
      log('Upload failed with status: ${response.statusCode}');
    }
    return null;
  }

  Future<void> editProfileApi({
    required String token,
    required String userName,
    required String profile,
  }) async {
    final response = await http.put(
      Uri.parse('$baseURL/$editProfileEP'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({
        'name': userName,
        'profilePicture': profile,
      }),
    );
    if (response.statusCode == 200) {
      log("edit user profile: ${response.body}");
      Map<String, dynamic> decodedBody = jsonDecode(response.body);
      customScaffoldMessenger(decodedBody["message"]);
    } else if (context.mounted) {
      Map<String, dynamic> decodedBody = jsonDecode(response.body);
      customScaffoldMessenger(decodedBody["message"] ?? 'Profile edit failed');
    }
  }

  Future<CurrentUserModel?> getCurrentUser()
  async {
    final response = await http.get(
      Uri.parse('$baseURL/$getCurrentUserEP'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken',
      },
    );
    if (response.statusCode == 200) {
      log("get Current user response body:${response.body}");
      MySharedPreferences.setString(currentUserKey, response.body);
      MySharedPreferences.setString(currentUserIdKey,
          CurrentUserModel.fromJson(jsonDecode(response.body)).data.id);
      return CurrentUserModel.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<AllUsersModel?> getAllUsers()
  async {
    final response = await http.get(
      Uri.parse('$baseURL/$getAllUsersEP'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken',
      },
    );
    if (response.statusCode == 200) {
      return AllUsersModel.fromJson(jsonDecode(response.body));
    }
    return null;
  }
}
