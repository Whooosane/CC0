
import 'dart:convert';
GetExperienceModel getExperienceModelFromJson(String str) => GetExperienceModel.fromJson(json.decode(str));
String getExperienceModelToJson(GetExperienceModel data) => json.encode(data.toJson());
class GetExperienceModel {
  final bool success;
  final String message;
  final Data data;

  GetExperienceModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetExperienceModel.fromJson(Map<String, dynamic> json) => GetExperienceModel(
    success: json["success"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}
class Data {
  final List<EdOffer> bookedOffers;
  final List<EdOffer> savedOffers;

  Data({
    required this.bookedOffers,
    required this.savedOffers,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    bookedOffers: List<EdOffer>.from(json["bookedOffers"].map((x) => EdOffer.fromJson(x))),
    savedOffers: List<EdOffer>.from(json["savedOffers"].map((x) => EdOffer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "bookedOffers": List<dynamic>.from(bookedOffers.map((x) => x.toJson())),
    "savedOffers": List<dynamic>.from(savedOffers.map((x) => x.toJson())),
  };
}
class EdOffer {
  final String id;
  final String title;
  final String description;
  final int numberOfPeople;
  final DateTime startingDate;
  final DateTime endingDate;
  final String interest;
  final int price;
  final List<String> imageUrls;
  final bool active;
  final DateTime createdAt;

  EdOffer({
    required this.id,
    required this.title,
    required this.description,
    required this.numberOfPeople,
    required this.startingDate,
    required this.endingDate,
    required this.interest,
    required this.price,
    required this.imageUrls,
    required this.active,
    required this.createdAt,
  });

  factory EdOffer.fromJson(Map<String, dynamic> json) => EdOffer(
    id: json["_id"],
    title: json["title"],
    description: json["description"],
    numberOfPeople: json["numberOfPeople"],
    startingDate: DateTime.parse(json["startingDate"]),
    endingDate: DateTime.parse(json["endingDate"]),
    interest: json["interest"],
    price: json["price"],
    imageUrls: List<String>.from(json["imageUrls"].map((x) => x)),
    active: json["active"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "description": description,
    "numberOfPeople": numberOfPeople,
    "startingDate": startingDate.toIso8601String(),
    "endingDate": endingDate.toIso8601String(),
    "interest": interest,
    "price": price,
    "imageUrls": List<dynamic>.from(imageUrls.map((x) => x)),
    "active": active,
    "createdAt": createdAt.toIso8601String(),
  };
}
