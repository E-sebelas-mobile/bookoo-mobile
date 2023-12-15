import 'package:bookoo_mobile/reportbookstuff/menuReport.dart';
import 'package:flutter/material.dart';
import 'package:bookoo_mobile/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bookoo_mobile/models/books.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';



class BookReportForm extends StatefulWidget {
  final VoidCallback refreshCallback; // Define a callback function
  const BookReportForm({Key? key, required this.refreshCallback}) : super(key: key);

  @override
  State<BookReportForm> createState() => _BookReportFormState();
}

class _BookReportFormState extends State<BookReportForm> {
  final _formKey = GlobalKey<FormState>();
  String? _bookTitle; // Nullable type
  String? _issueType;
  String _otherIssueType = '';
  String _issueDescription = '';
  Set<String> bookTitles = {}; // Set to store fetched book titles
  bool _showOtherIssueTypeField = false; // Initially hide the field

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
        titles.add(
            Fields.fromJson(d['fields']).title); // Access 'title' from 'Fields'
      }
    }
    setState(() {
      bookTitles = titles; // Update the state with fetched titles
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
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
                            _bookTitle =
                                value; // Update _bookTitle when a new item is selected
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Judul Buku',
                          labelText: 'Judul Buku',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Judul Buku tidak boleh kosong!';
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _issueType,
                        decoration: InputDecoration(
                          hintText: 'Jenis Masalah',
                          labelText: 'Jenis Masalah',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        items: <String>[
                          'Buku Rusak',
                          'Informasi Hilang',
                          'Masalah Lainnya'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _issueType = value!;
                            // Toggle visibility based on selected value
                            _showOtherIssueTypeField =
                                value == 'Masalah Lainnya';
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Jenis Masalah tidak boleh kosong!';
                          }
                          return null;
                        },
                      ),
                      if (_showOtherIssueTypeField == true)
                        const SizedBox(height: 12),
                      Visibility(
                        visible: _showOtherIssueTypeField,
                        child: TextFormField(
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
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Process and send data here
                        // For example:
                        // sendData(_bookTitle, _issueType, _otherIssueType, _issueDescription);
                        // Reset form fields after submission
                        // Kirim ke Django dan tunggu respons
                            // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                            final response = await request.postJson(
                            "http://localhost:8000/modulreport/simpanlaporanflutter/",
                            jsonEncode(<String, String>{
                                  'book_title': _bookTitle ?? '',
                                  'issue_type': _issueType ?? '',
                                  'other_issue': _otherIssueType,
                                  'description': _issueDescription,
                                // TODO: Sesuaikan field data sesuai dengan aplikasimu
                            }));
                            if (response['status'] == 'success') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                content: Text("Produk baru berhasil disimpan!"),
                                ));
                                widget.refreshCallback(); // Execute the callback

                                Navigator.pop(context); 
                            } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                    content:
                                        Text("Terdapat kesalahan, silakan coba lagi."),
                                ));
                            }
                        setState(() {
                          _bookTitle = null; // Set to null instead of an empty string
                          _issueType = null;
                          _otherIssueType = '';
                          _issueDescription = '';
                        });
                      }
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
