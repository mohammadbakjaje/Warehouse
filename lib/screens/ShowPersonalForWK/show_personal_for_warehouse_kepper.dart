import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/helper/my_colors.dart';
import 'package:warehouse/screens/ShowPersonalForWK/Bloc/show_personal_cubit.dart';
import 'package:warehouse/screens/ShowPersonalForWK/Bloc/show_personal_server_mangent.dart';
import 'package:warehouse/screens/ShowPersonalForWK/Bloc/show_personal_states.dart';
import 'package:warehouse/screens/ShowPersonalForWK/show-details_personal_wk.dart';

class ShowPersonalForWarehouseKepper extends StatelessWidget {
  const ShowPersonalForWarehouseKepper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ShowPersonalCubit(custodyService: CustodyWKService()),
      child: const ShowPersonalView(),
    );
  }
}

class ShowPersonalView extends StatelessWidget {
  const ShowPersonalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "العهد الشخصية لجميع الموظفين",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: MyColors.orangeBasic,
        ),
        body: BlocBuilder<ShowPersonalCubit, ShowPersonalState>(
          builder: (context, state) {
            if (state is ShowPersonalLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ShowPersonalError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ShowPersonalCubit>().loadCustody();
                      },
                      child: const Text("إعادة المحاولة"),
                    ),
                  ],
                ),
              );
            } else if (state is ShowPersonalLoaded) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search_rounded),
                        hintText: "ابحث باسم صاحب العهدة...",
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        context
                            .read<ShowPersonalCubit>()
                            .updateSearchQuery(value);
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: state.filteredCustody.length,
                      itemBuilder: (context, index) {
                        Color cardColor = index % 2 == 0
                            ? MyColors.background
                            : MyColors.background2;
                        final custody = state.filteredCustody[index];

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ShowDetailsPersonalWkDetailsPage(
                                  custody: custody,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            color: cardColor,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "العهدة: ${custody['id']}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text("رقم الغرفة: ${custody['room']}"),
                                  Text("اسم صاحب العهدة: ${custody['owner']}"),
                                  const SizedBox(height: 6),
                                  Text(
                                    "الملاحظات: ${custody['notes']}",
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('البيانات غير متوفرة'));
            }
          },
        ),
      ),
    );
  }
}
