import 'dart:convert';

List<ItineraryModel> itineraryModelFromJson(String str) => List<ItineraryModel>.from(json.decode(str).map((x) => ItineraryModel.fromJson(x)));

String itineraryModelToJson(List<ItineraryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItineraryModel {
  String id;
  String name;
  String about;
  DateTime date;
  String time;
  int v;

  ItineraryModel({
    required this.id,
    required this.name,
    required this.about,
    required this.date,
    required this.time,
    required this.v,
  });

  factory ItineraryModel.fromJson(Map<String, dynamic> json) => ItineraryModel(
    id: json["_id"],
    name: json["name"],
    about: json["about"],
    date: DateTime.parse(json["date"]),
    time: json["time"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "about": about,
    "date": date.toIso8601String(),
    "time": time,
    "__v": v,
  };
}
