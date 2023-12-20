import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'forum.dart'; // Add this import to use ForumPage
import 'bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bookoo_mobile/models/books.dart';
import 'package:bookoo_mobile/models/favorite.dart';
import 'package:url_launcher/url_launcher.dart';
import 'filter_library.dart';
import 'reportbookstuff/menuReport.dart';
import 'user_utility.dart';

class FavoritesAdminPage extends StatefulWidget {
  const FavoritesAdminPage({Key? key, required this.username}) : super(key: key);
  final String? username;

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesAdminPage> {
  int? userid=UserUtility.user_id;
  List<Favorite> all_Favorite = [];
  List<Favorite> id_Favorite = [];
  List<Favorite> cut_Favorite = [];
  List<String> titles=[];
  List<String> ids=[];
  List titleID=[];
  List FilteredtitleID=[];
  Future<List> fetchFavorite() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        'https://bookoo-e11-tk.pbp.cs.ui.ac.id/all_favorites/');
    var response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Favorite
    
    for (var d in data) {
        if (d != null) {
          
          all_Favorite.add(Favorite.fromJson(d));
          debugPrint(userid.toString());

        }
    }
    for (var d in all_Favorite){
      var temp ={d.fields.user:d.fields.title};
      debugPrint(temp.toString());
      titleID.add(temp);
    }
    for (var d in titleID){
      if (FilteredtitleID.contains(d)){

      }else{
        FilteredtitleID.add(d);
      }
    }
    debugPrint(FilteredtitleID.toString());
    return all_Favorite;
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: Column( 
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                "Favorites",
                textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
              )),
            Expanded(
            child: FutureBuilder(
            future: fetchFavorite(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (!snapshot.hasData) {
                  return const Column(
                    children: [
                      Text(
                        "Tidak ada data.",
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
                            Text(
                              "Favorited by ID:${snapshot.data![index].fields.user}",
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]
                        ),
                      ));
                }
              }
            }
            )
            )
            ]
            ));
}
}