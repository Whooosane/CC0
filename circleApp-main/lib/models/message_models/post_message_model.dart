import 'dart:convert';

PostMessageModel postMessageModelFromJson(String str) => PostMessageModel.fromJson(json.decode(str));

String postMessageModelToJson(PostMessageModel data) => json.encode(data.toJson());

class PostMessageModel {
  String circleId;
  String message;
  List<PostMedia> media;

  PostMessageModel({
    required this.circleId,
    required this.message,
    required this.media,
  });

  factory PostMessageModel.fromJson(Map<String, dynamic> json) => PostMessageModel(
        circleId: json["circleId"],
        message: json["message"],
        media: List<PostMedia>.from(json["media"].map((x) => PostMedia.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "circleId": circleId,
        "message": message,
    "type":"text",
        "media": List<dynamic>.from(media.map((x) => x.toJson())),
      };
}

class PostMedia {
  String type;
  String url;
  String mimetype;

  PostMedia({
    required this.type,
    required this.url,
    required this.mimetype,
  });

  factory PostMedia.fromJson(Map<String, dynamic> json) => PostMedia(
        type: json["type"],
        url: json["url"],
        mimetype: json["mimetype"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "url": url,
        "mimetype": mimetype,
      };
}
