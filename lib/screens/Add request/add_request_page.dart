import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:warehouse/helper/my_colors.dart';
import 'package:warehouse/screens/Add%20request/bloc/add_request_bloc.dart';
import 'package:warehouse/screens/Add%20request/bloc/add_request_event.dart';
import 'package:warehouse/screens/Add%20request/bloc/add_request_state.dart';
import 'package:warehouse/helper/constants.dart';
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
        child: BlocProvider(
          create: (context) => AddRequestBloc(apiService: ApiService()),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<AddRequestBloc, AddRequestState>(
              builder: (context, state) {
                return Column(
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
                          filled: true,
                          fillColor: MyColors.background2,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      suggestionsCallback: (pattern) async {
                        if (pattern.isEmpty) {
                          return [];
                        }
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
                        return ListTile(
                          title: Text(suggestion['name'] ?? "No Name"),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        productNameController.text = suggestion['name'] ?? '';
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
                          BlocProvider.of<AddRequestBloc>(context).add(
                            AddProductEvent(
                              product: productNameController.text,
                              quantity: quantityController.text,
                              note: noteController.text,
                            ),
                          );
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
                    Expanded(
                      child: ListView.builder(
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
                                  Text(
                                      'الكمية: ${product["quantity"] ?? ""} pcs'),
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
                              onPressed: () {
                                // منطق تقديم الطلب هنا
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
