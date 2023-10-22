// To parse this JSON data, do
//
//     final tst = tstFromJson(jsonString);

import 'dart:convert';

List<TST> tstFromJson(String str) =>
    List<TST>.from(json.decode(str).map((x) => TST.fromJson(x)));

String tstToJson(List<TST> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TST {
  int? userId;
  int? id;
  String? title;
  String? body;

  TST({
    this.userId,
    this.id,
    this.title,
    this.body,
  });

  factory TST.fromJson(Map<String, dynamic> json) => TST(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
      };
}
