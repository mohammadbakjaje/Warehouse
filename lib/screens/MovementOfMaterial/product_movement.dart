import 'package:flutter/material.dart';
import 'package:warehouse/helper/my_colors.dart';

class ProductMovement extends StatelessWidget {
  const ProductMovement({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> warehouses = [
      {"id": "101", "building": "المبنى A"},
      {"id": "102", "building": "المبنى B"},
      {"id": "103", "building": "المبنى C"},
      {"id": "104", "building": "المبنى D"},
      {"id": "105", "building": "المبنى E"},
      {"id": "106", "building": "المبنى F"},
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "حركة المواد - المستودعات",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: MyColors.orangeBasic,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // عمودين
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.2, // نسبة الطول للعرض
            ),
            itemCount: warehouses.length,
            itemBuilder: (context, index) {
              final warehouse = warehouses[index];
              return GestureDetector(
                onTap: () {
                  // فتح صفحة تفاصيل المستودع
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WarehouseDetailsPage(
                        warehouse: warehouse,
                      ),
                    ),
                  );
                },
                child: Card(
                  color: Colors.grey[150],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "المستودع ${warehouse["id"]!}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${warehouse["building"]}",
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// صفحة تفاصيل المستودع
class WarehouseDetailsPage extends StatelessWidget {
  final Map<String, String> warehouse;

  const WarehouseDetailsPage({super.key, required this.warehouse});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "تفاصيل ${warehouse["id"]}",
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: MyColors.orangeBasic,
        ),
        body: Center(
          child: Text(
            "المستودع ${warehouse["id"]} تابع لـ ${warehouse["building"]}",
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
