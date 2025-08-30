import 'package:warehouse/screens/MovementOfMaterial/Movement/product-movement-model.dart';

class ProductMovementState {
  final int currentTab;
  final ProductMovement product;
  final List<MovementRecord> inputRecords;
  final List<MovementRecord> outputRecords;
  final bool isLoading;
  final String? error;

  ProductMovementState({
    required this.currentTab,
    required this.product,
    required this.inputRecords,
    required this.outputRecords,
    this.isLoading = false,
    this.error,
  });

  ProductMovementState copyWith({
    int? currentTab,
    ProductMovement? product,
    List<MovementRecord>? inputRecords,
    List<MovementRecord>? outputRecords,
    bool? isLoading,
    String? error,
  }) {
    return ProductMovementState(
      currentTab: currentTab ?? this.currentTab,
      product: product ?? this.product,
      inputRecords: inputRecords ?? this.inputRecords,
      outputRecords: outputRecords ?? this.outputRecords,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
