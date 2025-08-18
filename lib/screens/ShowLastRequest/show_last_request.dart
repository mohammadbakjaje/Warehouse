import 'package:flutter/material.dart';
import 'package:warehouse/helper/my_colors.dart';

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
      appBar: AppBar(
        backgroundColor: MyColors.orangeBasic,
        foregroundColor: Colors.black,
        title: Text("Previous Request"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  // تغيير اللون بين الخلفية 1 و 2
                  Color cardColor = index % 2 == 0
                      ? MyColors.background
                      : MyColors.background2;
                  return Card(
                    color: cardColor,
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
      ),
    );
  }
}
