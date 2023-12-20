import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'forum.dart'; // Add this import to use ForumPage
import 'bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bookoo_mobile/models/books.dart';
import 'package:url_launcher/url_launcher.dart';
import 'filter_library.dart';
import 'reportbookstuff/menuReport.dart';
import 'user_utility.dart';
import 'favorites.dart';
import 'reportbookstuff/menuReport.dart';
import 'menu.dart';


class FavoriteFormPage extends StatefulWidget {
  final String title;
  const FavoriteFormPage({Key? key, required this.title}) : super(key: key);

  @override
  State<FavoriteFormPage> createState() => _FavoriteFormPageState();
}

class _FavoriteFormPageState extends State<FavoriteFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  
  @override
  Widget build(BuildContext context) {
    _title=widget.title;
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Form Tambah Item',
          ),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Padding(
              padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: "Nama Item",
              labelText: "Nama Item",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            onChanged: (String? value) {
              setState(() {
                _title = value!;
              });
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Nama tidak boleh kosong!";
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
                backgroundColor:
                MaterialStateProperty.all(Colors.indigo),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Kirim ke Django dan tunggu respons
                  // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                  final response = await request.postJson(
                      "http://localhost:8000/favorite_flutter/",
                      jsonEncode(<String, String>{
                        'Title': _title,
                        // TODO: Sesuaikan field data sesuai dengan aplikasimu
                      }));
                  if (response['status'] == 'success') {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                      content: Text("Produk baru berhasil disimpan!"),
                    ));
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage(username: UserUtility.username)),
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
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        )]
      ),
    ),
      ),
    );
  }
}