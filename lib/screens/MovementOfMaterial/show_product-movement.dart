import 'package:flutter/material.dart';
import 'package:warehouse/helper/my_colors.dart';

class ShowProductMovement extends StatefulWidget {
  const ShowProductMovement({super.key});

  @override
  State<ShowProductMovement> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ShowProductMovement> {
  final int id = 101;
  final String name = "مادة تجريبية";
  final int quantity = 50;
  final String unit = "كغ";
  final String status = "متاح";

  int _currentIndex = 0;

  final List<Map<String, dynamic>> inputRecords = [
    {"date": "2025-08-01", "quantity": 20, "user": "أحمد"},
    {"date": "2025-08-10", "quantity": 15, "user": "خالد"},
    {"date": "2025-08-20", "quantity": 10, "user": "منى"},
  ];

  final List<Map<String, dynamic>> outputRecords = [
    {"date": "2025-08-05", "quantity": 5, "user": "سارة"},
    {"date": "2025-08-15", "quantity": 8, "user": "ليث"},
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
            /// خلفية نصف برتقالي ونصف أبيض
            Column(
              children: [
                Container(
                  height: size.height * 0.25,
                  color: orangeColor,
                ),
                Expanded(child: Container(color: Colors.white)),
              ],
            ),

            /// عنوان الصفحة
            Positioned(
              top: 40,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
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

            /// الكارد العلوي
            Positioned(
              top: size.height * 0.15,
              left: size.width * 0.05,
              right: size.width * 0.05,
              child: _buildInfoCard(size),
            ),

            /// الناف بار أسفل الكارد مباشرة
            Positioned(
              top: size.height * 0.33,
              left: (size.width - (size.width * 0.8)) / 2,
              child: _buildCustomNavBar(orangeColor, size),
            ),

            /// الكاردات مع سكرول
            Positioned.fill(
              top: size.height * 0.40,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  child: _buildMovementTable(
                    _currentIndex == 0 ? inputRecords : outputRecords,
                    isInput: _currentIndex == 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// الكارد العلوي
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
            offset: const Offset(0, 6),
          ),
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
              Column(
                children: [
                  const Text(
                    "الكمية",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    "$quantity",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(
                    "الوحدة",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    unit,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(
                    "الحالة",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: status == "متاح"
                          ? Colors.green
                          : (status == "منخفض" ? Colors.orange : Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// الكاردات البيضاء
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
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.1),
          child: Container(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// الرقم التسلسلي والنوع
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 4),
                        Text("الرقم التسلسلي: $index",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 4),
                        Text("النوع: $name",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 20, thickness: 1),

                /// الكمية قبل العملية
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.arrow_back, size: 18, color: Colors.grey),
                        SizedBox(width: 4),
                        Text("الكمية قبل العملية:",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Text("$previousQuantity $unit",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
                const SizedBox(height: 8),

                /// كمية العملية
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(isInput ? Icons.download : Icons.upload,
                            size: 18,
                            color: isInput ? Colors.green : Colors.red),
                        const SizedBox(width: 4),
                        Text(isInput ? "كمية الإدخال:" : "كمية الإخراج:",
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Text("$qty $unit",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
                const SizedBox(height: 8),

                /// الكمية بعد العملية
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.arrow_forward, size: 18, color: Colors.grey),
                        SizedBox(width: 4),
                        Text("الكمية بعد العملية:",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Text("$afterQuantity $unit",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
                const SizedBox(height: 8),

                /// الملاحظات
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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

  /// الناف بار السفلي
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
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavButton(
            index: 0,
            icon: Icons.download,
            label: "الإدخال",
            activeColor: orangeColor,
          ),
          _buildNavButton(
            index: 1,
            icon: Icons.upload,
            label: "الإخراج",
            activeColor: orangeColor,
          ),
        ],
      ),
    );
  }

  /// زر الناف بار
  Widget _buildNavButton({
    required int index,
    required IconData icon,
    required String label,
    required Color activeColor,
  }) {
    final bool isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? activeColor : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? activeColor : Colors.grey,
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
