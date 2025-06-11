import 'dart:io';

class AddBillsModel {
  String title;
  String billAmount;
  List<File?> todoImages;

  AddBillsModel({
    required this.title,
    required this.billAmount,
    required this.todoImages,
  });

  void addImage(File image) {
    todoImages.add(image);
  }

  bool isValid() {
    return title.isNotEmpty && billAmount.isNotEmpty && todoImages.isNotEmpty;
  }
}
