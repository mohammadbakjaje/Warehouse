import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AddRequestPage extends StatefulWidget {
  static String id = "AddRequestPage";
  @override
  _AddRequestPage createState() => _AddRequestPage();
}

class _AddRequestPage extends State<AddRequestPage> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  List<Map<String, String>> productRequests = [];

  // قائمة المنتجات لاستخدامها في البحث
  List<String> products = ["منتج 1", "منتج 2", "منتج 3", "منتج 4"];

  // دالة لإضافة منتج إلى القائمة
  void addProduct() {
    setState(() {
      productRequests.add({
        'product': productNameController.text,
        'quantity': quantityController.text,
        'note': noteController.text,
      });

      // مسح الحقول بعد إضافة المنتج
      productNameController.clear();
      quantityController.clear();
      noteController.clear();
    });
  }

  // دالة لمسح جميع المنتجات في القائمة
  void clearAll() {
    setState(() {
      productRequests.clear();
    });
  }

  // دالة لتصفية المنتجات أثناء الكتابة
  List<String> _filterProducts(String query) {
    return products
        .where((product) => product.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text("طلب المواد"),
        backgroundColor: Colors.orange,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // حقل إدخال اسم المنتج مع تنسيق يشبه الصورة
              Text('اسم المنتج', style: TextStyle(fontWeight: FontWeight.bold)),
              TypeAheadFormField(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: productNameController,
                  decoration: InputDecoration(
                    hintText: "ابحث عن منتج",
                    filled: true,
                    fillColor: Colors.grey[200], // لون خلفية الحقل
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                suggestionsCallback: (pattern) {
                  return _filterProducts(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  productNameController.text = suggestion;
                },
              ),
              SizedBox(height: 16),

              // حقل إدخال الكمية مع تصميم يشبه الصورة
              Text('الكمية', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(
                  hintText: "أدخل الكمية",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixText: 'pcs',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),

              // حقل ملاحظة مع تنسيق مشابه للصورة
              Text('ملاحظة', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: noteController,
                decoration: InputDecoration(
                  hintText: "أضف ملاحظة",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 16),

              // زر إضافة منتج مع تصميم مشابه للصورة
              ElevatedButton(
                onPressed: addProduct,
                child: Text("+ إضافة منتج"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 16),

              // عرض المنتجات المضافة مع تصميم مشابه للصورة
              Expanded(
                child: ListView.builder(
                  itemCount: productRequests.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        title: Text(
                          'اسم المنتج: ${productRequests[index]["product"]}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'الكمية: ${productRequests[index]["quantity"]} pcs'),
                            Text('ملاحظة: ${productRequests[index]["note"]}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              productRequests.removeAt(index);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              // الأزرار لتقديم الطلب أو مسح الكل
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: clearAll,
                    child: Text('مسح الكل'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // منطق تقديم الطلب هنا
                    },
                    child: Text('تقديم الطلب'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
