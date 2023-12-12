import 'package:bookoo_mobile/models/forums.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bookoo_mobile/reportbookstuff/report.dart';
import 'package:bookoo_mobile/user_utility.dart';
import 'package:bookoo_mobile/reportbookstuff/reportForm.dart';

class ReportBookPage extends StatefulWidget {
  const ReportBookPage({Key? key}) : super(key: key);

  @override
  _ReportBookPageState createState() => _ReportBookPageState();
}

class _ReportBookPageState extends State<ReportBookPage> {
  TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProduct();
  }

  Future<List<Product>> fetchProduct() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        'http://localhost:8000/modulreport/json/${UserUtility.user_id.toString()}/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Product> list_product = [];
    for (var d in data) {
      if (d != null) {
        list_product.add(Product.fromJson(d));
      }
    }
    return list_product.reversed.toList();
  }

  Future<void> _fetchProduct() async {
    try {
      List<Product> fetchedProducts = await fetchProduct();
      setState(() {
        _products = fetchedProducts;
        _filteredProducts = List<Product>.from(_products);
      });
    } catch (err) {
      // Handle error, maybe log it or show an error message
    }
  }

  void _filterReports(String query) {
    setState(() {
      _filteredProducts = _products
          .where((product) => product.fields.bookTitle
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _deleteReport(int index) async {
    try {
      int reportIdToDelete = _filteredProducts[index].pk; // Assuming 'pk' is the ID field of your Product model
      // print(reportIdToDelete);
      var url = Uri.parse(
          'http://localhost:8000/modulreport/hapuslaporan/$reportIdToDelete/'); // Replace with your Django endpoint URL
      var response = await http.post(url);

      if (response.statusCode == 200) {
        print('Report deleted successfully');
        setState(() {
          _filteredProducts.removeAt(index);
        });
      } else {
        print('Failed to delete report');
        // Handle failure, show an error message or retry logic
      }
    } catch (error) {
      print('Exception occurred while deleting report: $error');
      // Handle exception or error, show an error message or retry logic
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Book'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookReportForm(
                refreshCallback: _fetchProduct, // Pass the callback function
              ),
            ),
          ).then((_) {
            if (mounted) {
              _fetchProduct(); // Refresh data when returning from BookReportForm
            }
          });
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterReports,
              decoration: InputDecoration(
                hintText: 'Search by title...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${_filteredProducts[index].fields.bookTitle}",
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Status: ${_filteredProducts[index].fields.status}",
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Issue Type: ${_filteredProducts[index].fields.issueType}",
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Other Issue: ${_filteredProducts[index].fields.otherIssue}",
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Description: ${_filteredProducts[index].fields.description}",
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Date Added: ${_filteredProducts[index].fields.dateAdded}",
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () => _deleteReport(index),
                              child: Text('Delete Report'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
