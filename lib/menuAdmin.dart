import 'package:bookoo_mobile/user_utility.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'menu.dart';
import 'package:bookoo_mobile/reportbookstuff/menuReportAdmin.dart';
import 'favoritesAdmin.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AdminPage(username: 'Admin'), // Pass your username here
    );
  }
}

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key, required this.username}) : super(key: key);
  final String username;

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String? username;

  @override
  void initState() {
    super.initState();
    username = widget.username;
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                'Welcome Admin - $username',
                overflow: TextOverflow.ellipsis,
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
                    MaterialPageRoute(builder: (context) => const LoginForm()),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  'Welcome to your admin panel!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GridView.count(
                primary: true,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                shrinkWrap: true,
                children: const [
                  // Your InventoryItem widgets here
                  InventoryCard(InventoryItem(
                      "Placeholder 1", Icons.library_books, Color(0xFF164863))),
                  InventoryCard(InventoryItem(
                      "Daftar Favorite User", Icons.heart_broken, Color(0xFF427D9D))),
                  InventoryCard(InventoryItem(
                      "Lihat Daftar Report",
                      Icons.description,
                      Color(0xFF9BBEC8))), // Updated placeholder
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InventoryItem {
  final String name;
  final IconData icon;
  final Color color;

  const InventoryItem(this.name, this.icon, this.color);
}

class InventoryCard extends StatelessWidget {
  final InventoryItem item;

  const InventoryCard(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.color,
      child: InkWell(
        onTap: () {
          if (item.name == "Daftar Favorite User") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoritesAdminPage(username: UserUtility.username)),
            );
          } else if (item.name == "Lihat Daftar Report") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReportBookPageAdmin()),
            );
          }
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
