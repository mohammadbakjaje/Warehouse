// notification_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/screens/Notes/Bloc/Note_manger.dart';
import 'package:warehouse/screens/Notes/Bloc/Note_states.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationService notificationService;

  NotificationCubit(this.notificationService) : super(NotificationInitial());

  Future<void> fetchNotifications() async {
    emit(NotificationLoading());
    try {
      final response = await notificationService.fetchNotifications();
      if (response != null) {
        emit(NotificationLoaded(response));
      } else {
        emit(NotificationError("لم يتم العثور على إشعارات"));
      }
    } catch (e) {
      emit(NotificationError("حدث خطأ أثناء جلب البيانات"));
    }
  }
}
