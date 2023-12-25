import 'dart:convert';

import 'package:bookoo_mobile/models/request.dart';
import 'package:bookoo_mobile/request_form.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'user_utility.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  int? userId = UserUtility.user_id;
  List<Request> listRequests = [];

  Future<List<Request>> fetchRequests() async {
    final userId = UserUtility.user_id;

    var url = Uri.parse(
        'https://bookoo-e11-tk.pbp.cs.ui.ac.id/bookrequest/get-reqs/');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      List<Request> userRequests = data
          .map((d) => Request.fromJson(d))
          .where((request) => request.fields.user == userId)
          .toList();

      return userRequests;
    } else {
      // Debug print for error
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Requests'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Text(
              "Your Book Requests",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: fetchRequests(),
              builder: (context, AsyncSnapshot<List<Request>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "No book requests found.",
                      style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, index) => Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Title: ${snapshot.data![index].fields.title}",
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                              "Author: ${snapshot.data![index].fields.author}"),
                          Text(
                              "Published Year: ${snapshot.data![index].fields.published}"),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the NewBookRequestFormPage
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const NewBookRequestFormPage()),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Request New Book',
      ),
      // Add the floating action button if needed
    );
  }
}
