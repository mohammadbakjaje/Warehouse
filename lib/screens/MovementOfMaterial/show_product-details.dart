import 'package:flutter/material.dart';
import 'package:warehouse/helper/my_colors.dart';

import 'show_product.dart';

class ProductDetail extends StatelessWidget {
  final Product product;

  const ProductDetail({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // بيانات تجريبية لسجل الحركات (يمكن استبدالها بـ API)
    final List<Map<String, dynamic>> movements = [
      {
        "type": "إدخال",
        "quantity": 50,
        "date": "2025-08-10",
      },
      {
        "type": "إخراج",
        "quantity": 20,
        "date": "2025-08-12",
      },
      {
        "type": "إدخال",
        "quantity": 100,
        "date": "2025-08-15",
      },
      {
        "type": "إخراج",
        "quantity": 30,
        "date": "2025-08-20",
      },
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: MyColors.orangeBasic,
          foregroundColor: Colors.white,
          title: Text(
            product.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // صورة المادة بحركة Hero
            Hero(
              tag: product.id,
              child: Image.network(
                product.image,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            // تفاصيل المادة
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 1),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "سجل الحركات",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // عرض سجل الحركات
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: movements.length,
                  itemBuilder: (context, index) {
                    final move = movements[index];
                    final isInput = move["type"] == "إدخال";
                    return Card(
                      color: isInput ? Colors.green[50] : Colors.red[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              move["type"],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isInput ? Colors.green : Colors.red,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "الكمية: ${move["quantity"]}",
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "التاريخ: ${move["date"]}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
