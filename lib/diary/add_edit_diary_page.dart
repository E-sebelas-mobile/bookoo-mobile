import 'package:flutter/material.dart';
import 'diary_model.dart';

class AddEditDiaryPage extends StatefulWidget {
  final DiaryEntry? diaryEntry; // Make diaryEntry nullable

  AddEditDiaryPage({this.diaryEntry});

  @override
  _AddEditDiaryPageState createState() => _AddEditDiaryPageState();
}

class _AddEditDiaryPageState extends State<AddEditDiaryPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = ''; // Initialize with an empty string
  String _content = ''; // Initialize with an empty string

  @override
  void initState() {
    super.initState();
    if (widget.diaryEntry != null) {
      _title = widget.diaryEntry!.title; // Use ! to access properties of a non-null DiaryEntry
      _content = widget.diaryEntry!.content; // Use ! to access properties of a non-null DiaryEntry
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.diaryEntry == null ? 'New Diary Entry' : 'Edit Diary Entry'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              initialValue: _title,
              decoration: InputDecoration(labelText: 'Title'),
              onSaved: (value) => _title = value ?? '', // Handle null value
            ),
            TextFormField(
              initialValue: _content,
              decoration: InputDecoration(labelText: 'Content'),
              onSaved: (value) => _content = value ?? '', // Handle null value
            ),
            ElevatedButton(
              onPressed: _saveForm,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveForm() {
    final isValid = _formKey.currentState?.validate() ?? false; // Use ?. to safely call validate()
    if (!isValid) {
      return;
    }
    _formKey.currentState?.save(); // Use ?. to safely call save()
    // Implement logic to save the diary entry
    // Navigate back
  }
}
