// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:bookoo_mobile/requestpage.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class NewBookRequestFormPage extends StatefulWidget {
  const NewBookRequestFormPage({super.key});

  @override
  State<NewBookRequestFormPage> createState() => _NewBookRequestFormPageState();
}

class _NewBookRequestFormPageState extends State<NewBookRequestFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _author = "";
  String _published = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Book Request'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Title",
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => _title = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Title cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Author",
                    labelText: "Author",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => _author = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Author cannot be empty!";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Published Year",
                    labelText: "Published Year",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => _published = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Published year cannot be empty!";
                    }
                    return null;
                  },
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
                        // Kirim ke Django dan tunggu respons
                        // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                        final response = await request.postJson(
                            "https://bookoo-e11-tk.pbp.cs.ui.ac.id/bookrequest/create-request-flutter/",
                            jsonEncode(<String, String>{
                              'title': _title,
                              'author': _author,
                              'published': _published.toString(),
                            }));
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Produk baru berhasil disimpan!"),
                          ));
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RequestPage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content:
                                Text("Terdapat kesalahan, silakan coba lagi."),
                          ));
                        }
                      }
                    },
                    child: const Text("Submit",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
