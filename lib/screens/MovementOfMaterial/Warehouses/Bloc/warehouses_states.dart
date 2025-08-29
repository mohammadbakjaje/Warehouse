// warehouse_state.da
abstract class WarehouseState {}

class WarehouseInitial extends WarehouseState {}

class WarehouseLoading extends WarehouseState {}

class WarehouseLoaded extends WarehouseState {
  final List<Map<String, dynamic>> warehouses;

  WarehouseLoaded({required this.warehouses});
}

class WarehouseError extends WarehouseState {
  final String message;

  WarehouseError({required this.message});
}
