// warehouse_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:warehouse/screens/MovementOfMaterial/Warehouses/Bloc/warehouses-server-mangmet.dart';
import 'package:warehouse/screens/MovementOfMaterial/Warehouses/Bloc/warehouses_states.dart';

class WarehouseCubit extends Cubit<WarehouseState> {
  final WarehouseService warehouseService;

  WarehouseCubit({required this.warehouseService}) : super(WarehouseInitial());

  Future<void> loadWarehouses() async {
    emit(WarehouseLoading());
    try {
      final warehouses = await warehouseService.fetchWarehouses();
      emit(WarehouseLoaded(warehouses: warehouses));
    } catch (e) {
      emit(WarehouseError(message: e.toString()));
    }
  }
}
