import 'package:dragontec/core/errors/failures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TrackingNotFoundFailure', () {
    test('debería ser igual cuando el mensaje es el mismo', () {
      const failure1 = TrackingNotFoundFailure();
      const failure2 = TrackingNotFoundFailure();

      expect(failure1, equals(failure2));
    });

    test('debería ser igual cuando el mensaje personalizado coincide', () {
      const failure1 = TrackingNotFoundFailure(
        message: 'Paquete no encontrado con tracking ABC123',
      );
      const failure2 = TrackingNotFoundFailure(
        message: 'Paquete no encontrado con tracking ABC123',
      );

      expect(failure1, equals(failure2));
    });

    test('debería ser diferente cuando el mensaje es distinto', () {
      const failure1 = TrackingNotFoundFailure(
        message: 'Mensaje uno',
      );
      const failure2 = TrackingNotFoundFailure(
        message: 'Mensaje dos',
      );

      expect(failure1, isNot(equals(failure2)));
    });

    test('debería tener el mensaje por defecto correcto', () {
      const failure = TrackingNotFoundFailure();

      expect(failure.message, 'Paquete no encontrado.');
    });
  });
}
