import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/helper/my_colors.dart';
import 'package:warehouse/screens/ShowRoomPersonal/bloc/room_item_service.dart';
import 'package:warehouse/screens/ShowRoomPersonal/bloc/show_room_personal_cubit.dart'; // لجلب البيانات

class ShowRoomPersonal extends StatelessWidget {
  static String id = "ShowRoomPersonal";

  final String roomNumber;
  final String building;
  final int custodyId; // custodyId لاستقبال الـ ID

  const ShowRoomPersonal({
    super.key,
    required this.roomNumber,
    required this.building,
    required this.custodyId, // استقبال custodyId
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: MyColors.background,
        appBar: AppBar(
          backgroundColor: MyColors.orangeBasic,
          foregroundColor: Colors.white,
          title: Text(" $roomNumber"),
          centerTitle: true,
        ),
        body: BlocProvider(
          create: (context) => RoomItemCubit(RoomItemService())
            ..loadRoomItems(custodyId), // تمرير custodyId
          child: BlocBuilder<RoomItemCubit, RoomItemState>(
            builder: (context, state) {
              if (state is RoomItemLoading) {
                return Center(
                    child:
                        CircularProgressIndicator(color: MyColors.orangeBasic));
              } else if (state is RoomItemError) {
                return Center(child: Text(state.message));
              } else if (state is RoomItemLoaded) {
                final items = state.roomItems;
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final product = item['product'];
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
                              product["name"] ?? "اسم المنتج",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text("رمز المنتج: ${product["code"]}"),
                            Text("الكمية: ${item["quantity"]}"),
                            Text("ملاحظة الخروج: ${item["notes"]}"),
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
                                    _showReturnDialog(context, item, product);
                                  },
                                  child: const Text("إرجاع المادة"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: Text("لا توجد بيانات"));
              }
            },
          ),
        ),
      ),
    );
  }

  // Method to show the dialog for quantity input
  void _showReturnDialog(BuildContext context, dynamic item, dynamic product) {
    TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("إرجاع كمية من ${product["name"]}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("الكمية المتاحة: ${item['quantity']}"),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "الكمية التي تريد إرجاعها",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "إلغاء",
                style: TextStyle(
                  color: MyColors.orangeBasic,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                int quantityToReturn =
                    int.tryParse(quantityController.text) ?? 0;
                if (quantityToReturn > 0 &&
                    quantityToReturn <= item['quantity']) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "تم إرجاع المادة ${product["name"]} بكمية: $quantityToReturn"),
                    ),
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text("الكمية غير صحيحة. الرجاء التحقق من الإدخال."),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.orangeBasic,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("إرجاع"),
            ),
          ],
        );
      },
    );
  }
}
