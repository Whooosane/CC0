// To parse this JSON data, do
//
//     final todoBillModel = todoBillModelFromJson(jsonString);

import 'dart:convert';

import '../../../controller/utils/global_variables.dart';

TodoBillModel todoBillModelFromJson(String str) => TodoBillModel.fromJson(json.decode(str));

String todoBillModelToJson(TodoBillModel data) => json.encode(data.toJson());

class TodoBillModel {
  bool success;
  String message;
  BillDetails billDetails;

  TodoBillModel({
    required this.success,
    required this.message,
    required this.billDetails,
  });

  TodoBillModel copyWith({
    bool? success,
    String? message,
    BillDetails? billDetails,
  }) =>
      TodoBillModel(
        success: success ?? this.success,
        message: message ?? this.message,
        billDetails: billDetails ?? this.billDetails,
      );

  factory TodoBillModel.fromJson(Map<String, dynamic> json) => TodoBillModel(
    success: json["success"],
    message: json["message"],
    billDetails: BillDetails.fromJson(json["billDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "billDetails": billDetails.toJson(),
  };
}

class BillDetails {
  double totalBillAmount;
  double totalPaid;
  double totalPending;
  double payablePerUser;
  double totalMembers;
  List<AllMember> allMembers;
  List<AllMember> pendingUsers;
  List<AllMember> paidUsers;
  List<String> billReceiptImages;
  String description;

  BillDetails({
    required this.totalBillAmount,
    required this.totalPaid,
    required this.totalPending,
    required this.payablePerUser,
    required this.totalMembers,
    required this.allMembers,
    required this.pendingUsers,
    required this.paidUsers,
    required this.billReceiptImages,
    required this.description,
  });

  BillDetails copyWith({
    double? totalBillAmount,
    double? totalPaid,
    double? totalPending,
    double? payablePerUser,
    double? totalMembers,
    List<AllMember>? allMembers,
    List<AllMember>? pendingUsers,
    List<AllMember>? paidUsers,
    List<String>? billReceiptImages,
    String? description,
  }) =>
      BillDetails(
        totalBillAmount: totalBillAmount ?? this.totalBillAmount,
        totalPaid: totalPaid ?? this.totalPaid,
        totalPending: totalPending ?? this.totalPending,
        payablePerUser: payablePerUser ?? this.payablePerUser,
        totalMembers: totalMembers ?? this.totalMembers,
        allMembers: allMembers ?? this.allMembers,
        pendingUsers: pendingUsers ?? this.pendingUsers,
        paidUsers: paidUsers ?? this.paidUsers,
        billReceiptImages: billReceiptImages ?? this.billReceiptImages,
        description: description ?? this.description,
      );

  factory BillDetails.fromJson(Map<String, dynamic> json) => BillDetails(
    totalBillAmount: _roundToTwoDecimals(json["totalBillAmount"]?.toDouble()),
    totalPaid: _roundToTwoDecimals(json["totalPaid"]?.toDouble()),
    totalPending: _roundToTwoDecimals(json["totalPending"]?.toDouble()),
    payablePerUser: _roundToTwoDecimals(json["payablePerUser"]?.toDouble()),
    totalMembers: _roundToTwoDecimals(json["totalMembers"]?.toDouble()),
    allMembers: List<AllMember>.from(json["allMembers"].map((x) => AllMember.fromJson(x))),
    pendingUsers: List<AllMember>.from(json["pendingUsers"].map((x) => AllMember.fromJson(x))),
    paidUsers: List<AllMember>.from(json["paidUsers"].map((x) => AllMember.fromJson(x))),
    billReceiptImages: List<String>.from(json["billReceiptImages"].map((x) => x)),
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "totalBillAmount": _roundToTwoDecimals(totalBillAmount),
    "totalPaid": _roundToTwoDecimals(totalPaid),
    "totalPending": _roundToTwoDecimals(totalPending),
    "payablePerUser": _roundToTwoDecimals(payablePerUser),
    "totalMembers": _roundToTwoDecimals(totalMembers),
    "allMembers": List<dynamic>.from(allMembers.map((x) => x.toJson())),
    "pendingUsers": List<dynamic>.from(pendingUsers.map((x) => x)),
    "paidUsers": List<dynamic>.from(paidUsers.map((x) => x.toJson())),
    "billReceiptImages": List<dynamic>.from(billReceiptImages.map((x) => x)),
    "description": description,
  };

  static double _roundToTwoDecimals(double? value) {
    return value != null ? double.parse(value.toStringAsFixed(2)) : 0.0;
  }
}


class AllMember {
  String memberId;
  String name;
  String profilePicture;

  AllMember({
    required this.memberId,
    required this.name,
    required this.profilePicture,
  });

  AllMember copyWith({
    String? memberId,
    String? name,
    String? profilePicture,
  }) =>
      AllMember(
        memberId: memberId ?? this.memberId,
        name: name ?? this.name,
        profilePicture: profilePicture ?? this.profilePicture,
      );

  factory AllMember.fromJson(Map<String, dynamic> json) => AllMember(
    memberId: json["memberId"],
    name: json["name"],
    profilePicture: json["profilePicture"] ?? userimagePlaceholder,
  );

  Map<String, dynamic> toJson() => {
    "memberId": memberId,
    "name": name,
    "profilePicture": profilePicture,
  };
}
