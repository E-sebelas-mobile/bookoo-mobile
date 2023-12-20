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
import 'menu.dart';
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key, required this.username}) : super(key: key);
  final String? username;

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  int? userid=UserUtility.user_id;
  List<Favorite> all_Favorite = [];
  List<Favorite> list_Favorite = [];
  List<String> list_FavoriteTitles = [];
  String? username;

  Future<List<String>> fetchFavorite() async {
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
        }
    }
    for (var d in all_Favorite){
      if (d.fields.user==userid ){
        list_Favorite.add(d);

      }
    }
    for (var d in list_Favorite){
      if (list_FavoriteTitles.contains(d.fields.title)){
        

      }else{
        list_FavoriteTitles.add(d.fields.title);
      }
    }
    return list_FavoriteTitles;
  }
  Future<void> _showLogoutConfirmation(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                if (username != null) {
                  // Logout logic (replace <APP_URL_KAMU> with your app's URL)
                  final request = context.read<CookieRequest>();
                  final response = await request.logout(
                    "https://bookoo-e11-tk.pbp.cs.ui.ac.id/auth/logout/",
                  );
                  String message = response["message"];
                  String uname = response["username"];
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("$message Sampai jumpa, $uname."),
                    ),
                  );
                  setState(() {
                    username = null; // Update username to null on logout
                  });
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(username: null),
                    ),
                    (Route<dynamic> route) =>
                        false, // Remove all routes below MyHomePage
                  );
                }
              },
              child: const Text('Logout'),
            )
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    username= widget.username;
  return Scaffold(
    appBar: AppBar(
          title: const Text('Bookoo'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                children: [
                  if (username != null)
                    Text(
                      'Hello $username!',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.person),
                    iconSize: 40.0,
                    onPressed: () {
                      if (username != null) {
                        _showLogoutConfirmation(context);
                      } else {
                        // Navigate to login form
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginForm()),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      body: Column( 
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                "Your Favorites",
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
                              "${snapshot.data![index]}",
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