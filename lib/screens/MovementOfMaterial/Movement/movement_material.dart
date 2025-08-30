import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/helper/my_colors.dart';
import 'package:warehouse/helper/constants.dart';
import 'package:warehouse/screens/MovementOfMaterial/Movement/Bloc/movement-cubit.dart';
import 'package:warehouse/screens/MovementOfMaterial/Movement/Bloc/movement-state.dart';
import 'package:warehouse/screens/MovementOfMaterial/Movement/Bloc/movement_server_mangment.dart';
import 'package:warehouse/screens/MovementOfMaterial/Movement/product-movement-model.dart';

class ShowProductMovement extends StatelessWidget {
  final int productId;
  final String? productNameHint; // اختياري لعرض اسم أثناء التحميل

  const ShowProductMovement({
    super.key,
    required this.productId,
    this.productNameHint,
  });

  @override
  Widget build(BuildContext context) {
    final Color orangeColor = MyColors.orangeBasic;

    return BlocProvider(
      create: (_) => ProductMovementCubit(
        apiService: ApiService(
            baseUrl: BaseUrl), // تأكد أن BaseUrl موجود بـ helper/constants.dart
        productId: productId,
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocBuilder<ProductMovementCubit, ProductMovementState>(
            builder: (context, state) {
              final size = MediaQuery.of(context).size;

              // حالات التحميل/الخطأ
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.error != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      state.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                );
              }

              // البيانات الجاهزة
              final product = state.product;
              final isInputTab = state.currentTab == 0;
              final records =
                  isInputTab ? state.inputRecords : state.outputRecords;

              return Stack(
                children: [
                  // خلفية نصف برتقالي ونصف أبيض
                  Column(
                    children: [
                      Container(height: size.height * 0.25, color: orangeColor),
                      Expanded(child: Container(color: Colors.white)),
                    ],
                  ),

                  // عنوان
                  Positioned(
                    top: 40,
                    left: 16,
                    right: 16,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const Expanded(
                          child: Text(
                            "تفاصيل المادة",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),

                  // الكارد العلوي (معلومات المنتج)
                  Positioned(
                    top: size.height * 0.15,
                    left: size.width * 0.05,
                    right: size.width * 0.05,
                    child: _InfoCard(
                      name: productNameHint ?? "المنتج #$productId",
                      quantity: product.quantity,
                      unit: product.unit,
                      status: product.status,
                    ),
                  ),

                  // تاب بار
                  Positioned(
                    top: size.height * 0.33,
                    left: (size.width - (size.width * 0.8)) / 2,
                    child: _NavBar(
                      currentIndex: state.currentTab,
                      onChange: (i) =>
                          context.read<ProductMovementCubit>().changeTab(i),
                      orangeColor: orangeColor,
                      width: size.width * 0.8,
                    ),
                  ),

                  // جدول الحركات
                  Positioned.fill(
                    top: size.height * 0.40,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SingleChildScrollView(
                        child: _MovementList(
                          records: records,
                          unit: product.unit,
                          isInput: isInputTab,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// كارد معلومات المنتج
class _InfoCard extends StatelessWidget {
  final String name;
  final int quantity;
  final String unit;
  final String status;

  const _InfoCard({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Divider(thickness: 1, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _miniStat(title: "الكمية", value: "$quantity"),
              _miniStat(title: "الوحدة", value: unit),
              _miniStat(
                title: "الحالة",
                value: status,
                valueColor: status == "متاح"
                    ? Colors.green
                    : (status == "منخفض" ? MyColors.orangeBasic : Colors.red),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _miniStat(
      {required String title, required String value, Color? valueColor}) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(fontSize: 14, color: Colors.black54)),
        Text(
          value,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black),
        ),
      ],
    );
  }
}

// شريط التبديل إدخال/إخراج
class _NavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChange;
  final Color orangeColor;
  final double width;
  const _NavBar({
    required this.currentIndex,
    required this.onChange,
    required this.orangeColor,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _btn(index: 0, icon: Icons.download, label: "الإدخال"),
          _btn(index: 1, icon: Icons.upload, label: "الإخراج"),
        ],
      ),
    );
  }

  Widget _btn(
      {required int index, required IconData icon, required String label}) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onChange(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? orangeColor.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? orangeColor : Colors.grey, size: 20),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? orangeColor : Colors.grey,
                fontSize: 13,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// قائمة الحركات (تعتمد على MovementRecord القادم من الـ API)
class _MovementList extends StatelessWidget {
  final List<MovementRecord> records;
  final String unit;
  final bool isInput;

  const _MovementList({
    required this.records,
    required this.unit,
    required this.isInput,
  });

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 32.0),
        child: Center(child: Text('لا توجد حركات بعد')),
      );
    }

    return Column(
      children: records.asMap().entries.map((entry) {
        final idx = entry.key + 1;
        final r = entry.value;

        // لدينا من الـ API قيم: prvQuantity, noteQuantity, afterQuantity
        // فلا حاجة لحسابات افتراضية.
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 6,
          shadowColor: Colors.black.withOpacity(0.15),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // رقم تسلسلي ومرجع
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("الرقم التسلسلي: $idx",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("المرجع: ${r.referenceSerial}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const Divider(height: 20, thickness: 1, color: Colors.black12),

                // التاريخ
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("التاريخ:",
                        style: TextStyle(color: Colors.grey)),
                    Text(_date(r.date),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),

                // قبل العملية
                _qtyRow("الكمية قبل :", r.prvQuantity, Colors.black, unit),

                const SizedBox(height: 8),

                // كمية العملية مع أيقونة
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Icon(isInput ? Icons.download : Icons.upload,
                          size: 20, color: isInput ? Colors.green : Colors.red),
                      const SizedBox(width: 6),
                      Text(isInput ? "كمية الإدخال:" : "كمية الإخراج:",
                          style: const TextStyle(color: Colors.grey)),
                    ]),
                    Text("${r.noteQuantity} $unit",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isInput ? Colors.green : Colors.red)),
                  ],
                ),

                const SizedBox(height: 8),

                // بعد العملية
                _qtyRow("الكمية بعد :", r.afterQuantity, Colors.black, unit),

                const SizedBox(height: 8),

                // ملاحظات
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.note, size: 18, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text("الملاحظات: ${r.notes ?? "-"}",
                          style: const TextStyle(color: Colors.grey)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  static String _date(DateTime d) {
    // 2025-08-30 شكل بسيط
    final two = (int n) => n.toString().padLeft(2, '0');
    return "${d.year}-${two(d.month)}-${two(d.day)}";
  }

  static Widget _qtyRow(String label, int value, Color color, String unit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: const [
          Icon(Icons.arrow_forward, size: 18, color: Colors.grey),
          SizedBox(width: 4),
        ]),
        Expanded(
            child: Text(label, style: const TextStyle(color: Colors.grey))),
        Text("$value $unit",
            style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
