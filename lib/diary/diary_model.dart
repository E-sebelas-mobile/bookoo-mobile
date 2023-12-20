import 'dart:convert';

class DiaryEntry {
  String id;
  String title;
  String content;
  DateTime date;

  DiaryEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
    };
  }

  static DiaryEntry fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: DateTime.parse(map['date']),
    );
  }

  static List<DiaryEntry> fromJson(String str) =>
      List<DiaryEntry>.from(json.decode(str).map((x) => DiaryEntry.fromMap(x)));

  static String toJson(List<DiaryEntry> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toMap())));
}
