import 'package:bookoo_mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bookoo_mobile/models/books.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bookoo_mobile/screens/filter_library.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  TextEditingController controller = new TextEditingController();
  List<Books> library = [];
  List<Books> filtered = [];

  _launchUrl(bookURL) async {
    if (await canLaunchUrl(bookURL)) {
      await launchUrl(bookURL);
    } else {
      throw "Could not open.";
    }
  }

  Future<List<Books>> fetchProduct() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        'https://bookoo-e11-tk.pbp.cs.ui.ac.id/get_books_json/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    // melakukan konversi data json menjadi object Product
    for (var d in data) {
      if (d != null) {
        library.add(Books.fromJson(d));
      }
    }
    return library;
  }

  onSearchTextChanged(String text) async {
    List<Books> filtered = [];
    for (var d in library) {
      if (d.fields.title.contains(text)){
        filtered.add(d);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Product'),
        ),
        body:Column( 
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                "Library",
                textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
              )),
            SearchBar(
              controller: controller,
              onChanged: onSearchTextChanged,
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: (){
                Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                FilteredLibraryPage(filtered: filtered),
                                          ));
              }, 
              child: const Text('Search'),),
            const SizedBox(height: 24.0),
            Expanded(
            child: FutureBuilder(
            future: fetchProduct(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (!snapshot.hasData) {
                  return const Column(
                    children: [
                      Text(
                        "Tidak ada data produk.",
                        style:
                        TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              "${snapshot.data![index].fields.title}",
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text("${snapshot.data![index].fields.author}"),
                            const SizedBox(height: 10),
                            ListTile(
                                onTap: () {
                                  var bookURI= Uri.parse(
                                  '${snapshot.data![index].fields.link}');
                                  _launchUrl(bookURI);
                                },
                                title: Text("${snapshot.data![index].fields.link}")),
                            ListTile(
                                onTap: () {
                                  
                                },
                                title: const Text("Favorite It"))
                          ],
                        ),
                      ));
                }
              }
            }
            )
            )
            ]
            )
            );
  }
}