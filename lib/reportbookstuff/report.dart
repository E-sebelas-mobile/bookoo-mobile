// To parse this JSON data, do
//
//     final report = reportFromJson(jsonString);

import 'dart:convert';

List<Report> reportFromJson(String str) => List<Report>.from(json.decode(str).map((x) => Report.fromJson(x)));

String reportToJson(List<Report> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Report {
    String model;
    int pk;
    Fields fields;

    Report({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Report.fromJson(Map<String, dynamic> json) => Report(
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
    String username;
    String adminResponse;

    Fields({
        required this.bookTitle,
        required this.issueType,
        required this.otherIssue,
        required this.description,
        required this.user,
        required this.status,
        required this.dateAdded,
        required this.username,
        required this.adminResponse,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        bookTitle: json["book_title"],
        issueType: json["issue_type"],
        otherIssue: json["other_issue"],
        description: json["description"],
        user: json["user"],
        status: json["status"],
        dateAdded: DateTime.parse(json["date_added"]),
        username: json["username"],
        adminResponse: json["admin_response"],
    );

    Map<String, dynamic> toJson() => {
        "book_title": bookTitle,
        "issue_type": issueType,
        "other_issue": otherIssue,
        "description": description,
        "user": user,
        "status": status,
        "date_added": "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}",
        "username": username,
        "admin_response": adminResponse,
    };
}
