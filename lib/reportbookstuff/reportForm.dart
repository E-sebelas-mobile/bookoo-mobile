import 'package:flutter/material.dart';
import 'package:bookoo_mobile/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bookoo_mobile/models/books.dart';

class BookReportForm extends StatefulWidget {
  const BookReportForm({Key? key}) : super(key: key);

  @override
  State<BookReportForm> createState() => _BookReportFormState();
}

class _BookReportFormState extends State<BookReportForm> {
  final _formKey = GlobalKey<FormState>();
  String? _bookTitle; // Nullable type
  String _issueType = '';
  String _otherIssueType = '';
  String _issueDescription = '';
  Set<String> bookTitles = {}; // Set to store fetched book titles

  @override
  void initState() {
    super.initState();
    fetchBookTitles(); // Fetch book titles when the widget initializes
  }

  Future<void> fetchBookTitles() async {
    var url = Uri.parse('http://localhost:8000/get_books_json/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    Set<String> titles = {};
    for (var d in data) {
      if (d != null) {
        titles.add(Fields.fromJson(d['fields']).title); // Access 'title' from 'Fields'
      }
    }
    setState(() {
      bookTitles = titles; // Update the state with fetched titles
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: Center(child: Text('Form Report Buku')),
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
          centerTitle: true, // Center the title
        ),
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _bookTitle,
                items: bookTitles.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _bookTitle = value; // Update _bookTitle when a new item is selected
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Judul Buku',
                  // Other decoration properties...
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul Buku tidak boleh kosong!';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Jenis Masalah',
                  labelText: 'Jenis Masalah',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _issueType = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jenis Masalah tidak boleh kosong!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Lainnya',
                  labelText: 'Jenis Masalah Lainnya (Opsional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _otherIssueType = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Deskripsi Masalah',
                  labelText: 'Deskripsi Masalah',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _issueDescription = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi Masalah tidak boleh kosong!';
                  }
                  return null;
                },
                maxLines: 5,
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Lakukan sesuatu dengan data yang terkumpul
                        // Misalnya, kirim data atau lakukan operasi lain
                        print('Judul Buku: $_bookTitle');
                        print('Jenis Masalah: $_issueType');
                        print('Jenis Masalah Lainnya: $_otherIssueType');
                        print('Deskripsi Masalah: $_issueDescription');

                        // Reset nilai input setelah submit
                        setState(() {
                          _bookTitle = '';
                          _issueType = '';
                          _otherIssueType = '';
                          _issueDescription = '';
                        });

                        // Tambahkan logika untuk mengirim atau menyimpan data di sini
                      }
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ], // This closes the children list for the Column widget
          ),
        ),
      ),
    );
  }
}
