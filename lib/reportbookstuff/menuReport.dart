import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bookoo_mobile/reportbookstuff/report.dart';
import 'package:bookoo_mobile/user_utility.dart';

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
    try {
      var url = Uri.parse('http://localhost:8000/modulreport/json-modif/');
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({'user_id': UserUtility.user_id}),
      );

      var data = jsonDecode(utf8.decode(response.bodyBytes));
      List<Product> products = [];
      for (var productData in data['products']) {
        Product product = Product.fromJson(productData);
        products.add(product);
      }
      return products;
    } catch (err) {
      // Handle error, maybe log it or show an error message
      return [];
    }
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

  void _deleteReport(int index) {
    // Implement the logic to delete the report at the given index
    // from your backend or local storage.
    setState(() {
      _filteredProducts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Book'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement the logic to navigate to the create report screen
          // or show a dialog for creating a new report.
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
