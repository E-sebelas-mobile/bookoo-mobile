import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import 'login.dart';

void main() {
  runApp(const RegistrationForm());
}

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegistrationForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();
  
  // Track the state of the admin checkbox
  bool _isAdmin = false;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginForm()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              controller: _passwordConfirmationController,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                Checkbox(
                  value: _isAdmin,
                  onChanged: (bool? value) {
                    setState(() {
                      _isAdmin = value ?? false;
                    });
                  },
                ),
                Text('Register as Admin'), // Label for the checkbox
              ],
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                String username = _usernameController.text;
                String password = _passwordController.text;
                String confirmPassword = _passwordConfirmationController.text;

                // Construct the payload with admin status
                final payload = convert.jsonEncode(<String, dynamic>{
                  'username': username,
                  'password1': password,
                  'password2': confirmPassword,
                  'is_admin': _isAdmin, // Include the admin status
                });

                // Check credentials
                final response = await request.postJson(
                  "https://bookoo-e11-tk.pbp.cs.ui.ac.id/auth/register/",
                  payload,
                );

                if (response['status'] == 'success') {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Account has been successfully registered!"),
                  ));

                  // Delay the navigation after showing the SnackBar
                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginForm()),
                    );
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("An error occurred, please try again."),
                  ));
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
