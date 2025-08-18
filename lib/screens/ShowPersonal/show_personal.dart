import 'package:flutter/material.dart';
import 'package:warehouse/helper/my_colors.dart';
import 'package:warehouse/screens/ShowRoomPersonal/show_room_personal.dart';

class ShowPersonal extends StatelessWidget {
  static String id = "ShowPersonal";

  final List<Map<String, String>> rooms = const [
    {"room": "101", "building": "Building A"},
    {"room": "202", "building": "Building B"},
    {"room": "303", "building": "Building C"},
    {"room": "404", "building": "Building D"},
    {"room": "909", "building": "Building E"},
    {"room": "505", "building": "Building F"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          "العهد الشخصية للموظف",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: MyColors.orangeBasic,
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          Color cardColor =
              index % 2 == 0 ? MyColors.background : MyColors.background2;
          final room = rooms[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowRoomPersonal(
                    roomNumber: room['room'] ?? "",
                    building: room['building'] ?? "",
                  ),
                ),
              );
            },
            child: Card(
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                title: Text(
                  "الغرفة ${room['room']}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  room['building'] ?? "",
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: Colors.black, size: 18),
              ),
            ),
          );
        },
      ),
    );
  }
}
