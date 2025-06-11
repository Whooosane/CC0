import 'package:get/get.dart';

class Validations {
  static String handleSingUpScreenError({
    userNameTextController,
    emailTextController,
    passwordTextController,
    mobileNumberTextController,
    // confirmPasswordTextController,
  }) {
    if (userNameTextController.text.isEmpty) {
      return "Username not be empty.".tr;
    } else if (emailTextController.text.isEmpty) {
      return "Email not be empty.".tr;
    } else if (passwordTextController.text.isEmpty) {
      return "Password not be empty.".tr;
    } else if (mobileNumberTextController.text.isEmpty) {
      return "Phone number is not be empty".tr;
    }
    // else if (confirmPasswordTextController.text.isEmpty) {
    //   return "Confirm Password not be empty.".tr;
    // }
    else if (!isValidEmail.hasMatch(emailTextController.text)) {
      return "Please check your email.".tr;
    } else if (passwordTextController.text.length < 8) {
      return "Password must be at least 8 characters in length.".tr;
    }
    // else if (confirmPasswordTextController.text.length < 8) {
    //   return "Confirm password must be at least 8 characters in length.".tr;
    // }
    else if (!isValidPassword.hasMatch(passwordTextController.text)) {
      return "Password should contain at least one upper case, lower case, one digit, Special character.".tr;
    }
    // else if (!isValidPassword.hasMatch(confirmPasswordTextController.text)) {
    //   return "Confirm password should contain at least one upper case, lower case, one digit, Special character."
    //       .tr;
    // } else if (confirmPasswordTextController.text !=
    //         passwordTextController.text ||
    //     passwordTextController.text != confirmPasswordTextController.text) {
    //   return "Passwords do not match.".tr;
    // }
    else {
      return '';
    }
  }

  static String handleLoginScreenError({
    emailTextController,
    passwordTextController,
  }) {
    if (emailTextController.text.isEmpty) {
      return "Email not be empty.".tr;
    } else if (passwordTextController.text.isEmpty) {
      return "Password not be empty.".tr;
    } else if (!isValidEmail.hasMatch(emailTextController.text)) {
      return "Please check your email.".tr;
    } else if (passwordTextController.text.length < 8) {
      return "Password must be at least 8 characters in length.".tr;
    }
    // else if (!isValidPassword.hasMatch(passwordTextController.text)) {
    //   return "Password should contain at least one upper case, lower case, one digit, Special character."
    //       .tr;
    // }
    else {
      return '';
    }
  }

  static String handleForgotPasswordEmailScreenError({
    emailTextController,
  }) {
    if (emailTextController.text.isEmpty) {
      return "Email not be empty.".tr;
    } else if (!isValidEmail.hasMatch(emailTextController.text)) {
      return "Please check your email.".tr;
    } else {
      return '';
    }
  }

  static String handleForgotPasswordOTPScreenError({
    otpTextController,
  }) {
    if (otpTextController.text.isEmpty) {
      return "OTP not be empty.".tr;
    } else {
      return '';
    }
  }

  static String handleForgotPasswordChangePasswordScreenError({
    passwordTextController,
    confirmPasswordTextController,
  }) {
    if (passwordTextController.text.isEmpty) {
      return "Password not be empty.".tr;
    } else if (confirmPasswordTextController.text.isEmpty) {
      return "Confirm Password not be empty.".tr;
    } else if (passwordTextController.text.length < 8) {
      return "Password must be at least 8 characters in length.".tr;
    } else if (confirmPasswordTextController.text.length < 8) {
      return "Confirm password must be at least 8 characters in length.".tr;
    } else if (!isValidPassword.hasMatch(passwordTextController.text)) {
      return "Password should contain at least one upper case, lower case, one digit, Special character.".tr;
    } else if (!isValidPassword.hasMatch(confirmPasswordTextController.text)) {
      return "Confirm password should contain at least one upper case, lower case, one digit, Special character.".tr;
    } else if (confirmPasswordTextController.text != passwordTextController.text ||
        passwordTextController.text != confirmPasswordTextController.text) {
      return "Passwords do not match.".tr;
    } else {
      return '';
    }
  }

  static String handleEditProfileScreenError({
    fullNameTextController,
    initialsTextController,
  }) {
    if (fullNameTextController.text.isEmpty) {
      return "Full name not be empty.".tr;
    } else if (initialsTextController.text.isEmpty) {
      return "Initials not be empty.".tr;
    } else {
      return '';
    }
  }

  static String handleChangePasswordScreenError({
    currentPasswordTextController,
    newPasswordTextController,
    confirmPasswordTextController,
  }) {
    // if (currentPasswordTextController.text.isEmpty) {
    //   return "Current Password not be empty.".tr;
    // }
    if (newPasswordTextController.text.isEmpty) {
      return "New Password not be empty.".tr;
    } else if (confirmPasswordTextController.text.isEmpty) {
      return "Confirm Password not be empty.".tr;
    }
    // else if (currentPasswordTextController.text.length < 8) {
    //   return "Current Password must be at least 8 characters in length.".tr;
    // }
    else if (newPasswordTextController.text.length < 8) {
      return "New Password must be at least 8 characters in length.".tr;
    } else if (confirmPasswordTextController.text.length < 8) {
      return "Confirm password must be at least 8 characters in length.".tr;
    }
    // else if (!isValidPassword.hasMatch(currentPasswordTextController.text)) {
    //   return "Current Password should contain at least one upper case, lower case, one digit, Special character."
    //       .tr;
    // }
    else if (!isValidPassword.hasMatch(newPasswordTextController.text)) {
      return "New Password should contain at least one upper case, lower case, one digit, Special character.".tr;
    } else if (!isValidPassword.hasMatch(confirmPasswordTextController.text)) {
      return "Confirm password should contain at least one upper case, lower case, one digit, Special character.".tr;
    } else if (confirmPasswordTextController.text != newPasswordTextController.text ||
        newPasswordTextController.text != confirmPasswordTextController.text) {
      return "Passwords do not match.".tr;
    } else {
      return '';
    }
  }

  static String handleAddMemberScreenError({
    firstNameTextController,
    lastNameTextController,
    initialsTextController,
    selectedColor,
  }) {
    if (firstNameTextController.text.isEmpty) {
      return "First name not be empty.".tr;
    } else if (lastNameTextController.text.isEmpty) {
      return "Last name not be empty.".tr;
    } else if (initialsTextController.text.isEmpty) {
      return "Initials not be empty.".tr;
    } else if (initialsTextController.text.length < 3) {
      return "Please enter 3 character initials.".tr;
    } else {
      return '';
    }
  }

  static String handleResetPasswordScreenError({
    password,
    confirmPassword,
    email,
    otp,
  }) {
    if (otp.text.isEmpty) {
      return "Otp can not be empty".tr;
    } else if (password.text.isEmpty) {
      return "password can not not be empty".tr;
    } else if (confirmPassword.text.isEmpty) {
      return "confirm password is not be empty".tr;
    } else if (password.text.length < 8) {
      return "password is not be less then 8".tr;
    } else if (confirmPassword.text.length < 8) {
      return "password is not be less then 8".tr;
    } else if (password.text != confirmPassword.text || confirmPassword.text != password.text) {
      return "password do not match please try again".tr;
    } else {
      return '';
    }
  }
}

RegExp isValidEmail = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

RegExp isValidPassword = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
