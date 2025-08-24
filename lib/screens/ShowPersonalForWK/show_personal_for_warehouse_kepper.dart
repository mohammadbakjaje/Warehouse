import 'package:flutter/material.dart';
import 'package:warehouse/helper/my_colors.dart';
import 'package:warehouse/screens/ShowPersonalForWK/show-details_personal_wk.dart';

class ShowPersonalForWarehouseKepper extends StatefulWidget {
  const ShowPersonalForWarehouseKepper({super.key});

  @override
  State createState() => _CustodyListPageState();
}

class _CustodyListPageState extends State {
  List<Map<String, dynamic>> allCustody = [
    {
      "id": "1001",
      "room": "101",
      "owner": "أحمد علي",
      "notes": "لابتوب Dell XPS - خدش بسيط",
      "items": [
        {
          "name": "لابتوب Dell",
          "number": "M-2001",
          "quantity": "1",
          "memoId": "خ-5001"
        },
        {
          "name": "شاحن لابتوب",
          "number": "M-2002",
          "quantity": "1",
          "memoId": "خ-5002"
        },
      ]
    },
    {
      "id": "1002",
      "room": "202",
      "owner": "سارة خالد",
      "notes": "آيفون 12 - الشاحن مفقود",
      "items": [
        {
          "name": "هاتف آيفون 12",
          "number": "M-3001",
          "quantity": "1",
          "memoId": "خ-6001"
        }
      ]
    },
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filteredCustody = allCustody.where((custody) {
      final owner = custody["owner"]!.toLowerCase();
      return owner.contains(searchQuery.toLowerCase());
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "العهد الشخصية لجميع الموظفين",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: MyColors.orangeBasic,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded),
                  hintText: "ابحث باسم صاحب العهدة...",
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
            // قائمة العهد
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: filteredCustody.length,
                itemBuilder: (context, index) {
                  Color cardColor = index % 2 == 0
                      ? MyColors.background
                      : MyColors.background2;
                  final custody = filteredCustody[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ShowDetailsPersonalWkDetailsPage(
                            custody: custody,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: cardColor,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "العهدة: ${custody['id']}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text("رقم الغرفة: ${custody['room']}"),
                            Text("اسم صاحب العهدة: ${custody['owner']}"),
                            const SizedBox(height: 6),
                            Text(
                              "الملاحظات: ${custody['notes']}",
                              style: const TextStyle(color: Colors.grey),
                            ),
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
      ),
    );
  }
}
