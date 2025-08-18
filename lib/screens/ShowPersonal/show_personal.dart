import 'package:flutter/material.dart';

class ShowPersonal extends StatelessWidget {
  static String id = "ShowPersonal";

  final List<Map<String, String>> rooms = const [
    {"room": "101", "building": "Building A"},
    {"room": "202", "building": "Building B"},
    {"room": "303", "building": "Building C"},
    {"room": "404", "building": "Building D"},
    {"room": "333333", "building": "Building E"},
    {"room": "505", "building": "Building F"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          " العهد الشخصية للموظف",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];
          return GestureDetector(
            onTap: () {},
            child: Card(
              color: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                title: Text(
                  "Room [${room['room']}]",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  room['building'] ?? "",
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: const Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 18),
              ),
            ),
          );
        },
      ),
    );
  }
}
