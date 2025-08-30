import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // استيراد مكتبة intl
import 'package:warehouse/helper/constants.dart';
import 'package:warehouse/helper/my_colors.dart';
import 'package:warehouse/screens/ShowLastRequest/BLOC/request_cubit.dart';

class ShowLastRequest extends StatelessWidget {
  static String id = "ShowLastRequest";

  @override
  Widget build(BuildContext context) {
    // استدعاء البيانات عند بداية تحميل الشاشة
    context.read<RequestCubit>().fetchRequests();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.orangeBasic,
          foregroundColor: Colors.white,
          title: Text(
            "الطلبات السابقة",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        // تحديد اتجاه النص من اليمين لليسار
        body: BlocBuilder<RequestCubit, RequestState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Center(
                  child:
                      CircularProgressIndicator(color: MyColors.orangeBasic));
            }

            if (state.error.isNotEmpty) {
              return Center(child: Text(state.error));
            }

            return Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      // يضمن أن ListView يملأ المساحة المتاحة بشكل كامل
                      child: ListView.builder(
                        itemCount: state.requests.length,
                        itemBuilder: (context, index) {
                          Color cardColor = index % 2 == 0
                              ? MyColors.background
                              : MyColors.background2;

                          String formattedDate =
                              formatDate(state.requests[index]["date"]!);

                          return Card(
                            color: cardColor,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'الطلب ${state.requests[index]["id"]}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'التاريخ: $formattedDate',
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Text(
                                    'الحالة: ${state.requests[index]["status"]}',
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // دالة لتحويل التاريخ إلى التنسيق المطلوب
}
