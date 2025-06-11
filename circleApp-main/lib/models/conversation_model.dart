import 'dart:convert';
import 'package:get/get.dart';

ConversationModel conversationModelFromJson(String str) => ConversationModel.fromJson(json.decode(str));

String conversationModelToJson(ConversationModel data) => json.encode(data.toJson());

class ConversationModel {
  bool success;
  RxList<Datum> data; // Change List<Datum> to RxList<Datum>

  ConversationModel({
    required this.success,
    required List<Datum> data, // Accept a List<Datum>
  }) : data = RxList<Datum>(data); // Initialize as RxList<Datum>

  factory ConversationModel.fromJson(Map<String, dynamic> json) => ConversationModel(
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String circleId;
  String circleName;
  String circleImage;
  LatestMessage latestMessage;
  int unreadCount; // Add this line

  Datum({
    required this.circleId,
    required this.circleName,
    required this.circleImage,
    required this.latestMessage,
    this.unreadCount = 0, // Initialize to 0 by default
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    circleId: json["circleId"],
    circleName: json["circleName"],
    circleImage: json["circleImage"],
    latestMessage: json["latestMessage"] == null
        ? LatestMessage(senderId: "", senderName: "", senderProfilePicture: "", text: "", sentAt: DateTime.now().toString())
        : LatestMessage.fromJson(json["latestMessage"]),
    unreadCount: json["unreadCount"] ?? 0, // Deserialize unread count
  );

  Map<String, dynamic> toJson() => {
    "circleId": circleId,
    "circleName": circleName,
    "circleImage": circleImage,
    "latestMessage": latestMessage.toJson(),
    "unreadCount": unreadCount, // Serialize unread count
  };
}

class LatestMessage {
  String senderId;
  String senderName;
  String senderProfilePicture;
  String text;
  String sentAt;

  LatestMessage({
    required this.senderId,
    required this.senderName,
    required this.senderProfilePicture,
    required this.text,
    required this.sentAt,
  });

  factory LatestMessage.fromJson(Map<String, dynamic> json) => LatestMessage(
    senderId: json["senderId"],
    senderName: json["senderName"],
    senderProfilePicture: json["senderProfilePicture"] ?? "",
    text: json["text"],
    sentAt: DateTime.parse(json["sentAt"]).toString(),
  );

  Map<String, dynamic> toJson() => {
    "senderId": senderId,
    "senderName": senderName,
    "senderProfilePicture": senderProfilePicture,
    "text": text,
    "sentAt": sentAt,
  };
}
