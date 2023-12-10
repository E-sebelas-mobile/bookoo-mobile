import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/forums.dart'; // Assuming this file contains the Post model and JSON parsing logic

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();

  Future<List<Post>> fetchPosts() async {
    //var url = Uri.parse('https://bookoo-e11-tk.pbp.cs.ui.ac.id/forums/json/');
    var url = Uri.parse('http://127.0.0.1:8000/forums/json/');
    var response = await http.get(url, headers: {"Content-Type": "application/json"});
    
    if (response.statusCode == 200) {
      return postFromJson(response.body);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> submitPost() async {
    // var url = Uri.parse('https://bookoo-e11-tk.pbp.cs.ui.ac.id/forums/create-post-ajax/');
    var url = Uri.parse('http://127.0.0.1:8000/forums/create-post-ajax/');
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "author": _authorController.text,
        "title": _titleController.text,
        "content": _contentController.text,
        "book_name": _bookNameController.text,
        "rating": int.tryParse(_ratingController.text) ?? 0,
      }),
    );

    if (response.statusCode == 201) { // Correctly handle 201 status code as success
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post created successfully')));
      // Optionally, you could clear the form or navigate the user to another screen
      
    } else {
      // Handle all other responses as errors
      print('Failed to submit post: ${response.statusCode}');
      print('Response body: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create post: ${response.body}')));
    }
  }
  
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forum'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _authorController,
                  decoration: InputDecoration(hintText: 'Author'),
                ),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(hintText: 'Title'),
                ),
                TextField(
                  controller: _contentController,
                  decoration: InputDecoration(hintText: 'Your post content'),
                ),
                TextField(
                  controller: _bookNameController,
                  decoration: InputDecoration(hintText: 'Book\'s name'),
                ),
                TextField(
                  controller: _ratingController,
                  decoration: InputDecoration(hintText: 'Rating (1-5)'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: submitPost,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Post>>(
              future: fetchPosts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return Center(child: Text('No posts found.'));
                } else {
                  return ListView(
                    children: snapshot.data!.map((post) => PostListItem(
                      title: post.fields.title,
                      author: post.fields.author,
                      bookTitle: post.fields.bookName,
                      content: post.fields.content,
                      rating: post.fields.rating.toString(),
                    )).toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _authorController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    _bookNameController.dispose();
    _ratingController.dispose();
    super.dispose();
  }
}


class PostListItem extends StatelessWidget {
  final String title;
  final String author;
  final String bookTitle;
  final String content;
  final String rating;

  const PostListItem({
    Key? key,
    required this.title,
    required this.author,
    required this.bookTitle,
    required this.content,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 4),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text('by $author', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
          SizedBox(height: 8),
          Text(content),
          SizedBox(height: 8),
          Text('Book Name: $bookTitle'),
          Text('Rating: $rating', style: TextStyle(fontSize: 12, color: Color(0xFF838589))),
        ],
      ),
    );
  }
}


