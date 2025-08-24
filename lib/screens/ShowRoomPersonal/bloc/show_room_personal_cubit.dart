import 'package:flutter_bloc/flutter_bloc.dart';
import 'room_item_service.dart';

// States
abstract class RoomItemState {}

class RoomItemInitial extends RoomItemState {}

class RoomItemLoading extends RoomItemState {}

class RoomItemLoaded extends RoomItemState {
  final List<Map<String, dynamic>> roomItems;
  RoomItemLoaded(this.roomItems);
}

class RoomItemError extends RoomItemState {
  final String message;
  RoomItemError(this.message);
}

// Cubit
class RoomItemCubit extends Cubit<RoomItemState> {
  final RoomItemService roomItemService;

  RoomItemCubit(this.roomItemService) : super(RoomItemInitial());

  // دالة لتحميل العناصر من الـ API بناءً على الـ custodyId
  Future<void> loadRoomItems(int custodyId) async {
    emit(RoomItemLoading());
    try {
      final data = await roomItemService.fetchRoomItems(custodyId);

      if (data['success']) {
        List<Map<String, dynamic>> itemsList = [];
        for (var item in data['data'][0]['items']) {
          // استخراج العناصر من البيانات
          itemsList.add(item);
        }
        emit(RoomItemLoaded(itemsList));
      } else {
        emit(RoomItemError(data['message']));
      }
    } catch (e) {
      emit(RoomItemError("حدث خطأ أثناء جلب البيانات"));
    }
  }
}
