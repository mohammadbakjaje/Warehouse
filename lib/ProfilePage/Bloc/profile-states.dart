import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String gender;
  final String facebookAccount;
  final String address;
  final DateTime birthDate;
  final bool isEditing;
  final String statusMessage;
  final bool isLoading;
  final String errorMessage;
  final Map<String, dynamic> userData;

  const ProfileState({
    required this.gender,
    required this.facebookAccount,
    required this.address,
    required this.birthDate,
    required this.isEditing,
    this.statusMessage = '',
    this.isLoading = false,
    this.errorMessage = '',
    this.userData = const {},
  });

  ProfileState copyWith({
    String? gender,
    String? facebookAccount,
    String? address,
    DateTime? birthDate,
    bool? isEditing,
    String? statusMessage,
    bool? isLoading,
    String? errorMessage,
    Map<String, dynamic>? userData,
  }) {
    return ProfileState(
      gender: gender ?? this.gender,
      facebookAccount: facebookAccount ?? this.facebookAccount,
      address: address ?? this.address,
      birthDate: birthDate ?? this.birthDate,
      isEditing: isEditing ?? this.isEditing,
      statusMessage: statusMessage ?? this.statusMessage,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      userData: userData ?? this.userData,
    );
  }

  @override
  List<Object> get props => [
        gender,
        facebookAccount,
        address,
        birthDate,
        isEditing,
        statusMessage,
        isLoading,
        errorMessage,
        userData,
      ];
}
