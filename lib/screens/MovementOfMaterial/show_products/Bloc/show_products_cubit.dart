import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/screens/MovementOfMaterial/show_products/Bloc/show_products_server.dart';
import 'package:warehouse/screens/MovementOfMaterial/show_products/Bloc/show_products_states.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductService productService;

  ProductCubit({required this.productService}) : super(ProductInitial());

  // Load product data and details
  Future<void> loadProducts(int warehouseId) async {
    try {
      emit(ProductLoading());
      final data = await productService.fetchProducts(warehouseId);
      if (data['success']) {
        // تحويل المنتجات إلى قائمة من الـ Map بشكل صحيح
        List<Map<String, dynamic>> products =
            List<Map<String, dynamic>>.from(data['data']['warehouse']['stock']);
        emit(ProductLoaded(products));
      } else {
        emit(ProductError('Failed to load product data'));
      }
    } catch (e) {
      emit(ProductError('Failed to load product data: $e'));
    }
  }
}
