import 'package:flutter/material.dart';
import 'package:warehouse/helper/my_colors.dart';

class ShowRoomPersonal extends StatelessWidget {
  static String id = "ShowRoomPersonal";

  final String roomNumber;
  final String building;

  const ShowRoomPersonal({
    super.key,
    required this.roomNumber,
    required this.building,
  });

  final List<Map<String, String>> items = const [
    {
      "name": " Dell XPS 15",
      "code": "SN-12345678",
      "qty": "1",
      "exitNote": "Minor scratch on lid",
    },
    {
      "name": "Dell XPS 15",
      "code": "SN-12345678",
      "qty": "EN-9876",
      "exitNote": "Minor scratch on lid",
    },
    {
      "name": "Dell XPS 15",
      "code": "SN-12345676",
      "qty": "1",
      "exitNote": "Minor scratch on lid",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: AppBar(
        backgroundColor: MyColors.orangeBasic,
        foregroundColor: Colors.white,
        title: Text("الغرفة $roomNumber - $building"),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            color: MyColors.background2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["name"] ?? "Item Name",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text("Item Code: ${item["code"]}"),
                  Text("Quantity: ${item["qty"]}"),
                  Text("Exit Note ID: ${item["exitNote"]}"),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.orangeBasic,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Item ${item["name"]} returned."),
                            ),
                          );
                        },
                        child: const Text("Return Item"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
