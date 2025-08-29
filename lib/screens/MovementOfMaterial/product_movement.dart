import 'package:flutter/material.dart';
import 'package:warehouse/helper/my_colors.dart';
import 'package:warehouse/screens/MovementOfMaterial/show_product.dart';

class ProductMovement extends StatefulWidget {
  const ProductMovement({super.key});

  @override
  State<ProductMovement> createState() => _ProductMovementState();
}

class _ProductMovementState extends State<ProductMovement>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> warehouses = [];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _loadWarehouses();
  }

  Future<void> _loadWarehouses() async {
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      warehouses = [
        {"id": 1, "location": "دمشق - البرامكة", "products": 150},
        {"id": 2, "location": "حلب - العزيزية", "products": 200},
        {"id": 3, "location": "حمص - بابا عمرو", "products": 120},
        {"id": 4, "location": "اللاذقية - الكورنيش", "products": 300},
      ];
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
            // الخلفية البرتقالية والبيضاء
            Column(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  color: orangeColor,
                  alignment: Alignment.center,
                  child: const Text(
                    'قائمة المستودعات',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(child: Container(color: Colors.grey[200])),
              ],
            ),

            // الكروت الطافية فوق البرتقالي والأبيض
            Positioned.fill(
              top: 180,
              child: warehouses.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: warehouses.length,
                      itemBuilder: (context, index) {
                        final warehouse = warehouses[index];
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
                            child: _buildCard(warehouse, orangeColor, context),
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

  Widget _buildCard(
      Map<String, dynamic> warehouse, Color orangeColor, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "المستودع ${warehouse['id']}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(color: Colors.black12),
            Row(
              children: [
                Icon(Icons.location_on, color: orangeColor, size: 22),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    "الموقع: ${warehouse['location']}",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.inventory_2_outlined, color: orangeColor, size: 22),
                const SizedBox(width: 6),
                Text(
                  "عدد المنتجات: ${warehouse['products']}",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: orangeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductsPage(
                        warehouseId: warehouse['id'],
                        warehouseLocation: warehouse['location'],
                      ),
                    ),
                  );
                },
                child: const Text(
                  'عرض المنتجات',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WarehouseProductsPage {}
