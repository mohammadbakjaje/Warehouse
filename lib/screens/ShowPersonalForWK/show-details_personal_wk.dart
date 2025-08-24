import 'package:flutter/material.dart';

import '../../helper/my_colors.dart';

class ShowDetailsPersonalWkDetailsPage extends StatefulWidget {
  final Map<String, dynamic> custody;

  const ShowDetailsPersonalWkDetailsPage({super.key, required this.custody});

  @override
  State<ShowDetailsPersonalWkDetailsPage> createState() =>
      _CustodyDetailsPageState();
}

class _CustodyDetailsPageState extends State<ShowDetailsPersonalWkDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final items = widget.custody["items"] as List<dynamic>;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(
            "تفاصيل العهدة ${widget.custody['id']}",
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: MyColors.orangeBasic,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: items.length,
          itemBuilder: (context, index) {
            Color cardColor =
                index % 2 == 0 ? MyColors.background : MyColors.background2;
            final item = items[index];
            return Card(
              color: cardColor,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["name"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text("رقم المادة: ${item['number']}"),
                    Text("الكمية: ${item['quantity']}"),
                    Text("مذكرة الإخراج: ${item['memoId']}"),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
