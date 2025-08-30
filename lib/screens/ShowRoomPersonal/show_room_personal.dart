import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:warehouse/helper/my_colors.dart';
import 'package:warehouse/screens/ShowRoomPersonal/bloc/room_item_service.dart';
import 'package:warehouse/screens/ShowRoomPersonal/bloc/show_room_personal_cubit.dart';

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
                    final product = item['product']; // الوصول إلى بيانات المنتج
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
                              product["name"] ?? "اسم المنتج", // عرض اسم المنتج
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

  void _showReturnDialog(BuildContext context, dynamic item, dynamic product) {
    TextEditingController quantityController = TextEditingController();
    TextEditingController notesController = TextEditingController();
    String returnDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Get the cubit before showing the dialog to avoid context issues
    final cubit = context.read<RoomItemCubit>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text("إرجاع كمية من المادة:"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(thickness: 1, color: Colors.grey[700]),
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
                Divider(thickness: 1, color: Colors.grey[300]),
                // حقول الإدخال
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "الكمية المراد إرجاعها",
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color:
                              MyColors.orangeBasic), // تحديد اللون عند التركيز
                    ),
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  cursorColor: MyColors.orangeBasic,
                  controller: notesController,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.grey),
                    labelText: "ملاحظات الإرجاع",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: MyColors.orangeBasic)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color:
                              MyColors.orangeBasic), // تحديد اللون عند التركيز
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text("إلغاء",
                    style: TextStyle(color: MyColors.orangeBasic)),
              ),
              ElevatedButton(
                onPressed: () async {
                  // تحويل الكمية المدخلة إلى قيمة عددية (double)
                  double quantityToReturn =
                      double.tryParse(quantityController.text) ?? 0.0;

                  // التأكد من أن الكمية المدخلة صحيحة
                  double availableQuantity =
                      double.tryParse(item['quantity']) ?? 0.0;

                  // التأكد من أن الكمية المدخلة أقل من الكمية المتاحة
                  if (quantityToReturn <= 0 ||
                      quantityToReturn > availableQuantity) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(content: Text("الكمية غير صالحة")),
                    );
                    return;
                  }

                  // التأكد من تحويل المعرفات إلى أرقام صحيحة
                  int custodyItemId = item['id']; // المعرف الرقمي للعنصر
                  int warehouseId =
                      1; // افتراضياً أن المستودع هو 1، إذا كان مختلفاً تأكد من تغييره

                  // بيانات الإرجاع التي سيتم إرسالها
                  final returnData = {
                    "return_date": returnDate,
                    "notes": notesController.text.isNotEmpty
                        ? notesController.text
                        : "إرجاع بدون ملاحظات",
                    "items": [
                      {
                        "custody_item_id":
                            custodyItemId, // تأكد من أنه قيمة عددية
                        "returned_quantity":
                            quantityToReturn, // تأكد من أن الكمية عددية
                        "warehouse_id": warehouseId,
                        "user_notes": notesController.text,
                      }
                    ],
                  };

                  try {
                    // إرسال بيانات الإرجاع إلى الـ API
                    final response =
                        await RoomItemService().returnItem(returnData);

                    // التحقق من استجابة الـ API
                    if (response['success'] == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("تم الإرجاع بنجاح")),
                      );

                      // تحديث البيانات بعد الإرجاع
                      Navigator.of(dialogContext).pop();
                      cubit.loadRoomItems(custodyId);
                    } else {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        SnackBar(content: Text("${response['message']}")),
                      );
                    }
                  } catch (e) {
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
                child: Text(
                  "إرجاع",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
