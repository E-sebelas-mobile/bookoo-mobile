// To parse this JSON data, do
//
//     final books = booksFromJson(jsonString);

import 'dart:convert';

List<Books> booksFromJson(String str) => List<Books>.from(json.decode(str).map((x) => Books.fromJson(x)));

String booksToJson(List<Books> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Books {
    Model model;
    int pk;
    Fields fields;

    Books({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Books.fromJson(Map<String, dynamic> json) => Books(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String title;
    String author;
    String link;

    Fields({
        required this.title,
        required this.author,
        required this.link,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        title: json["Title"],
        author: json["Author"],
        link: json["Link"],
    );

    Map<String, dynamic> toJson() => {
        "Title": title,
        "Author": author,
        "Link": link,
    };
}

enum Model {
    APPMAIN_BOOK
}

final modelValues = EnumValues({
    "appmain.book": Model.APPMAIN_BOOK
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}