import 'dart:convert';

GetTodoModel todoModelFromJson(String str) => GetTodoModel.fromJson(json.decode(str));

String todoModelToJson(GetTodoModel data) => json.encode(data.toJson());

class GetTodoModel {
  bool success;
  String message;
  List<Todo> todos;
  Pagination pagination;

  GetTodoModel({
    required this.success,
    required this.message,
    required this.todos,
    required this.pagination,
  });

  factory GetTodoModel.fromJson(Map<String, dynamic> json) => GetTodoModel(
    success: json["success"],
    message: json["message"],
    todos: List<Todo>.from(json["todos"].map((x) => Todo.fromJson(x))),
    pagination: Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "todos": List<dynamic>.from(todos.map((x) => x.toJson())),
    "pagination": pagination.toJson(),
  };
}

class Pagination {
  int total;
  int page;
  int limit;

  Pagination({
    required this.total,
    required this.page,
    required this.limit,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: json["total"],
    page: json["page"],
    limit: json["limit"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "page": page,
    "limit": limit,
  };
}

class Todo {
  String id;
  String title;
  String billStatus;
  int totalBill;
  List<Member> members;

  Todo({
    required this.id,
    required this.title,
    required this.billStatus,
    required this.totalBill,
    required this.members,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: json["id"],
    title: json["title"],
    billStatus: json["billStatus"],
    totalBill: json["totalBill"],
    members: List<Member>.from(json["members"].map((x) => Member.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "billStatus": billStatus,
    "totalBill": totalBill,
    "members": List<dynamic>.from(members.map((x) => x.toJson())),
  };
}

class Member {
  String memberId;
  String name;

  Member({
    required this.memberId,
    required this.name,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    memberId: json["memberId"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "memberId": memberId,
    "name": name,
  };
}
