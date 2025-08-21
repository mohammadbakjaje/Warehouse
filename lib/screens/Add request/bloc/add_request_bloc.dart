import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/screens/Add%20request/bloc/server_maneger.dart';
import 'add_request_event.dart';
import 'add_request_state.dart';

class AddRequestBloc extends Bloc<AddRequestEvent, AddRequestState> {
  final ApiService apiService;

  AddRequestBloc({required this.apiService}) : super(AddRequestInitial()) {
    // معالج الحدث AddProductEvent
    on<AddProductEvent>((event, emit) {
      // التحقق من الكمية
      if (event.quantity.trim().isEmpty) {
        emit(AddRequestErrorState(errorMessage: "الكمية مطلوبة"));
        return;
      }

      // التحقق من أن الكمية تحتوي فقط على أرقام إنجليزية
      final regex = RegExp(r'^[0-9]+$'); // يقبل فقط 0-9
      if (!regex.hasMatch(event.quantity)) {
        emit(AddRequestErrorState(
            errorMessage: "الرجاء إدخال الكمية بأرقام إنجليزية فقط"));
        return;
      }

      // إذا التحقق سليم → أضف المنتج
      productRequests.add({
        'product_id': event.productId.toString(),
        'product': event.product,
        'quantity': event.quantity,
        'note': event.note,
      });
      emit(ProductAddedState(productRequests: productRequests));
    });

    // معالج الحدث ClearAllEvent
    on<ClearAllEvent>((event, emit) {
      productRequests.clear();
      emit(ProductAddedState(productRequests: productRequests));
    });

    // معالج الحدث DeleteProductEvent
    on<DeleteProductEvent>((event, emit) {
      try {
        if (event.index >= 0 && event.index < productRequests.length) {
          productRequests.removeAt(event.index);
          emit(ProductAddedState(productRequests: productRequests));
        } else {
          throw Exception("Index out of range");
        }
      } catch (e) {
        print("Error deleting product: $e");
      }
    });

    // معالج الحدث SearchProductEvent (الذي يتعامل مع البحث في الـ API)
    on<SearchProductEvent>((event, emit) async {
      try {
        final products = await apiService.searchProducts(event.query);
        emit(ProductSearchState(products: products)); // تحديث الحالة بالمنتجات
      } catch (e) {
        emit(AddRequestErrorState(errorMessage: e.toString()));
      }
    });
  }

  List<Map<String, String>> productRequests = [];
}
