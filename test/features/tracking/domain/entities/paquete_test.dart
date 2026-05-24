import 'package:dragontec/features/tracking/domain/entities/paquete.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Paquete', () {
    test('debería crear una instancia con campos requeridos', () {
      const paquete = Paquete(
        tracking: 'PKGNI00000000000117077',
        estado: 'Recibido en Warehouse',
        trackingCourier: '1ZJ73E770323663880',
        agencia: 'PZ',
        peso: 5,
        flete: 'Aereo',
        descripcion: 'ACCESORIO DE TELEFONO',
        consignatario: 'Grupo Garza',
        nombreCiudad: 'Managua',
        nombrePais: 'Nicaragua',
        colorEstado: 'bg-primary',
        cantPieza: 1,
      );

      expect(paquete.tracking, 'PKGNI00000000000117077');
      expect(paquete.estado, 'Recibido en Warehouse');
      expect(paquete.trackingCourier, '1ZJ73E770323663880');
      expect(paquete.agencia, 'PZ');
      expect(paquete.peso, 5);
      expect(paquete.flete, 'Aereo');
      expect(paquete.descripcion, 'ACCESORIO DE TELEFONO');
      expect(paquete.consignatario, 'Grupo Garza');
      expect(paquete.nombreCiudad, 'Managua');
      expect(paquete.nombrePais, 'Nicaragua');
      expect(paquete.fechaAlmacen, isNull);
      expect(paquete.colorEstado, 'bg-primary');
      expect(paquete.cantPieza, 1);
    });

    test('debería crear una instancia con todos los campos', () {
      const paquete = Paquete(
        tracking: 'PKGNI00000000000117077',
        estado: 'Recibido en Warehouse',
        trackingCourier: '1ZJ73E770323663880',
        agencia: 'PZ',
        peso: 5,
        flete: 'Aereo',
        descripcion: 'ACCESORIO DE TELEFONO',
        consignatario: 'Grupo Garza',
        nombreCiudad: 'Managua',
        nombrePais: 'Nicaragua',
        fechaAlmacen: '2026-05-14 17:57:10',
        colorEstado: 'bg-primary',
        cantPieza: 1,
      );

      expect(paquete.fechaAlmacen, '2026-05-14 17:57:10');
    });

    test('debería ser igual cuando todos los campos son iguales', () {
      const paquete1 = Paquete(
        tracking: 'TRK123',
        estado: 'En tránsito',
        trackingCourier: 'COURIER123',
        agencia: 'PZ',
        peso: 5,
        flete: 'Aereo',
        descripcion: 'Test',
        consignatario: 'Test',
        nombreCiudad: 'Managua',
        nombrePais: 'Nicaragua',
        colorEstado: 'bg-primary',
        cantPieza: 1,
      );
      const paquete2 = Paquete(
        tracking: 'TRK123',
        estado: 'En tránsito',
        trackingCourier: 'COURIER123',
        agencia: 'PZ',
        peso: 5,
        flete: 'Aereo',
        descripcion: 'Test',
        consignatario: 'Test',
        nombreCiudad: 'Managua',
        nombrePais: 'Nicaragua',
        colorEstado: 'bg-primary',
        cantPieza: 1,
      );

      expect(paquete1, equals(paquete2));
    });

    test('debería ser diferente cuando tracking cambia', () {
      const paquete1 = Paquete(
        tracking: 'TRK123',
        estado: 'En tránsito',
        trackingCourier: 'COURIER123',
        agencia: 'PZ',
        peso: 5,
        flete: 'Aereo',
        descripcion: 'Test',
        consignatario: 'Test',
        nombreCiudad: 'Managua',
        nombrePais: 'Nicaragua',
        colorEstado: 'bg-primary',
        cantPieza: 1,
      );
      const paquete2 = Paquete(
        tracking: 'TRK456',
        estado: 'En tránsito',
        trackingCourier: 'COURIER123',
        agencia: 'PZ',
        peso: 5,
        flete: 'Aereo',
        descripcion: 'Test',
        consignatario: 'Test',
        nombreCiudad: 'Managua',
        nombrePais: 'Nicaragua',
        colorEstado: 'bg-primary',
        cantPieza: 1,
      );

      expect(paquete1, isNot(equals(paquete2)));
    });

    test('debería ser diferente cuando estado cambia', () {
      const paquete1 = Paquete(
        tracking: 'TRK123',
        estado: 'En tránsito',
        trackingCourier: 'COURIER123',
        agencia: 'PZ',
        peso: 5,
        flete: 'Aereo',
        descripcion: 'Test',
        consignatario: 'Test',
        nombreCiudad: 'Managua',
        nombrePais: 'Nicaragua',
        colorEstado: 'bg-primary',
        cantPieza: 1,
      );
      const paquete2 = Paquete(
        tracking: 'TRK123',
        estado: 'Entregado',
        trackingCourier: 'COURIER123',
        agencia: 'PZ',
        peso: 5,
        flete: 'Aereo',
        descripcion: 'Test',
        consignatario: 'Test',
        nombreCiudad: 'Managua',
        nombrePais: 'Nicaragua',
        colorEstado: 'bg-primary',
        cantPieza: 1,
      );

      expect(paquete1, isNot(equals(paquete2)));
    });
  });
}
