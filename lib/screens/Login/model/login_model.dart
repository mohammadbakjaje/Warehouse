class LoginModel {
  final bool success;
  final String message;
  final LoginData data;

  LoginModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: LoginData.fromJson(json['data']),
    );
  }
}

class LoginData {
  final String accessToken;
  final String tokenType;
  final UserModel user;
  final String role;
  final String platform;

  LoginData({
    required this.accessToken,
    required this.tokenType,
    required this.user,
    required this.role,
    required this.platform,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      accessToken: json['access_token'] ?? '',
      tokenType: json['token_type'] ?? '',
      user: UserModel.fromJson(json['user']),
      role: json['role'] ?? '',
      platform: json['platform'] ?? '',
    );
  }
}

class UserModel {
  final int id;
  final int departmentId;
  final String name;
  final String? email;
  final String phone;
  final String jobTitle;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.departmentId,
    required this.name,
    this.email,
    required this.phone,
    required this.jobTitle,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      departmentId: json['department_id'],
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'] ?? '',
      jobTitle: json['job_title'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
