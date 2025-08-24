import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/helper/my_colors.dart';
import 'package:warehouse/screens/ShowPersonal/bloc/show_personal_cubit.dart';
import 'package:warehouse/screens/ShowRoomPersonal/show_room_personal.dart';
import 'package:warehouse/screens/ShowPersonal/bloc/custdy_server_mangment.dart';

class ShowPersonal extends StatelessWidget {
  static String id = "ShowPersonal";

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
          create: (context) => CustodyCubit(CustodyService())..loadCustody(),
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
                    final roomId = room['id']; // id of the custody
                    final notes = room['notes'] ?? "ملاحظة غير موجودة";

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowRoomPersonal(
                              custodyId: roomId, // passing the custodyId
                              roomNumber: roomId != null
                                  ? "العهدة رقم: $roomId"
                                  : "العهدة رقم غير موجودة",
                              building: notes, // passing notes of custody
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
                            "العهدة رقم: $roomId",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            notes,
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
      ),
    );
  }
}
