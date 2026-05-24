import 'package:dragontec/features/alertas/domain/entities/alerta_paquete.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AlertaPaquete', () {
    final tDiaLlegada = DateTime(2024, 6, 15);

    test('debería crear una instancia con todos los campos requeridos', () {
      const alerta = AlertaPaquete(
        diaLlegada: null,
        nombreCliente: 'Juan Pérez',
        trackingCourier: '1Z999AA10123456784',
        idCourier: 1,
        idAgencia: 2,
        idTipoalerta: 3,
        flete: 'Aéreo',
        cantPiezas: 5,
        descripcion: 'Electrónicos',
        instrucciones: 'Frágil',
      );

      expect(alerta.nombreCliente, 'Juan Pérez');
      expect(alerta.trackingCourier, '1Z999AA10123456784');
      expect(alerta.idCourier, 1);
      expect(alerta.idAgencia, 2);
      expect(alerta.idTipoalerta, 3);
      expect(alerta.flete, 'Aéreo');
      expect(alerta.cantPiezas, 5);
      expect(alerta.descripcion, 'Electrónicos');
      expect(alerta.instrucciones, 'Frágil');
    });

    test('debería incluir diaLlegada cuando se proporciona', () {
      final alerta = AlertaPaquete(
        diaLlegada: tDiaLlegada,
        nombreCliente: 'Juan Pérez',
        trackingCourier: '1Z999AA10123456784',
        idCourier: 1,
        idAgencia: 2,
        idTipoalerta: 3,
        flete: 'Aéreo',
        cantPiezas: 5,
        descripcion: 'Electrónicos',
        instrucciones: 'Frágil',
      );

      expect(alerta.diaLlegada, tDiaLlegada);
    });

    test('debería ser igual cuando todos los campos son iguales', () {
      final alerta1 = AlertaPaquete(
        diaLlegada: tDiaLlegada,
        nombreCliente: 'Juan Pérez',
        trackingCourier: '1Z999AA10123456784',
        idCourier: 1,
        idAgencia: 2,
        idTipoalerta: 3,
        flete: 'Aéreo',
        cantPiezas: 5,
        descripcion: 'Electrónicos',
        instrucciones: 'Frágil',
      );

      final alerta2 = AlertaPaquete(
        diaLlegada: tDiaLlegada,
        nombreCliente: 'Juan Pérez',
        trackingCourier: '1Z999AA10123456784',
        idCourier: 1,
        idAgencia: 2,
        idTipoalerta: 3,
        flete: 'Aéreo',
        cantPiezas: 5,
        descripcion: 'Electrónicos',
        instrucciones: 'Frágil',
      );

      expect(alerta1, equals(alerta2));
    });

    test('debería ser diferente cuando nombreCliente cambia', () {
      final alerta1 = AlertaPaquete(
        diaLlegada: tDiaLlegada,
        nombreCliente: 'Juan Pérez',
        trackingCourier: '1Z999AA10123456784',
        idCourier: 1,
        idAgencia: 2,
        idTipoalerta: 3,
        flete: 'Aéreo',
        cantPiezas: 5,
        descripcion: 'Electrónicos',
        instrucciones: 'Frágil',
      );

      final alerta2 = AlertaPaquete(
        diaLlegada: tDiaLlegada,
        nombreCliente: 'María López',
        trackingCourier: '1Z999AA10123456784',
        idCourier: 1,
        idAgencia: 2,
        idTipoalerta: 3,
        flete: 'Aéreo',
        cantPiezas: 5,
        descripcion: 'Electrónicos',
        instrucciones: 'Frágil',
      );

      expect(alerta1, isNot(equals(alerta2)));
    });

    test('debería ser diferente cuando trackingCourier cambia', () {
      final alerta1 = AlertaPaquete(
        diaLlegada: tDiaLlegada,
        nombreCliente: 'Juan Pérez',
        trackingCourier: '1Z999AA10123456784',
        idCourier: 1,
        idAgencia: 2,
        idTipoalerta: 3,
        flete: 'Aéreo',
        cantPiezas: 5,
        descripcion: 'Electrónicos',
        instrucciones: 'Frágil',
      );

      final alerta2 = AlertaPaquete(
        diaLlegada: tDiaLlegada,
        nombreCliente: 'Juan Pérez',
        trackingCourier: '1Z999AA10123456785',
        idCourier: 1,
        idAgencia: 2,
        idTipoalerta: 3,
        flete: 'Aéreo',
        cantPiezas: 5,
        descripcion: 'Electrónicos',
        instrucciones: 'Frágil',
      );

      expect(alerta1, isNot(equals(alerta2)));
    });

    test('debería ser diferente cuando flete cambia', () {
      final alerta1 = AlertaPaquete(
        diaLlegada: tDiaLlegada,
        nombreCliente: 'Juan Pérez',
        trackingCourier: '1Z999AA10123456784',
        idCourier: 1,
        idAgencia: 2,
        idTipoalerta: 3,
        flete: 'Aéreo',
        cantPiezas: 5,
        descripcion: 'Electrónicos',
        instrucciones: 'Frágil',
      );

      final alerta2 = AlertaPaquete(
        diaLlegada: tDiaLlegada,
        nombreCliente: 'Juan Pérez',
        trackingCourier: '1Z999AA10123456784',
        idCourier: 1,
        idAgencia: 2,
        idTipoalerta: 3,
        flete: 'Marítimo',
        cantPiezas: 5,
        descripcion: 'Electrónicos',
        instrucciones: 'Frágil',
      );

      expect(alerta1, isNot(equals(alerta2)));
    });
  });
}
