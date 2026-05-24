import 'package:dragontec/features/alertas/data/models/alerta_paquete_model.dart';
import 'package:dragontec/features/alertas/domain/entities/alerta_paquete.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AlertaPaqueteModel', () {
    final tDiaLlegada = DateTime(2024, 6, 15, 10, 30);

    test('debería deserializar desde JSON con todos los campos', () {
      final json = {
        'dia_llegada': '2024-06-15T10:30:00.000',
        'nombre_cliente': 'Juan Pérez',
        'tracking_courier': '1Z999AA10123456784',
        'id_courier': 1,
        'id_agencia': 2,
        'id_tipoalerta': 3,
        'flete': 'Aéreo',
        'cant_piezas': 5,
        'descripcion': 'Electrónicos',
        'instrucciones': 'Frágil',
      };

      final model = AlertaPaqueteModel.fromJson(json);

      expect(model.diaLlegada, tDiaLlegada);
      expect(model.nombreCliente, 'Juan Pérez');
      expect(model.trackingCourier, '1Z999AA10123456784');
      expect(model.idCourier, 1);
      expect(model.idAgencia, 2);
      expect(model.idTipoalerta, 3);
      expect(model.flete, 'Aéreo');
      expect(model.cantPiezas, 5);
      expect(model.descripcion, 'Electrónicos');
      expect(model.instrucciones, 'Frágil');
    });

    test('debería deserializar desde JSON con dia_llegada nulo', () {
      final json = {
        'nombre_cliente': 'Juan Pérez',
        'tracking_courier': '1Z999AA10123456784',
        'id_courier': 1,
        'id_agencia': 2,
        'id_tipoalerta': 3,
        'flete': 'Aéreo',
        'cant_piezas': 5,
        'descripcion': 'Electrónicos',
        'instrucciones': 'Frágil',
      };

      final model = AlertaPaqueteModel.fromJson(json);

      expect(model.diaLlegada, isNull);
      expect(model.nombreCliente, 'Juan Pérez');
      expect(model.trackingCourier, '1Z999AA10123456784');
    });

    test('debería serializar a JSON correctamente', () {
      final model = AlertaPaqueteModel(
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

      final json = model.toJson();

      expect(json['dia_llegada'], tDiaLlegada.toIso8601String());
      expect(json['nombre_cliente'], 'Juan Pérez');
      expect(json['tracking_courier'], '1Z999AA10123456784');
      expect(json['id_courier'], 1);
      expect(json['id_agencia'], 2);
      expect(json['id_tipoalerta'], 3);
      expect(json['flete'], 'Aéreo');
      expect(json['cant_piezas'], 5);
      expect(json['descripcion'], 'Electrónicos');
      expect(json['instrucciones'], 'Frágil');
    });

    test('debería serializar a JSON sin dia_llegada cuando es nulo', () {
      const model = AlertaPaqueteModel(
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

      final json = model.toJson();

      expect(json.containsKey('dia_llegada'), isFalse);
      expect(json['nombre_cliente'], 'Juan Pérez');
      expect(json['tracking_courier'], '1Z999AA10123456784');
    });

    test('toEntity debería retornar una entidad AlertaPaquete equivalente', () {
      final model = AlertaPaqueteModel(
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

      final entity = model.toEntity();

      expect(entity, isA<AlertaPaquete>());
      expect(entity.diaLlegada, tDiaLlegada);
      expect(entity.nombreCliente, 'Juan Pérez');
      expect(entity.trackingCourier, '1Z999AA10123456784');
      expect(entity.idCourier, 1);
      expect(entity.idAgencia, 2);
      expect(entity.idTipoalerta, 3);
      expect(entity.flete, 'Aéreo');
      expect(entity.cantPiezas, 5);
      expect(entity.descripcion, 'Electrónicos');
      expect(entity.instrucciones, 'Frágil');
    });

    test('toEntity roundtrip: fromJson -> toEntity debería preservar datos', () {
      final json = {
        'dia_llegada': '2024-06-15T10:30:00.000',
        'nombre_cliente': 'Juan Pérez',
        'tracking_courier': '1Z999AA10123456784',
        'id_courier': 1,
        'id_agencia': 2,
        'id_tipoalerta': 3,
        'flete': 'Aéreo',
        'cant_piezas': 5,
        'descripcion': 'Electrónicos',
        'instrucciones': 'Frágil',
      };

      final model = AlertaPaqueteModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.diaLlegada, tDiaLlegada);
      expect(entity.nombreCliente, 'Juan Pérez');
      expect(entity.trackingCourier, '1Z999AA10123456784');
      expect(entity.idCourier, 1);
      expect(entity.idAgencia, 2);
      expect(entity.idTipoalerta, 3);
      expect(entity.flete, 'Aéreo');
      expect(entity.cantPiezas, 5);
      expect(entity.descripcion, 'Electrónicos');
      expect(entity.instrucciones, 'Frágil');
    });
  });
}
