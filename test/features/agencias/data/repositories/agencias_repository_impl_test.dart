import 'package:dartz/dartz.dart';
import 'package:dragontec/core/errors/exceptions.dart';
import 'package:dragontec/core/errors/failures.dart';
import 'package:dragontec/features/agencias/data/datasources/agencias_remote_datasource.dart';
import 'package:dragontec/features/agencias/data/models/agencia_model.dart';
import 'package:dragontec/features/agencias/data/repositories/agencias_repository_impl.dart';
import 'package:dragontec/features/agencias/domain/entities/agencia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'agencias_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AgenciasRemoteDataSource>()])
void main() {
  late MockAgenciasRemoteDataSource mockRemote;
  late AgenciasRepositoryImpl repository;

  setUp(() {
    mockRemote = MockAgenciasRemoteDataSource();
    repository = AgenciasRepositoryImpl(remoteDataSource: mockRemote);
  });

  const tAgenciaModel = AgenciaModel(id: 1, nombre: 'Test');
  final tAgencia = tAgenciaModel.toEntity();

  group('getAgencias', () {
    test('debería retornar lista de agencias', () async {
      when(mockRemote.getAgencias(
        page: anyNamed('page'),
        perPage: anyNamed('perPage'),
        id: anyNamed('id'),
        codigo: anyNamed('codigo'),
        nombre: anyNamed('nombre'),
      )).thenAnswer((_) async => [tAgenciaModel]);

      final result = await repository.getAgencias();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('debería ser Right'),
        (agencias) {
          expect(agencias.length, 1);
          expect(agencias.first.nombre, 'Test');
        },
      );
    });

    test('debería retornar Left en error', () async {
      when(mockRemote.getAgencias(
        page: anyNamed('page'),
        perPage: anyNamed('perPage'),
        id: anyNamed('id'),
        codigo: anyNamed('codigo'),
        nombre: anyNamed('nombre'),
      )).thenThrow(const ServerException(message: 'Error'));

      final result = await repository.getAgencias();

      expect(result.isLeft(), isTrue);
    });
  });
}
