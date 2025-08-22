import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/helper/my_colors.dart';
import 'package:warehouse/screens/ShowPersonal/bloc/custdy_server_mangment.dart';
import 'package:warehouse/screens/ShowPersonal/bloc/show_personal_cubit.dart';
import 'package:warehouse/screens/ShowRoomPersonal/show_room_personal.dart';

class ShowPersonal extends StatelessWidget {
  static String id = "ShowPersonal";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          "العهد الشخصية للموظف",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: MyColors.orangeBasic,
        elevation: 1,
      ),
      body: BlocProvider(
        create: (context) => CustodyCubit(CustodyService())
          ..loadCustody(), // استخدام الـ Cubit و الـ Service
        child: BlocBuilder<CustodyCubit, CustodyState>(
          builder: (context, state) {
            if (state is CustodyLoading) {
              return Center(
                  child:
                      CircularProgressIndicator(color: MyColors.orangeBasic));
            } else if (state is CustodyError) {
              return Center(child: Text(state.message));
            } else if (state is CustodyLoaded) {
              final rooms = state.custodyData;
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  Color cardColor = index % 2 == 0
                      ? MyColors.background
                      : MyColors.background2;
                  final room = rooms[index];
                  final roomId = room['room_id'];
                  return GestureDetector(
                    onTap: () {
                      // إذا كان room_id null, عرض العهدة رقم id
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowRoomPersonal(
                            roomNumber: roomId != null
                                ? "الغرفة رقم: $roomId"
                                : "العهدة رقم: ${room['id']}",
                            building: room['notes'] ??
                                "", // يمكنك تعديل هذا بناءً على كيفية عرض الملاحظات
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        title: Text(
                          roomId != null
                              ? "الغرفة رقم: $roomId"
                              : "العهدة رقم: ${room['id']}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          room['notes'] ?? "ملاحظة غير موجودة",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            color: Colors.black, size: 18),
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
    );
  }
}
