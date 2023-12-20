import 'package:flutter/material.dart';
import 'diary_provider.dart';
import 'diary_model.dart';
import 'add_edit_diary_page.dart';
import 'package:provider/provider.dart';

class DiaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diary'),
      ),
      body: Consumer<DiaryProvider>(
        builder: (context, diaryProvider, child) {
          return ListView.builder(
            itemCount: diaryProvider.entries.length,
            itemBuilder: (context, index) {
              DiaryEntry entry = diaryProvider.entries[index];
              return ListTile(
                title: Text(entry.title),
                subtitle: Text(entry.content),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditDiaryPage(diaryEntry: entry),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Implement delete functionality
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditDiaryPage()),
          );
        },
      ),
    );
  }
}
