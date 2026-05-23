class LoginResponse {
  final bool success;
  final String? message;
  final String? token;
  final Map<String, dynamic>? user;

  LoginResponse({
    required this.success,
    this.message,
    this.token,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        success: json['success'] ?? true,
        message: json['message'],
        token: json['token'],
        user: json['user'] != null
            ? Map<String, dynamic>.from(json['user'] as Map)
            : null,
      );
}
