import 'package:flutter/material.dart';
import 'package:warehouse/helper/my_colors.dart';
import 'package:warehouse/screens/MovementOfMaterial/show_product-movement.dart';

class ProductsRepository {
  static Future<List<Map<String, dynamic>>> fetchProducts(
      int warehouseId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    List<String> productNames = [
      "مسمار حديد",
      "لوح خشب",
      "صامولة",
      "مسامير خشبية",
      "مسطرة حديد",
    ];

    return List.generate(productNames.length, (index) {
      return {
        "name": productNames[index],
        "date": "2025-08-${10 + index}",
      };
    });
  }
}

class ProductsPage extends StatefulWidget {
  final int warehouseId;
  final String warehouseLocation;

  const ProductsPage({
    super.key,
    required this.warehouseId,
    required this.warehouseLocation,
  });

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    products = await ProductsRepository.fetchProducts(widget.warehouseId);
    setState(() {
      isLoading = false;
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color orangeColor = MyColors.orangeBasic;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  color: orangeColor,
                  alignment: Alignment.center,
                  child: Text(
                    "منتجات المستودع ${widget.warehouseId}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(child: Container(color: Colors.grey[200])),
              ],
            ),
            // كروت المنتجات
            Positioned.fill(
              top: 180,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final animation = Tween<Offset>(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _controller,
                            curve: Interval(
                              (index * 0.2),
                              1.0,
                              curve: Curves.easeOut,
                            ),
                          ),
                        );

                        return FadeTransition(
                          opacity: _controller,
                          child: SlideTransition(
                            position: animation,
                            child: _buildProductCard(
                                product, orangeColor, context),
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

  Widget _buildProductCard(
      Map<String, dynamic> product, Color orangeColor, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ShowProductMovement(
                // id: product['id'],
                // name: product['name'],
                // quantity: product['quantity'],
                // unit: product['unit'], // تأكد أنه موجود بالداتا
                // status: product['status'], // تأكد أنه موجود بالداتا
                ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // كود المادة أعلى الكارت على اليسار بخط صغير
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "QRpqr ${product['id']}",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 6),
            // اسم المنتج بخط عريض
            Text(
              product['name'],
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 8),
            const Divider(color: Colors.black12),
            const SizedBox(height: 8),
            // التاريخ
            Row(
              children: [
                Icon(Icons.date_range, color: orangeColor, size: 22),
                const SizedBox(width: 6),
                Text("تاريخ الإضافة: ${product['date']}",
                    style: const TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
