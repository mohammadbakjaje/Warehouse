import 'package:flutter/material.dart';
import 'package:warehouse/helper/my_colors.dart';

class ShowProductMovement extends StatefulWidget {
  const ShowProductMovement({super.key});

  @override
  State<ShowProductMovement> createState() => _ShowProductMovementState();
}

class _ShowProductMovementState extends State<ShowProductMovement> {
  final String name = "مادة تجريبية";
  final int quantity = 50;
  final String unit = "كغ";
  final String status = "متاح";

  int _currentIndex = 0;

  // بيانات تجريبية جاهزة للتشغيل
  final List<Map<String, dynamic>> inputRecords = [
    {"date": "2025-08-01", "quantity": 20, "notes": "دفعة أولى"},
    {"date": "2025-08-10", "quantity": 15, "notes": "دفعة ثانية"},
    {"date": "2025-08-20", "quantity": 10},
  ];

  final List<Map<String, dynamic>> outputRecords = [
    {"date": "2025-08-05", "quantity": 5, "notes": "صادر للفرع أ"},
    {"date": "2025-08-15", "quantity": 8, "notes": "صادر للفرع ب"},
  ];

  @override
  Widget build(BuildContext context) {
    final Color orangeColor = MyColors.orangeBasic;
    final Size size = MediaQuery.of(context).size;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // خلفية نصف برتقالي ونصف أبيض
            Column(
              children: [
                Container(height: size.height * 0.25, color: orangeColor),
                Expanded(child: Container(color: Colors.white)),
              ],
            ),

            // عنوان الصفحة
            Positioned(
              top: 40,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white)),
                  const Expanded(
                    child: Text(
                      "تفاصيل المادة",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // الكارد العلوي
            Positioned(
              top: size.height * 0.15,
              left: size.width * 0.05,
              right: size.width * 0.05,
              child: _buildInfoCard(size),
            ),

            // ناف بار سفلي
            Positioned(
              top: size.height * 0.33,
              left: (size.width - (size.width * 0.8)) / 2,
              child: _buildCustomNavBar(orangeColor, size),
            ),

            // الكاردات
            Positioned.fill(
              top: size.height * 0.40,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: _buildMovementTable(
                      _currentIndex == 0 ? inputRecords : outputRecords,
                      isInput: _currentIndex == 0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // الكارد العلوي
  Widget _buildInfoCard(Size size) {
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
          Text(name,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Divider(thickness: 1, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text("الكمية",
                      style: TextStyle(fontSize: 14, color: Colors.black54)),
                  Text("$quantity",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                children: [
                  const Text("الوحدة",
                      style: TextStyle(fontSize: 14, color: Colors.black54)),
                  Text(unit,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                children: [
                  const Text("الحالة",
                      style: TextStyle(fontSize: 14, color: Colors.black54)),
                  Text(status,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: status == "متاح"
                              ? Colors.green
                              : (status == "منخفض"
                                  ? MyColors.orangeBasic
                                  : Colors.red))),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  // بناء الكاردات لكل حركة
  Widget _buildMovementTable(List<Map<String, dynamic>> records,
      {bool isInput = true}) {
    return Column(
      children: records.asMap().entries.map((entry) {
        int index = entry.key + 1;
        Map<String, dynamic> record = entry.value;
        int qty = (record["quantity"] as num).toInt();
        int previousQuantity = isInput ? (quantity - qty) : (quantity + qty);
        int afterQuantity =
            isInput ? previousQuantity + qty : previousQuantity - qty;

        return Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 6,
          shadowColor: Colors.black.withOpacity(0.15),
          child: Container(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الرقم التسلسلي والنوع
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      const SizedBox(width: 6),
                      Text("الرقم التسلسلي: $index",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ]),
                    Row(children: [
                      const SizedBox(width: 6),
                      Text("النوع: $name",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ]),
                  ],
                ),
                const Divider(height: 20, thickness: 1, color: Colors.black12),
                // كمية قبل العملية
                _buildQuantityRow(
                    "الكمية قبل :", previousQuantity, Colors.black),
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
                    Text("$qty $unit",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isInput ? Colors.green : Colors.red)),
                  ],
                ),
                const SizedBox(height: 8),
                // كمية بعد العملية
                _buildQuantityRow("الكمية بعد :", afterQuantity, Colors.black),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.note, size: 18, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text("الملاحظات: ${record["notes"] ?? "-"}",
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuantityRow(String label, int value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [
          const Icon(Icons.arrow_forward, size: 18, color: Colors.grey),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.grey)),
        ]),
        Text("$value $unit",
            style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  // ناف بار سفلي
  Widget _buildCustomNavBar(Color orangeColor, Size size) {
    return Container(
      width: size.width * 0.8,
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
          _buildNavButton(0, Icons.download, "الإدخال", orangeColor),
          _buildNavButton(1, Icons.upload, "الإخراج", orangeColor),
        ],
      ),
    );
  }

  Widget _buildNavButton(
      int index, IconData icon, String label, Color activeColor) {
    final bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color:
                isActive ? activeColor.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? activeColor : Colors.grey, size: 20),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    color: isActive ? activeColor : Colors.grey,
                    fontSize: 13,
                    fontWeight:
                        isActive ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}
