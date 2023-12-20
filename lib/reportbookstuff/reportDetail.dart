import 'package:flutter/material.dart';
import 'package:bookoo_mobile/reportbookstuff/report.dart';
import 'package:bookoo_mobile/user_utility.dart';
import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

typedef void RefreshCallback();

class ReportDetailPage extends StatefulWidget {
  final Report report; // Pass the Report object to display its details
  final RefreshCallback refreshCallback; // Add this line

  const ReportDetailPage(
      {Key? key, required this.report, required this.refreshCallback})
      : super(key: key);
  @override
  _ReportDetailPageState createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  final _formKey = GlobalKey<FormState>();
  Set<String> statusOptions = {'Under Review', 'Accepted', 'Rejected'};
  late String _selectedStatus;
  late TextEditingController _feedbackController;
  String? _feedbackError;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.report.fields.status;
    // print('Default status in Flutter: $_selectedStatus');
    _feedbackController = TextEditingController();
    _feedbackController.text = widget.report.fields.adminResponse ?? '';
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _validateFeedback(String value) {
    if (value.isEmpty) {
      setState(() {
        _feedbackError = 'Feedback cannot be empty!';
      });
    } else {
      setState(() {
        _feedbackError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Information'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ... (existing code)
              Text(
                "${widget.report.fields.bookTitle}",
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Report By: ${widget.report.fields.username}",
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: _selectedStatus,
                onChanged: (newValue) {
                  setState(() {
                    _selectedStatus = newValue!;
                  });
                },
                items:
                    statusOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

              const SizedBox(height: 10),
              Text(
                "Issue Type: ${widget.report.fields.issueType}",
              ),
              const SizedBox(height: 10),
              Text(
                "Other Issue: ${widget.report.fields.otherIssue}",
              ),
              const SizedBox(height: 10),
              Text(
                "Description: ${widget.report.fields.description}",
              ),
              const SizedBox(height: 10),
              Text(
                "Date Added: ${widget.report.fields.dateAdded}",
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _feedbackController,
                decoration: InputDecoration(
                  labelText: 'Feedback',
                  hintText: 'Enter Feedback',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  errorText: _feedbackError,
                ),
                onChanged: (value) {
                  _validateFeedback(value);
                },
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Feedback cannot be empty!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              // ... (existing code)
              Container(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.indigo),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Process and send data here
                      // For example:
                      // sendData(_bookTitle, _issueType, _otherIssueType, _issueDescription);
                      // Reset form fields after submission
                      // Kirim ke Django dan tunggu respons
                      final response = await request.postJson(
                        "https://bookoo-e11-tk.pbp.cs.ui.ac.id/modulreport/responselaporanflutter/${widget.report.pk}/",
                        jsonEncode(<String, String>{
                          'status': _selectedStatus,
                          'adminResponse': _feedbackController.text,
                          // TODO: Sesuaikan field data sesuai dengan aplikasimu
                        }),
                      );
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Berhasil respons laporan!"),
                        ));
                        // widget.refreshCallback(); // Execute the callback
                        widget.refreshCallback(); // Trigger the refresh on the previous page
                        setState(() {
                          _selectedStatus =
                              _selectedStatus; // No change needed here
                          _feedbackController.text = '';
                        });
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Terdapat kesalahan, silakan coba lagi."),
                        ));
                      }
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
