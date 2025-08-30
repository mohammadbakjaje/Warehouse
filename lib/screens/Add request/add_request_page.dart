import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:warehouse/helper/my_colors.dart';
import 'package:warehouse/screens/Add%20request/bloc/add_request_bloc.dart';
import 'package:warehouse/screens/Add%20request/bloc/add_request_event.dart';
import 'package:warehouse/screens/Add%20request/bloc/add_request_state.dart';
import 'package:warehouse/screens/Add%20request/bloc/server_maneger.dart'; // تأكد من استيراد الـ API

class AddRequestPage extends StatefulWidget {
  static String id = "AddRequestPage";

  @override
  _AddRequestPage createState() => _AddRequestPage();
}

class _AddRequestPage extends State<AddRequestPage> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  Map<String, dynamic>? selectedProduct;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          centerTitle: true,
          title: Text("طلب المواد"),
          backgroundColor: MyColors.orangeBasic,
        ),
        resizeToAvoidBottomInset: true, // تأكد من تجنب التداخل مع الكيبورد
        body: BlocProvider(
          create: (context) => AddRequestBloc(apiService: ApiService()),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<AddRequestBloc, AddRequestState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  // استخدام SingleChildScrollView للتمرير
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // حقل البحث لعرض المنتجات
                      Text('اسم المنتج',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TypeAheadFormField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: productNameController,
                          decoration: InputDecoration(
                            hintText: "ابحث عن منتج",
                            hintTextDirection:
                                TextDirection.rtl, // خلي الـ hint RTL
                            filled: true,
                            fillColor: MyColors.background2,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          textDirection:
                              TextDirection.rtl, // يضمن النص داخل الحقل RTL
                        ),
                        suggestionsCallback: (pattern) async {
                          if (pattern.isEmpty) return [];
                          try {
                            final apiService =
                                context.read<AddRequestBloc>().apiService;
                            return await apiService.searchProducts(pattern);
                          } catch (e) {
                            print("Error fetching suggestions: $e");
                            return [];
                          }
                        },
                        itemBuilder: (context, suggestion) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: ListTile(
                              title: Text(
                                suggestion['name'] ?? "No Name",
                                textAlign: TextAlign.right,
                              ),
                            ),
                          );
                        },
                        noItemsFoundBuilder: (context) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: Align(
                              alignment: Alignment
                                  .centerRight, // يخليها تبدأ من اليمين
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "لا يوجد مواد بهذا الاسم",
                                  textAlign: TextAlign.right, // محاذاة يمين
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          productNameController.text = suggestion['name'] ?? '';
                          selectedProduct = suggestion; // حفظ المنتج الكامل
                        },
                      ),
                      SizedBox(height: 16),
                      Text('الكمية',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextField(
                        controller: quantityController,
                        decoration: InputDecoration(
                          hintText: "أدخل الكمية",
                          filled: true,
                          fillColor: MyColors.background2,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16),
                      Text('ملاحظة',
                          style: TextStyle(fontWeight: FontWeight.bold)),
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
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectedProduct == null ||
                                selectedProduct!['id'] == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text("الرجاء اختيار منتج من القائمة")),
                              );
                              return;
                            }

                            if (quantityController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("الرجاء إدخال الكمية")),
                              );
                              return;
                            }

                            final regex = RegExp(r'^[0-9]+$');
                            if (!regex
                                .hasMatch(quantityController.text.trim())) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "الرجاء إدخال الكمية بأرقام إنجليزية فقط")),
                              );
                              return;
                            }
                            BlocProvider.of<AddRequestBloc>(context).add(
                              AddProductEvent(
                                productId: selectedProduct!['id'],
                                product: productNameController.text,
                                quantity: quantityController.text,
                                note: noteController.text,
                              ),
                            );

                            // تفريغ الحقول بعد الإضافة
                            productNameController.clear();
                            quantityController.clear();
                            noteController.clear();
                            selectedProduct = null;
                          },
                          child: Text(
                            "+ إضافة منتج",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.orangeBasic,
                            padding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap:
                            true, // ضروري لضمان أن الـ ListView لا يأخذ مساحة غير ضرورية
                        physics:
                            NeverScrollableScrollPhysics(), // منع التمرير داخل الـ ListView
                        itemCount: state is ProductAddedState
                            ? state.productRequests.length
                            : 0,
                        itemBuilder: (context, index) {
                          final product = state is ProductAddedState
                              ? state.productRequests[index]
                              : {};
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              title: Text(
                                'اسم المنتج: ${product["product"] ?? ""}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('الكمية: ${product["quantity"] ?? ""}'),
                                  Text('ملاحظة: ${product["note"] ?? ""}'),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  BlocProvider.of<AddRequestBloc>(context).add(
                                    DeleteProductEvent(index: index),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  BlocProvider.of<AddRequestBloc>(context)
                                      .add(ClearAllEvent());
                                },
                                child: Text('مسح الكل',
                                    style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyColors.orangeBasic,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  try {
                                    final bloc =
                                        BlocProvider.of<AddRequestBloc>(
                                            context);
                                    final api = bloc.apiService;

                                    if (bloc.productRequests.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "الرجاء إضافة منتج واحد على الأقل")),
                                      );
                                      return;
                                    }

                                    await api.submitRequest(
                                      date: DateTime.now()
                                          .toIso8601String()
                                          .split('T')
                                          .first,
                                      warehouseKeeperId: 1, // غيّره حسب الحاجة
                                      items: bloc.productRequests,
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("تم إرسال الطلب بنجاح")),
                                    );

                                    bloc.add(ClearAllEvent());
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("فشل في إرسال الطلب: $e")),
                                    );
                                  }
                                },
                                child: Text('تقديم الطلب',
                                    style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MyColors.orangeBasic,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
