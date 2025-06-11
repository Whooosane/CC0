import 'dart:convert';

OffersModel offersModelFromJson(String str) => OffersModel.fromJson(json.decode(str));

String offersModelToJson(OffersModel data) => json.encode(data.toJson());

class OffersModel {
  bool status;
  String message;
  List<Offer> offers;

  OffersModel({
    required this.status,
    required this.message,
    required this.offers,
  });

  OffersModel copyWith({
    bool? status,
    String? message,
    List<Offer>? offers,
  }) =>
      OffersModel(
        status: status ?? this.status,
        message: message ?? this.message,
        offers: offers ?? this.offers,
      );

  factory OffersModel.fromJson(Map<String, dynamic> json) => OffersModel(
    status: json["status"],
    message: json["message"],
    offers: List<Offer>.from(json["offers"].map((x) => Offer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "offers": List<dynamic>.from(offers.map((x) => x.toJson())),
  };
}

class Offer {
  String id;
  String title;
  String description;
  int numberOfPeople;
  DateTime startingDate;
  DateTime endingDate;
  String interest;
  int price;
  List<String> imageUrls;
  bool active;
  List<dynamic> buyers;
  DateTime createdAt;
  int v;

  Offer({
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
    required this.buyers,
    required this.createdAt,
    required this.v,
  });

  Offer copyWith({
    String? id,
    String? title,
    String? description,
    int? numberOfPeople,
    DateTime? startingDate,
    DateTime? endingDate,
    String? interest,
    int? price,
    List<String>? imageUrls,
    bool? active,
    List<dynamic>? buyers,
    DateTime? createdAt,
    int? v,
  }) =>
      Offer(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        numberOfPeople: numberOfPeople ?? this.numberOfPeople,
        startingDate: startingDate ?? this.startingDate,
        endingDate: endingDate ?? this.endingDate,
        interest: interest ?? this.interest,
        price: price ?? this.price,
        imageUrls: imageUrls ?? this.imageUrls,
        active: active ?? this.active,
        buyers: buyers ?? this.buyers,
        createdAt: createdAt ?? this.createdAt,
        v: v ?? this.v,
      );

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
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
    buyers: List<dynamic>.from(json["buyers"].map((x) => x)),
    createdAt: DateTime.parse(json["createdAt"]),
    v: json["__v"],
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
    "buyers": List<dynamic>.from(buyers.map((x) => x)),
    "createdAt": createdAt.toIso8601String(),
    "__v": v,
  };
}
