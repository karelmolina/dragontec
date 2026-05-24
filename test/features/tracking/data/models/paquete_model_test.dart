import 'package:dragontec/features/tracking/data/models/paquete_model.dart';
import 'package:dragontec/features/tracking/domain/entities/paquete.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaqueteModel', () {
    test('debería deserializar desde JSON con todos los campos', () {
      final json = {
        'tracking': 'PKGNI00000000000117077',
        'estado': 'Recibido en Warehouse',
        'tracking_courier': '1ZJ73E770323663880',
        'agencia': 'PZ',
        'peso': 5,
        'flete': 'Aereo',
        'descripcion': 'ACCESORIO DE TELEFONO',
        'consignatario': 'Grupo Garza',
        'nombre_ciudad': 'Managua',
        'nombre_pais': 'Nicaragua',
        'fecha_almacen': '2026-05-14 17:57:10',
        'color_estado': 'bg-primary',
        'cant_pieza': 1,
      };

      final model = PaqueteModel.fromJson(json);

      expect(model.tracking, 'PKGNI00000000000117077');
      expect(model.estado, 'Recibido en Warehouse');
      expect(model.trackingCourier, '1ZJ73E770323663880');
      expect(model.agencia, 'PZ');
      expect(model.peso, 5);
      expect(model.flete, 'Aereo');
      expect(model.descripcion, 'ACCESORIO DE TELEFONO');
      expect(model.consignatario, 'Grupo Garza');
      expect(model.nombreCiudad, 'Managua');
      expect(model.nombrePais, 'Nicaragua');
      expect(model.fechaAlmacen, '2026-05-14 17:57:10');
      expect(model.colorEstado, 'bg-primary');
      expect(model.cantPieza, 1);
    });

    test('debería deserializar desde JSON con campos nulos opcionales', () {
      final json = {
        'tracking': 'PKG123',
        'estado': 'Registrado',
      };

      final model = PaqueteModel.fromJson(json);

      expect(model.tracking, 'PKG123');
      expect(model.estado, 'Registrado');
      expect(model.trackingCourier, '');
      expect(model.agencia, '');
      expect(model.peso, 0);
      expect(model.flete, '');
      expect(model.descripcion, '');
      expect(model.consignatario, '');
      expect(model.nombreCiudad, '');
      expect(model.nombrePais, '');
      expect(model.fechaAlmacen, isNull);
      expect(model.colorEstado, '');
      expect(model.cantPieza, 0);
    });

    test('debería serializar a JSON correctamente', () {
      const model = PaqueteModel(
        tracking: 'PKG123',
        estado: 'Entregado',
        trackingCourier: 'COURIER456',
        agencia: 'PZ',
        peso: 5,
        flete: 'Aereo',
        descripcion: 'Test',
        consignatario: 'Test Consignatario',
        nombreCiudad: 'Managua',
        nombrePais: 'Nicaragua',
        fechaAlmacen: '2026-05-14 17:57:10',
        colorEstado: 'bg-success',
        cantPieza: 2,
      );

      final json = model.toJson();

      expect(json['tracking'], 'PKG123');
      expect(json['estado'], 'Entregado');
      expect(json['tracking_courier'], 'COURIER456');
      expect(json['agencia'], 'PZ');
      expect(json['peso'], 5);
      expect(json['flete'], 'Aereo');
      expect(json['descripcion'], 'Test');
      expect(json['consignatario'], 'Test Consignatario');
      expect(json['nombre_ciudad'], 'Managua');
      expect(json['nombre_pais'], 'Nicaragua');
      expect(json['fecha_almacen'], '2026-05-14 17:57:10');
      expect(json['color_estado'], 'bg-success');
      expect(json['cant_pieza'], 2);
    });

    test('debería serializar a JSON sin campos nulos', () {
      const model = PaqueteModel(
        tracking: 'PKG789',
        estado: 'Pendiente',
        trackingCourier: 'COURIER789',
        agencia: 'PZ',
        peso: 0,
        flete: 'Maritimo',
        descripcion: '',
        consignatario: '',
        nombreCiudad: '',
        nombrePais: '',
        colorEstado: '',
        cantPieza: 0,
      );

      final json = model.toJson();

      expect(json.containsKey('fecha_almacen'), isFalse);
    });

    test('toEntity debería retornar una entidad Paquete equivalente', () {
      const model = PaqueteModel(
        tracking: 'PKG999',
        estado: 'En tránsito',
        trackingCourier: 'COURIER999',
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

      final entity = model.toEntity();

      expect(entity, isA<Paquete>());
      expect(entity.tracking, 'PKG999');
      expect(entity.estado, 'En tránsito');
      expect(entity.trackingCourier, 'COURIER999');
      expect(entity.agencia, 'PZ');
      expect(entity.peso, 5);
      expect(entity.flete, 'Aereo');
      expect(entity.descripcion, 'Test');
      expect(entity.consignatario, 'Test');
      expect(entity.nombreCiudad, 'Managua');
      expect(entity.nombrePais, 'Nicaragua');
      expect(entity.colorEstado, 'bg-primary');
      expect(entity.cantPieza, 1);
    });

    test('toEntity roundtrip: fromJson -> toEntity debería preservar datos',
        () {
      final json = {
        'tracking': 'PKGRT123',
        'estado': 'Entregado',
        'tracking_courier': 'COURIERRT',
        'agencia': 'PZ',
        'peso': 10,
        'flete': 'Maritimo',
        'descripcion': 'Roundtrip test',
        'consignatario': 'Test',
        'nombre_ciudad': 'Managua',
        'nombre_pais': 'Nicaragua',
        'fecha_almacen': '2026-01-01 10:00:00',
        'color_estado': 'bg-success',
        'cant_pieza': 3,
      };

      final model = PaqueteModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.tracking, 'PKGRT123');
      expect(entity.estado, 'Entregado');
      expect(entity.trackingCourier, 'COURIERRT');
      expect(entity.agencia, 'PZ');
      expect(entity.peso, 10);
      expect(entity.flete, 'Maritimo');
      expect(entity.descripcion, 'Roundtrip test');
      expect(entity.consignatario, 'Test');
      expect(entity.nombreCiudad, 'Managua');
      expect(entity.nombrePais, 'Nicaragua');
      expect(entity.fechaAlmacen, '2026-01-01 10:00:00');
      expect(entity.colorEstado, 'bg-success');
      expect(entity.cantPieza, 3);
    });
  });
}
