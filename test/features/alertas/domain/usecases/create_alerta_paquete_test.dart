import 'package:dartz/dartz.dart';
import 'package:dragontec/core/errors/failures.dart';
import 'package:dragontec/features/alertas/domain/entities/alerta_paquete.dart';
import 'package:dragontec/features/alertas/domain/repositories/alertas_repository.dart';
import 'package:dragontec/features/alertas/domain/usecases/create_alerta_paquete.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'create_alerta_paquete_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AlertasRepository>()])
void main() {
  late MockAlertasRepository mockRepository;
  late CreateAlertaPaqueteUseCase useCase;

  setUp(() {
    mockRepository = MockAlertasRepository();
    useCase = CreateAlertaPaqueteUseCase(mockRepository);
  });

  final tDiaLlegada = DateTime(2024, 6, 15);
  final tAlerta = AlertaPaquete(
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

  final tParams = CreateAlertaPaqueteParams(
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

  group('CreateAlertaPaqueteUseCase', () {
    test('debería retornar Right(void) cuando la creación es exitosa', () async {
      when(mockRepository.createAlerta(any))
          .thenAnswer((_) async => const Right(null));

      final result = await useCase(tParams);

      expect(result, equals(const Right<Failure, void>(null)));
      verify(mockRepository.createAlerta(tAlerta));
      verifyNoMoreInteractions(mockRepository);
    });

    test('debería retornar Left(ValidationFailure) cuando hay errores de validación',
        () async {
      when(mockRepository.createAlerta(any)).thenAnswer(
        (_) async => const Left(ValidationFailure(message: 'Datos inválidos')),
      );

      final result = await useCase(tParams);

      expect(
        result,
        equals(const Left<Failure, void>(
          ValidationFailure(message: 'Datos inválidos'),
        )),
      );
      verify(mockRepository.createAlerta(tAlerta));
      verifyNoMoreInteractions(mockRepository);
    });

    test('debería retornar Left(ServerFailure) cuando ocurre un error del servidor',
        () async {
      when(mockRepository.createAlerta(any)).thenAnswer(
        (_) async => const Left(ServerFailure(message: 'Error interno')),
      );

      final result = await useCase(tParams);

      expect(
        result,
        equals(const Left<Failure, void>(
          ServerFailure(message: 'Error interno'),
        )),
      );
      verify(mockRepository.createAlerta(tAlerta));
      verifyNoMoreInteractions(mockRepository);
    });

    test('debería retornar Left(NetworkFailure) cuando hay error de red', () async {
      when(mockRepository.createAlerta(any)).thenAnswer(
        (_) async => const Left(NetworkFailure(message: 'Sin conexión')),
      );

      final result = await useCase(tParams);

      expect(
        result,
        equals(const Left<Failure, void>(
          NetworkFailure(message: 'Sin conexión'),
        )),
      );
      verify(mockRepository.createAlerta(tAlerta));
      verifyNoMoreInteractions(mockRepository);
    });

    test('debería retornar Left(UnauthorizedFailure) cuando no está autorizado',
        () async {
      when(mockRepository.createAlerta(any)).thenAnswer(
        (_) async => const Left(UnauthorizedFailure()),
      );

      final result = await useCase(tParams);

      expect(
        result,
        equals(const Left<Failure, void>(UnauthorizedFailure())),
      );
      verify(mockRepository.createAlerta(tAlerta));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
