// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

List<Post> postFromJson(String str) => List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

String postToJson(List<Post> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Post {
    String model;
    int pk;
    Fields fields;

    Post({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Post.fromJson(Map<String, dynamic> json) => Post(
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
    String title;
    String content;
    String bookName;
    int rating;
    String author;

    Fields({
        required this.title,
        required this.content,
        required this.bookName,
        required this.rating,
        required this.author,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        title: json["title"],
        content: json["content"],
        bookName: json["book_name"],
        rating: json["rating"],
        author: json["author"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
        "book_name": bookName,
        "rating": rating,
        "author": author,
    };
}
