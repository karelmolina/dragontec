import 'package:dragontec/features/auth/data/models/login_request.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginRequest', () {
    test('debería crear una instancia con valores requeridos', () {
      final request = LoginRequest(
        usuario: 'juanp',
        clave: 'password123',
        deviceName: 'dragontec_mobile',
      );

      expect(request.usuario, 'juanp');
      expect(request.clave, 'password123');
      expect(request.deviceName, 'dragontec_mobile');
    });

    test('debería serializar a JSON correctamente', () {
      final request = LoginRequest(
        usuario: 'testuser',
        clave: 'secret',
        deviceName: 'test_device',
      );

      final json = request.toJson();

      expect(json['usuario'], 'testuser');
      expect(json['clave'], 'secret');
      expect(json['device_name'], 'test_device');
    });

    test('debería manejar strings vacíos', () {
      final request = LoginRequest(
        usuario: '',
        clave: '',
        deviceName: '',
      );

      final json = request.toJson();

      expect(json['usuario'], '');
      expect(json['clave'], '');
      expect(json['device_name'], '');
    });
  });
}
