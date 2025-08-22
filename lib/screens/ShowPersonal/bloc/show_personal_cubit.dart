import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/screens/ShowPersonal/bloc/custdy_server_mangment.dart';

// States
abstract class CustodyState {}

class CustodyInitial extends CustodyState {}

class CustodyLoading extends CustodyState {}

class CustodyLoaded extends CustodyState {
  final List<Map<String, dynamic>> custodyData;
  CustodyLoaded(this.custodyData);
}

class CustodyError extends CustodyState {
  final String message;
  CustodyError(this.message);
}

// Cubit
class CustodyCubit extends Cubit<CustodyState> {
  final CustodyService custodyService;

  CustodyCubit(this.custodyService) : super(CustodyInitial());

  // دالة لتحميل العهدة من الـ API
  Future<void> loadCustody() async {
    emit(CustodyLoading());
    try {
      final data = await custodyService.fetchCustody();

      if (data['success']) {
        List<Map<String, dynamic>> custodyList = [];
        for (var item in data['data']) {
          custodyList.add(item);
        }
        emit(CustodyLoaded(custodyList));
      } else {
        emit(CustodyError(data['message']));
      }
    } catch (e) {
      emit(CustodyError("حدث خطأ أثناء جلب البيانات"));
    }
  }
}
