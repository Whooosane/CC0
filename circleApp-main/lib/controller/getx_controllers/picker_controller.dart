import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PickerController extends GetxController {
  // Date picker
  DateTime currentDate = DateTime.now();
  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<String> formatedDate = DateFormat("yyyy-MM-dd").format(DateTime.now()).obs;

  // Date Picker
  Future<DateTime?> selectDate(BuildContext context, DateTime initialDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1990),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month + 6, DateTime.now().day),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      formatedDate.value = DateFormat("yyyy-MM-dd").format(picked);
    }
    return picked;
  }

  // Time picker
  Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;
  Rx<String> formatedTime = TimeOfDay.now().format(Get.context!).obs;

  // Time Picker
  Future<TimeOfDay?> selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value,
    );
    if (picked != null && picked != selectedTime.value) {
      selectedTime.value = picked;
      formatedTime.value = picked.format(context);
    }
    return picked;
  }

  // Image picker
  final ImagePicker picker = ImagePicker();
  Rx<XFile?> pickedImage = Rx<XFile?>(null);

  Future<File?> pickImage() async {
    final selectedImage = await picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      pickedImage.value = selectedImage;
      return File(selectedImage.path);
    }
    return null;
  }

  Future<File?> pickImageWithFile(Rx<File?> file) async {
    final selectedImage = await picker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      file.value = File(selectedImage.path);
      return file.value;
    }
    return null;
  }

  Future<File?> pickImageOrVideo() async {
    final selectedImage = await picker.pickMedia();
    if (selectedImage != null) {
      pickedImage.value = selectedImage;
      return File(selectedImage.path);
    }
    return null;
  }

  Future<File?> pickImageFromCamera() async {
    final selectedImage = await picker.pickImage(source: ImageSource.camera);
    if (selectedImage != null) {
      pickedImage.value = selectedImage;
      return File(selectedImage.path);
    }
    return null;
  }
}