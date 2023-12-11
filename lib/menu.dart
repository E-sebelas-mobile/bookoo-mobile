import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'forum.dart'; // Add this import to use ForumPage
import 'bar.dart';
import 'reportbookstuff/menuReport.dart';

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

  @override
  void initState() {
    super.initState();
    username = widget.username;
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return _buildHomePage();
      case 1:
        return username != null ?  ForumPage() : _buildLoginPrompt();
      case 3:
        return username != null ? ReportBookPage() : _buildLoginPrompt();
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  'Welcome to your personal library!',
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
                children: [
                  InventoryCard(
                    InventoryItem("Placeholder 1", Icons.library_books,
                        Color(0xFF164863)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForumPage()),
                      );
                    },
                  ),
                  InventoryCard(
                    InventoryItem(
                        "Placeholder 2", Icons.create, Color(0xFF427D9D)),
                  ),
                  InventoryCard(
                    InventoryItem(
                        "Placeholder 3", Icons.logout, Color(0xFF9BBEC8)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
