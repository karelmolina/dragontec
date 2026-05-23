import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();

  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> deleteUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> saveToken(String token) =>
      secureStorage.write(key: _tokenKey, value: token);

  @override
  Future<String?> getToken() => secureStorage.read(key: _tokenKey);

  @override
  Future<void> deleteToken() => secureStorage.delete(key: _tokenKey);

  @override
  Future<void> saveUser(UserModel user) =>
      secureStorage.write(key: _userKey, value: jsonEncode(user.toJson()));

  @override
  Future<UserModel?> getUser() async {
    final jsonString = await secureStorage.read(key: _userKey);
    if (jsonString == null || jsonString.isEmpty) return null;
    try {
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> deleteUser() => secureStorage.delete(key: _userKey);
}
