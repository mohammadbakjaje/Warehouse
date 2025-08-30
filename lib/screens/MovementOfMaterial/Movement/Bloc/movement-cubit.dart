import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/screens/MovementOfMaterial/Movement/Bloc/movement-state.dart';
import 'package:warehouse/screens/MovementOfMaterial/Movement/Bloc/movement_server_mangment.dart';
import 'package:warehouse/screens/MovementOfMaterial/Movement/product-movement-model.dart';

class ProductMovementCubit extends Cubit<ProductMovementState> {
  final ApiService apiService;
  final int productId;

  ProductMovementCubit({required this.apiService, required this.productId})
      : super(ProductMovementState(
          currentTab: 0,
          product: ProductMovement(
            id: productId,
            name: "جاري التحميل...",
            quantity: 0,
            unit: "كغ",
            status: "جاري التحميل...",
          ),
          inputRecords: [],
          outputRecords: [],
          isLoading: true,
        )) {
    loadData();
  }

  Future<void> loadData() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      // جلب بيانات حركات المنتج من API
      final response = await apiService.getProductMovements(productId);

      if (response.success) {
        // فصل السجلات إلى مدخلات ومخرجات
        final inputRecords =
            response.data.where((record) => record.type == 'entry').toList();

        final outputRecords =
            response.data.where((record) => record.type == 'exit').toList();

        // حساب الكمية الحالية (آخر كمية بعد)
        final currentQuantity =
            response.data.isNotEmpty ? response.data.last.afterQuantity : 0;

        // تحديث حالة المنتج
        final updatedProduct = ProductMovement(
          id: productId,
          name: "اسم المنتج", // يمكن جلب هذا من API آخر إذا كان متوفراً
          quantity: currentQuantity,
          unit: "كغ", // يمكن جلب هذا من API آخر إذا كان متوفراً
          status: currentQuantity > 0 ? "متاح" : "غير متاح",
        );

        emit(state.copyWith(
          isLoading: false,
          product: updatedProduct,
          inputRecords: inputRecords,
          outputRecords: outputRecords,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: "فشل في جلب البيانات: ${response.message}",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: "حدث خطأ أثناء جلب البيانات: $e",
      ));
    }
  }

  void changeTab(int index) {
    emit(state.copyWith(currentTab: index));
  }
}
