import 'package:flutter/material.dart';

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final TextEditingController _bookTitleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _publishYearController = TextEditingController();

  Future<void> submitRequest() async {
    // Implement the logic to handle the submission
    // For example, sending data to a server or saving it locally
    print('Book Title: ${_bookTitleController.text}');
    print('Author: ${_authorController.text}');
    print('Publish Year: ${_publishYearController.text}');

    // Clear the input fields after submission
    _bookTitleController.clear();
    _authorController.clear();
    _publishYearController.clear();

    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request submitted successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Request'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _bookTitleController,
              decoration: InputDecoration(hintText: 'Book Title'),
            ),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(hintText: 'Author'),
            ),
            TextField(
              controller: _publishYearController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Publish Year'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitRequest,
              child: Text('Submit Request'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bookTitleController.dispose();
    _authorController.dispose();
    _publishYearController.dispose();
    super.dispose();
  }
}
