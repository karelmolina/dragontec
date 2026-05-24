import 'package:dragontec/features/tracking/domain/entities/paquete.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Paquete', () {
    test('debería crear una instancia con campos requeridos', () {
      const paquete = Paquete(
        tracking: 'TRK123ABC',
        estado: 'En tránsito',
      );

      expect(paquete.tracking, 'TRK123ABC');
      expect(paquete.estado, 'En tránsito');
      expect(paquete.origen, isNull);
      expect(paquete.destino, isNull);
      expect(paquete.fechaRegistro, isNull);
      expect(paquete.fechaEstimada, isNull);
    });

    test('debería crear una instancia con todos los campos', () {
      final fechaRegistro = DateTime(2024, 1, 15);
      final fechaEstimada = DateTime(2024, 1, 20);
      final paquete = Paquete(
        tracking: 'TRK456DEF',
        estado: 'Entregado',
        origen: 'Miami, FL',
        destino: 'Ciudad de Guatemala',
        fechaRegistro: fechaRegistro,
        fechaEstimada: fechaEstimada,
      );

      expect(paquete.tracking, 'TRK456DEF');
      expect(paquete.estado, 'Entregado');
      expect(paquete.origen, 'Miami, FL');
      expect(paquete.destino, 'Ciudad de Guatemala');
      expect(paquete.fechaRegistro, fechaRegistro);
      expect(paquete.fechaEstimada, fechaEstimada);
    });

    test('debería ser igual cuando todos los campos son iguales', () {
      final fecha = DateTime(2024, 1, 15);
      final paquete1 = Paquete(
        tracking: 'TRK123',
        estado: 'En tránsito',
        origen: 'Origen',
        destino: 'Destino',
        fechaRegistro: fecha,
        fechaEstimada: fecha,
      );
      final paquete2 = Paquete(
        tracking: 'TRK123',
        estado: 'En tránsito',
        origen: 'Origen',
        destino: 'Destino',
        fechaRegistro: fecha,
        fechaEstimada: fecha,
      );

      expect(paquete1, equals(paquete2));
    });

    test('debería ser diferente cuando tracking cambia', () {
      const paquete1 = Paquete(tracking: 'TRK123', estado: 'En tránsito');
      const paquete2 = Paquete(tracking: 'TRK456', estado: 'En tránsito');

      expect(paquete1, isNot(equals(paquete2)));
    });

    test('debería ser diferente cuando estado cambia', () {
      const paquete1 = Paquete(tracking: 'TRK123', estado: 'En tránsito');
      const paquete2 = Paquete(tracking: 'TRK123', estado: 'Entregado');

      expect(paquete1, isNot(equals(paquete2)));
    });

    test('debería ser diferente cuando origen cambia', () {
      const paquete1 = Paquete(
        tracking: 'TRK123',
        estado: 'En tránsito',
        origen: 'A',
      );
      const paquete2 = Paquete(
        tracking: 'TRK123',
        estado: 'En tránsito',
        origen: 'B',
      );

      expect(paquete1, isNot(equals(paquete2)));
    });
  });
}
