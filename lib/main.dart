import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/helper/local_network.dart';
import 'package:warehouse/screens/Add%20request/add_request_page.dart';
import 'package:warehouse/screens/Login/bloc/login_cubit.dart';
import 'package:warehouse/screens/Login/log_in_screen.dart';
import 'package:warehouse/screens/Login/log_in_screen_for_warehouse_keeper.dart';
import 'package:warehouse/screens/MainUser/user_home.dart';
import 'package:warehouse/screens/MovementOfMaterial/Warehouses/warehouses.dart';

import 'package:warehouse/screens/NavBar/nav_bar_warehouse.dart';
import 'package:warehouse/screens/ShowLastRequest/BLOC/request_cubit.dart';
import 'package:warehouse/screens/ShowLastRequest/show_last_request.dart';
import 'package:warehouse/screens/ShowPersonal/show_personal.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheNetwork.cacheInitialization();
  runApp(const WarehouseApp());
}

class WarehouseApp extends StatelessWidget {
  const WarehouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => LoginCubit(),
        ),
        BlocProvider<RequestCubit>(
          create: (context) => RequestCubit(),
        ),
      ],
      child: MaterialApp(
        routes: {
          UserHome.id: (context) => UserHome(),
          LogInScreen.id: (context) => LogInScreen(),
          LogInScreenForWarehouseKeeper.id: (context) =>
              LogInScreenForWarehouseKeeper(),
          AddRequestPage.id: (context) => AddRequestPage(),
          ShowPersonal.id: (context) => ShowPersonal(),
          ShowLastRequest.id: (context) => ShowLastRequest(),
        },
        debugShowCheckedModeBanner: false,
        home: WareHouses(),
      ),
    );
  }
}
