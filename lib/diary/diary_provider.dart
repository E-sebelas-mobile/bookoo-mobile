import 'package:flutter/material.dart';
import 'diary_service.dart';
import 'diary_model.dart';

class DiaryProvider with ChangeNotifier {
  final DiaryService _diaryService = DiaryService();
  List<DiaryEntry> _entries = [];

  List<DiaryEntry> get entries => _entries;

  Future<void> loadDiaries() async {
    _entries = await _diaryService.getDiaryEntries();
    notifyListeners();
  }

  Future<void> addDiary(DiaryEntry entry) async {
    final newEntry = await _diaryService.addDiaryEntry(entry);
    _entries.add(newEntry);
    notifyListeners();
  }

  Future<void> updateDiary(DiaryEntry entry) async {
    await _diaryService.updateDiaryEntry(entry);
    // Replace the old entry with the updated one
    int index = _entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      _entries[index] = entry;
      notifyListeners();
    }
  }

  Future<void> deleteDiary(String id) async {
    await _diaryService.deleteDiaryEntry(id);
    _entries.removeWhere((entry) => entry.id == id);
    notifyListeners();
  }
}
