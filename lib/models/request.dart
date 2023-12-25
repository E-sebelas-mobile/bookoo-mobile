// To parse this JSON data, do
//
//     final request = requestFromJson(jsonString);

import 'dart:convert';

List<Request> requestFromJson(String str) =>
    List<Request>.from(json.decode(str).map((x) => Request.fromJson(x)));

String requestToJson(List<Request> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Request {
  String model;
  int pk;
  Fields fields;

  Request({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  int user;
  String title;
  String author;
  int published;

  Fields({
    required this.user,
    required this.title,
    required this.author,
    required this.published,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        title: json["title"],
        author: json["author"],
        published: json["published"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "title": title,
        "author": author,
        "published": published,
      };
}
