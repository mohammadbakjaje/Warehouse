import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/ProfilePage/Bloc/profile-manager.dart';
import 'package:warehouse/ProfilePage/Bloc/profile-states.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit()
      : super(ProfileState(
          gender: 'أنثى',
          facebookAccount: '',
          address: '',
          birthDate: DateTime.now(),
          isEditing: false,
        )) {
    // جلب بيانات المستخدم عند التهيئة
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    emit(state.copyWith(isLoading: true, errorMessage: ''));

    final result = await ApiManager.fetchUserProfile();

    if (result['success']) {
      final userData = result['data'];
      emit(state.copyWith(
        isLoading: false,
        userData: userData,
        // يمكنك تعيين القيم من API هنا إذا كانت متوفرة
        // gender: userData['gender'] ?? state.gender,
        // address: userData['address'] ?? state.address,
      ));
    } else {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: result['message'],
      ));
    }
  }

  void toggleEditMode() {
    if (state.isEditing) {
      // حفظ التعديلات
      _saveProfileChanges();
    } else {
      // الدخول في وضع التعديل
      emit(state.copyWith(isEditing: true, statusMessage: ''));
    }
  }

  Future<void> _saveProfileChanges() async {
    emit(state.copyWith(isLoading: true, errorMessage: ''));

    // إعداد بيانات الملف الشخصي للإرسال
    final profileData = {
      'gender': state.gender,
      'facebook_account': state.facebookAccount,
      'address': state.address,
      'birth_date': state.birthDate.toIso8601String(),
      // أضف حقول أخرى حسب ما يتطلبه API
    };

    final result = await ApiManager.updateUserProfile(profileData);

    if (result['success']) {
      emit(state.copyWith(
        isLoading: false,
        isEditing: false,
        statusMessage: result['message'],
        userData: {...state.userData, ...result['data']},
      ));
    } else {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: result['message'],
      ));
    }
  }

  void cancelEdit() {
    emit(state.copyWith(isEditing: false, statusMessage: ''));
  }

  void updateGender(String newGender) {
    emit(state.copyWith(gender: newGender));
  }

  void updateFacebookAccount(String newFacebookAccount) {
    emit(state.copyWith(facebookAccount: newFacebookAccount));
  }

  void updateAddress(String newAddress) {
    emit(state.copyWith(address: newAddress));
  }

  void updateBirthDate(DateTime newBirthDate) {
    emit(state.copyWith(birthDate: newBirthDate));
  }

  void clearStatusMessage() {
    emit(state.copyWith(statusMessage: ''));
  }

  void clearErrorMessage() {
    emit(state.copyWith(errorMessage: ''));
  }
}
