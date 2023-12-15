// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
    String model;
    int pk;
    Fields fields;

    Product({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
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
    String bookTitle;
    String issueType;
    String otherIssue;
    String description;
    int user;
    String status;
    DateTime dateAdded;

    Fields({
        required this.bookTitle,
        required this.issueType,
        required this.otherIssue,
        required this.description,
        required this.user,
        required this.status,
        required this.dateAdded,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        bookTitle: json["book_title"],
        issueType: json["issue_type"],
        otherIssue: json["other_issue"],
        description: json["description"],
        user: json["user"],
        status: json["status"],
        dateAdded: DateTime.parse(json["date_added"]),
    );

    Map<String, dynamic> toJson() => {
        "book_title": bookTitle,
        "issue_type": issueType,
        "other_issue": otherIssue,
        "description": description,
        "user": user,
        "status": status,
        "date_added": "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}",
    };
}
