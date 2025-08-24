import 'package:flutter/material.dart';
import 'package:warehouse/helper/my_colors.dart';
import 'package:warehouse/screens/MovementOfMaterial/show_product-details.dart';

/// نموذج بيانات المادة
class Product {
  final String id;
  final String name;
  final int quantity;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.quantity,
    required this.image,
  });
}

/// شاشة عرض المواد في المستودع
class ShowProduct extends StatelessWidget {
  final Map<String, String> warehouse;

  const ShowProduct({super.key, required this.warehouse});

  @override
  Widget build(BuildContext context) {
    /// قائمة المواد - بيانات تجريبية (يمكنك لاحقًا استبدالها ببيانات API)
    final List<Product> products = [
      Product(
          id: "P101",
          name: "مادة تنظيف",
          quantity: 120,
          image: "https://picsum.photos/200?random=1"),
      Product(
          id: "P102",
          name: "قطع غيار",
          quantity: 50,
          image: "https://picsum.photos/200?random=2"),
      Product(
          id: "P103",
          name: "مواد غذائية",
          quantity: 300,
          image: "https://picsum.photos/200?random=3"),
      Product(
          id: "P104",
          name: "معدات كهربائية",
          quantity: 80,
          image: "https://picsum.photos/200?random=4"),
      Product(
          id: "P105",
          name: "زيوت صناعية",
          quantity: 60,
          image: "https://picsum.photos/200?random=5"),
      Product(
          id: "P106",
          name: "أجهزة قياس",
          quantity: 25,
          image: "https://picsum.photos/200?random=6"),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: Colors.white,
          title: Text(
            "مواد المستودع رقم ${warehouse["id"]}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: MyColors.orangeBasic,
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(10),
          itemCount: products.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            Color cardColor =
                index % 2 == 0 ? MyColors.background : MyColors.background2;
            final product = products[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetail(product: product),
                  ),
                );
              },
              child: Card(
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Hero(
                        tag: product.id,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            product.image,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "رقم المادة: ${product.id}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "الكمية المتاحة: ${product.quantity}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
