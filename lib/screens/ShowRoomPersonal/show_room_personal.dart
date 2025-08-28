import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/helper/my_colors.dart';
import 'package:warehouse/screens/ShowRoomPersonal/bloc/room_item_service.dart';
import 'package:warehouse/screens/ShowRoomPersonal/bloc/show_room_personal_cubit.dart';
import 'package:intl/intl.dart'; // لإدارة التاريخ

class ShowRoomPersonal extends StatelessWidget {
  static String id = "ShowRoomPersonal";
  final String roomNumber;
  final String building;
  final int custodyId;

  const ShowRoomPersonal({
    super.key,
    required this.roomNumber,
    required this.building,
    required this.custodyId,
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
          create: (context) =>
              RoomItemCubit(RoomItemService())..loadRoomItems(custodyId),
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
    TextEditingController notesController = TextEditingController();
    String returnDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Get the cubit before showing the dialog to avoid context issues
    final cubit = context.read<RoomItemCubit>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("إرجاع كمية من ${product["name"]}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // معلومات المادة
              ListTile(
                title: Text(
                  product["name"] ?? "اسم المنتج",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("الكمية المتاحة: ${item['quantity']}"),
                    Text("رمز المنتج: ${product["code"]}"),
                  ],
                ),
              ),

              // خط فاصل
              Divider(thickness: 1, color: Colors.grey[300]),

              // حقول الإدخال
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "الكمية المراد إرجاعها",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: notesController,
                decoration: InputDecoration(
                  labelText: "ملاحظات الإرجاع",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child:
                  Text("إلغاء", style: TextStyle(color: MyColors.orangeBasic)),
            ),
            ElevatedButton(
              onPressed: () async {
                // Parse the quantity as double
                double quantityToReturn =
                    double.tryParse(quantityController.text) ?? 0;

                // Parse the available quantity from item, ensuring it's a number
                double availableQuantity;
                if (item['quantity'] is String) {
                  availableQuantity = double.tryParse(item['quantity']) ?? 0;
                } else {
                  availableQuantity = (item['quantity'] as num).toDouble();
                }

                if (quantityToReturn <= 0 ||
                    quantityToReturn > availableQuantity) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text("الكمية غير صالحة")),
                  );
                  return;
                }

                try {
                  // إنشاء بيانات الإرجاع بشكل صحيح
                  final returnData = {
                    "return_date": returnDate,
                    "notes": notesController.text.isNotEmpty
                        ? notesController.text
                        : "إرجاع بدون ملاحظات",
                    "items": [
                      {
                        "custody_item_id": item['id'],
                        "returned_quantity": quantityToReturn,
                        "warehouse_id": 1,
                        "user_notes": notesController.text,
                      }
                    ],
                  };

                  print(
                      "Sending data: ${jsonEncode(returnData)}"); // Debug print

                  // إظهار مؤشر التحميل
                  showDialog(
                    context: dialogContext,
                    barrierDismissible: false,
                    builder: (BuildContext context) => Center(
                      child: CircularProgressIndicator(
                          color: MyColors.orangeBasic),
                    ),
                  );

                  // استدعاء API الإرجاع
                  final response =
                      await RoomItemService().returnItem(returnData);

                  // إغلاق مؤشر التحميل
                  Navigator.of(dialogContext).pop();

                  if (response['success'] == true) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("تم الإرجاع بنجاح")),
                    );

                    // إغلاق对话框 وتحديث البيانات
                    Navigator.of(dialogContext).pop();
                    cubit.loadRoomItems(custodyId);
                  } else {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(
                          content:
                              Text(response['message'] ?? "فشل في الإرجاع")),
                    );
                  }
                } catch (e) {
                  // إغلاق مؤشر التحميل في حالة الخطأ
                  if (Navigator.of(dialogContext).canPop()) {
                    Navigator.of(dialogContext).pop();
                  }

                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(content: Text("حدث خطأ: ${e.toString()}")),
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
