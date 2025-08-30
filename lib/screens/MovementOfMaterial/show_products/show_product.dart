import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/helper/constants.dart';
import 'package:warehouse/helper/my_colors.dart';
import 'package:warehouse/screens/MovementOfMaterial/Movement/movement_material.dart';

import 'package:warehouse/screens/MovementOfMaterial/show_products/Bloc/show_products_cubit.dart';
import 'package:warehouse/screens/MovementOfMaterial/show_products/Bloc/show_products_server.dart';
import 'package:warehouse/screens/MovementOfMaterial/show_products/Bloc/show_products_states.dart';
import 'package:warehouse/screens/MovementOfMaterial/show_products/show_product.dart';

class ProductsPage extends StatelessWidget {
  final int warehouseId;
  final String warehouseLocation;

  const ProductsPage({
    super.key,
    required this.warehouseId,
    required this.warehouseLocation,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductCubit(productService: ProductService())
        ..loadProducts(warehouseId),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    color: MyColors.orangeBasic,
                    alignment: Alignment.center,
                    child: const Text(
                      'قائمة المنتجات',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(color: Colors.grey[200]),
                  ),
                ],
              ),
              Positioned.fill(
                top: 180,
                child: BlocBuilder<ProductCubit, ProductState>(
                  builder: (context, state) {
                    if (state is ProductLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ProductLoaded) {
                      final products = state.products;
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return _buildCard(
                              product, MyColors.orangeBasic, context);
                        },
                      );
                    } else if (state is ProductError) {
                      return Center(child: Text(state.message));
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
      Map<String, dynamic> product, Color orangeColor, BuildContext context) {
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
              "${product['product']['name']}",
              style: TextStyle(
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
                    "اسم المنتج: ${product['product']['name']}",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.date_range, color: orangeColor, size: 22),
                const SizedBox(width: 6),
                Text(
                  "تاريخ الانشاء: ${formatDate(product['product']['created_at'])}",
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
                  final int id = product['product']['id'] as int;
                  final String? name = product['product']['name']?.toString();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ShowProductMovement(
                        productId: id,
                        productNameHint: name, // اختياري لعرضه أثناء التحميل
                      ),
                    ),
                  );
                },
                child: const Text(
                  'عرض تفاصيل المنتج',
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
