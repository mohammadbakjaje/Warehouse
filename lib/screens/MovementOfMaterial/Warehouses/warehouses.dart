import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/helper/constants.dart';
import 'package:warehouse/helper/my_colors.dart';
import 'package:warehouse/screens/MovementOfMaterial/Warehouses/Bloc/warehouses-server-mangmet.dart';
import 'package:warehouse/screens/MovementOfMaterial/Warehouses/Bloc/warehouses_cubit.dart';
import 'package:warehouse/screens/MovementOfMaterial/Warehouses/Bloc/warehouses_states.dart';

class WareHouses extends StatelessWidget {
  const WareHouses({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WarehouseCubit(warehouseService: WarehouseService())
        ..loadWarehouses(),
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
                      'قائمة المستودعات',
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
                child: BlocBuilder<WarehouseCubit, WarehouseState>(
                  builder: (context, state) {
                    if (state is WarehouseLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is WarehouseLoaded) {
                      final warehouses = state.warehouses;
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemCount: warehouses.length,
                        itemBuilder: (context, index) {
                          final warehouse = warehouses[index];
                          return _buildCard(
                              warehouse, MyColors.orangeBasic, context);
                        },
                      );
                    } else if (state is WarehouseError) {
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
                    "الموقع: ${warehouse['location']}",
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
                  "تاريخ الانشاء: ${formatDate(warehouse['created_at'])}",
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
                // onPressed: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (_) => WarehouseDetailsPage(
                //         id: warehouse['id'],
                //         location: warehouse['location'],
                //         name: warehouse['name'],
                //       ),
                //     ),
                //   );
                // },
                onPressed: () {},
                child: const Text(
                  'عرض',
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
