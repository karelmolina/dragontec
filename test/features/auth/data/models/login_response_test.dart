import 'package:dragontec/features/auth/data/models/login_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginResponse', () {
    test('debería deserializar desde JSON exitoso', () {
      final json = {
        'success': true,
        'message': 'Login exitoso',
        'token': '25|abc123',
        'user': {
          'id': 1,
          'nombre': 'Juan',
          'usuario': 'juanp',
          'rol': 1,
        },
      };

      final response = LoginResponse.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, 'Login exitoso');
      expect(response.token, '25|abc123');
      expect(response.user, isNotNull);
      expect(response.user!['id'], 1);
    });

    test('debería deserializar desde JSON de error', () {
      final json = {
        'success': false,
        'message': 'Credenciales inválidas',
      };

      final response = LoginResponse.fromJson(json);

      expect(response.success, isFalse);
      expect(response.message, 'Credenciales inválidas');
      expect(response.token, isNull);
      expect(response.user, isNull);
    });

    test('debería usar success=true por defecto si falta', () {
      final json = <String, dynamic>{
        'token': 'abc',
      };

      final response = LoginResponse.fromJson(json);

      expect(response.success, isTrue);
      expect(response.token, 'abc');
    });

    test('debería manejar user como null', () {
      final json = <String, dynamic>{
        'success': true,
        'token': 'abc',
        'user': null,
      };

      final response = LoginResponse.fromJson(json);

      expect(response.user, isNull);
    });

    test('debería manejar JSON vacío', () {
      final json = <String, dynamic>{};

      final response = LoginResponse.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, isNull);
      expect(response.token, isNull);
      expect(response.user, isNull);
    });
  });
}
