import 'package:flutter/material.dart';

class ShowLastRequest extends StatelessWidget {
  static String id = "ShowLastRequest";
  final List<Map<String, String>> requests = [
    {"id": "12345", "date": "01/25/2024", "status": "Submitted"},
    {"id": "67890", "date": "01/20/2024", "status": "Submitted"},
    {"id": "23456", "date": "01/15/2024", "status": "Submitted"},
    {"id": "98765", "date": "01/10/2024", "status": "Submitted"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Previous Request',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              itemCount: requests.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Request ID ${requests[index]["id"]}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text('Date: ${requests[index]["date"]}'),
                        Text('Status: ${requests[index]["status"]}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
