import 'dart:convert';

import 'package:bookoo_mobile/models/books.dart';
import 'package:bookoo_mobile/request.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bar.dart';
import 'favorites.dart';
import 'filter_library.dart';
import 'forum.dart'; // Add this import to use ForumPage
import 'login.dart';
import 'reportbookstuff/menuReport.dart';
import 'user_utility.dart';

class InventoryItem {
  final String name;
  final IconData icon;
  final Color color;

  const InventoryItem(this.name, this.icon, this.color);
}

class InventoryCard extends StatelessWidget {
  final InventoryItem item;
  final Function()? onTap;

  InventoryCard(this.item, {Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      child: InkWell(
        onTap: onTap ??
            () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text("Placeholder for ${item.name}!"),
                  ),
                );
            },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.username}) : super(key: key);
  final String? username;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? username;
  int _selectedIndex = 0;
  int? userid = UserUtility.user_id;
  String? search;
  String title = "";
  final _formKey = GlobalKey<FormState>();

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
    var url =
        Uri.parse('https://bookoo-e11-tk.pbp.cs.ui.ac.id/get_books_json/');
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

  @override
  void initState() {
    super.initState();
    username = widget.username;
  }

  onSearchTextChanged(String text) async {
    search = text.toLowerCase();
    debugPrint(search);
    debugPrint(userid.toString());
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return _buildHomePage();
      case 1:
        return username != null ? ForumPage() : _buildLoginPrompt();
      case 2:
        return username != null ? RequestPage() : _buildLoginPrompt();
      case 3:
        return username != null ? ReportBookPage() : _buildLoginPrompt();
      case 5:
        return username != null
            ? FavoritesPage(username: username)
            : _buildLoginPrompt();
      // Add cases for other indices if needed
      default:
        return Container(); // Return an empty container or handle default case
    }
  }

  Widget _buildHomePage() {
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
        body: Column(children: [
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
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FilteredLibraryPage(username: username, search: search),
                  ));
              debugPrint(search);
            },
            child: const Text('Search'),
          ),
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
                              style: TextStyle(
                                  color: Color(0xff59A5D8), fontSize: 20),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          "${snapshot.data![index].fields.author}"),
                                      const SizedBox(height: 10),
                                      ListTile(
                                          onTap: () {
                                            var bookURI = Uri.parse(
                                                '${snapshot.data![index].fields.link}');
                                            _launchUrl(bookURI);
                                          },
                                          title: Text(
                                              "${snapshot.data![index].fields.link}")),
                                      ListTile(
                                          onTap: () async {
                                            if (username == null) {
                                              await showDialog<void>(
                                                  context: context,
                                                  builder: (context) =>
                                                      _buildLoginPrompt());
                                            } else {
                                              title =
                                                  "${snapshot.data![index].fields.title}";
                                              _showFavoritePopup(
                                                  context, title);
                                            }
                                          },
                                          title: const Text("Favorite It"))
                                    ],
                                  ),
                                ));
                      }
                    }
                  }))
        ]));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildLoginPrompt() {
    return AlertDialog(
      title: const Text('Login Required'),
      content: const Text('You must log in to access this feature.'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginForm()),
            );
          },
          child: const Text('Login'),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(_selectedIndex),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<void> _showFavoritePopup(BuildContext context, String title) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned(
                  right: -40,
                  top: -40,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const CircleAvatar(child: Icon(Icons.close)),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text("Favorite A Book?"),
                      const Text("Title"),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextFormField(
                          initialValue: title,
                          decoration: InputDecoration(
                            hintText: "Title",
                            labelText: "Title",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              title = value!;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Judul tidak boleh kosong!";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: ElevatedButton(
                            child: const Text('Submit'),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final request = context.read<CookieRequest>();
                                final response = await request.postJson(
                                    "http://localhost:8000/favorite_flutter/",
                                    jsonEncode(<String, String>{
                                      'title': title,
                                    }));
                                if (response['status'] == 'success') {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Berhasil difavoritkan"),
                                  ));
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                        "Terdapat kesalahan, silakan coba lagi."),
                                  ));
                                }
                              }
                            }),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
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
                    "http://localhost:8000/auth/logout/",
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
}
