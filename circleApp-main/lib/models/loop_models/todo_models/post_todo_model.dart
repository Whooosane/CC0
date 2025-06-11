import 'dart:convert';

PostTodoModel postTodoModelFromJson(String str) => PostTodoModel.fromJson(json.decode(str));

String postTodoModelToJson(PostTodoModel data) => json.encode(data.toJson());

class PostTodoModel {
  String message;
  Todo todo;

  PostTodoModel({
    required this.message,
    required this.todo,
  });

  factory PostTodoModel.fromJson(Map<String, dynamic> json) => PostTodoModel(
    message: json["message"],
    todo: Todo.fromJson(json["todo"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "todo": todo.toJson(),
  };
}

class Todo {
  String title;
  String description;
  List<String> images;
  Bill bill;
  String id;
  int v;

  Todo({
    required this.title,
    required this.description,
    required this.images,
    required this.bill,
    required this.id,
    required this.v,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    title: json["title"],
    description: json["description"],
    images: List<String>.from(json["images"].map((x) => x)),
    bill: Bill.fromJson(json["bill"]),
    id: json["_id"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "images": List<dynamic>.from(images.map((x) => x)),
    "bill": bill.toJson(),
    "_id": id,
    "__v": v,
  };
}

class Bill {
  int total;
  String title;
  List<String> images;
  List<String> members;
  List<dynamic> paidBy;

  Bill({
    required this.total,
    required this.title,
    required this.images,
    required this.members,
    required this.paidBy,
  });

  factory Bill.fromJson(Map<String, dynamic> json) => Bill(
    total: json["total"],
    title: json["title"],
    images: List<String>.from(json["images"].map((x) => x)),
    members: List<String>.from(json["members"].map((x) => x)),
    paidBy: List<dynamic>.from(json["paidBy"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "title": title,
    "images": List<dynamic>.from(images.map((x) => x)),
    "members": List<dynamic>.from(members.map((x) => x)),
    "paidBy": List<dynamic>.from(paidBy.map((x) => x)),
  };
}
