import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/screens/ShowLastRequest/BLOC/request_maneger.dart';

// تعريف الحالة
class RequestState {
  final List<Map<String, String>> requests;
  final bool isLoading;
  final String error;

  RequestState({
    required this.requests,
    this.isLoading = false,
    this.error = "",
  });
}

// تعريف **Cubit**
class RequestCubit extends Cubit<RequestState> {
  RequestCubit() : super(RequestState(requests: []));

  Future<void> fetchRequests() async {
    emit(RequestState(requests: [], isLoading: true)); // عرض حالة التحميل

    try {
      final requests = await RequestManager
          .fetchRequests(); // استخدام RequestManager لجلب البيانات
      emit(RequestState(requests: requests)); // تحديث الحالة
    } catch (e) {
      emit(RequestState(requests: [], error: e.toString())); // في حالة وجود خطأ
    }
  }
}
