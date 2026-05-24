import 'package:dragontec/features/tracking/data/models/paquete_model.dart';
import 'package:dragontec/features/tracking/domain/entities/paquete.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaqueteModel', () {
    final tFechaRegistro = DateTime(2024, 1, 15, 10, 30);
    final tFechaEstimada = DateTime(2024, 1, 20, 14, 0);

    test('debería deserializar desde JSON con todos los campos', () {
      final json = {
        'tracking': '1ZJ73E770323663880',
        'estado': 'En tránsito',
        'origen': 'Miami, FL',
        'destino': 'Ciudad de Guatemala',
        'fecha_registro': '2024-01-15T10:30:00.000',
        'fecha_estimada': '2024-01-20T14:00:00.000',
      };

      final model = PaqueteModel.fromJson(json);

      expect(model.tracking, '1ZJ73E770323663880');
      expect(model.estado, 'En tránsito');
      expect(model.origen, 'Miami, FL');
      expect(model.destino, 'Ciudad de Guatemala');
      expect(model.fechaRegistro, tFechaRegistro);
      expect(model.fechaEstimada, tFechaEstimada);
    });

    test('debería deserializar desde JSON con campos nulos', () {
      final json = {
        'tracking': 'TRK123',
        'estado': 'Registrado',
      };

      final model = PaqueteModel.fromJson(json);

      expect(model.tracking, 'TRK123');
      expect(model.estado, 'Registrado');
      expect(model.origen, isNull);
      expect(model.destino, isNull);
      expect(model.fechaRegistro, isNull);
      expect(model.fechaEstimada, isNull);
    });

    test('debería usar valores por defecto cuando tracking y estado son nulos',
        () {
      final json = <String, dynamic>{};

      final model = PaqueteModel.fromJson(json);

      expect(model.tracking, '');
      expect(model.estado, '');
    });

    test('debería serializar a JSON correctamente', () {
      final model = PaqueteModel(
        tracking: 'TRK456',
        estado: 'Entregado',
        origen: 'Houston, TX',
        destino: 'San Salvador',
        fechaRegistro: tFechaRegistro,
        fechaEstimada: tFechaEstimada,
      );

      final json = model.toJson();

      expect(json['tracking'], 'TRK456');
      expect(json['estado'], 'Entregado');
      expect(json['origen'], 'Houston, TX');
      expect(json['destino'], 'San Salvador');
      expect(json['fecha_registro'], tFechaRegistro.toIso8601String());
      expect(json['fecha_estimada'], tFechaEstimada.toIso8601String());
    });

    test('debería serializar a JSON sin campos nulos', () {
      const model = PaqueteModel(
        tracking: 'TRK789',
        estado: 'Pendiente',
      );

      final json = model.toJson();

      expect(json['tracking'], 'TRK789');
      expect(json['estado'], 'Pendiente');
      expect(json.containsKey('origen'), isFalse);
      expect(json.containsKey('destino'), isFalse);
      expect(json.containsKey('fecha_registro'), isFalse);
      expect(json.containsKey('fecha_estimada'), isFalse);
    });

    test('toEntity debería retornar una entidad Paquete equivalente', () {
      final model = PaqueteModel(
        tracking: 'TRK999',
        estado: 'En tránsito',
        origen: 'Origen',
        destino: 'Destino',
        fechaRegistro: tFechaRegistro,
        fechaEstimada: tFechaEstimada,
      );

      final entity = model.toEntity();

      expect(entity, isA<Paquete>());
      expect(entity.tracking, 'TRK999');
      expect(entity.estado, 'En tránsito');
      expect(entity.origen, 'Origen');
      expect(entity.destino, 'Destino');
      expect(entity.fechaRegistro, tFechaRegistro);
      expect(entity.fechaEstimada, tFechaEstimada);
    });

    test('toEntity roundtrip: fromJson -> toEntity debería preservar datos',
        () {
      final json = {
        'tracking': 'RT123',
        'estado': 'Entregado',
        'origen': 'OrigenX',
        'destino': 'DestinoX',
        'fecha_registro': '2024-06-01T08:00:00.000',
        'fecha_estimada': '2024-06-05T16:00:00.000',
      };

      final model = PaqueteModel.fromJson(json);
      final entity = model.toEntity();

      expect(entity.tracking, 'RT123');
      expect(entity.estado, 'Entregado');
      expect(entity.origen, 'OrigenX');
      expect(entity.destino, 'DestinoX');
      expect(entity.fechaRegistro, DateTime(2024, 6, 1, 8));
      expect(entity.fechaEstimada, DateTime(2024, 6, 5, 16));
    });
  });
}
