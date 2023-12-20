import 'dart:convert';
import 'package:http/http.dart' as http;
import 'diary_model.dart';

class DiaryService {
  final String apiUrl = 'http://localhost:3000/diaries';

  Future<void> addDiaryEntry(DiaryEntry entry) async {
    await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(entry.toMap()),
    );
  }

  Future<void> updateDiaryEntry(DiaryEntry entry) async {
    await http.put(
      Uri.parse('$apiUrl/${entry.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(entry.toMap()),
    );
  }

  Future<void> deleteDiaryEntry(String id) async {
    await http.delete(Uri.parse('$apiUrl/$id'));
  }

  Future<List<DiaryEntry>> getDiaryEntries() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> diaryJson = json.decode(response.body);
      return diaryJson.map((json) => DiaryEntry.fromMap(json)).toList();
    } else {
      throw Exception('Failed to load diary entries');
    }
  }
}
