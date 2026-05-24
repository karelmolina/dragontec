import 'package:dragontec/features/tracking/domain/entities/paquete.dart';
import 'package:dragontec/features/tracking/presentation/bloc/tracking_bloc.dart';
import 'package:dragontec/features/tracking/presentation/bloc/tracking_event.dart';
import 'package:dragontec/features/tracking/presentation/bloc/tracking_state.dart';
import 'package:dragontec/features/tracking/presentation/pages/tracking_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tracking_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TrackingBloc>()])
void main() {
  late MockTrackingBloc mockBloc;

  setUp(() {
    mockBloc = MockTrackingBloc();
    when(mockBloc.state).thenReturn(const TrackingInitial());
    when(mockBloc.stream).thenAnswer(
      (_) => Stream.value(const TrackingInitial()),
    );
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<TrackingBloc>.value(
        value: mockBloc,
        child: const TrackingPage(),
      ),
    );
  }

  group('TrackingPage', () {
    testWidgets('debería mostrar campo de búsqueda en estado inicial', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('debería mostrar indicador de carga en estado loading', (
      WidgetTester tester,
    ) async {
      when(mockBloc.state).thenReturn(const TrackingLoading());
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.value(const TrackingLoading()),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'debería mostrar tarjeta con datos cuando se encuentra el paquete', (
      WidgetTester tester,
    ) async {
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

      when(mockBloc.state).thenReturn(const TrackingLoaded(paquete: paquete));
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.value(const TrackingLoaded(paquete: paquete)),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('PKGNI00000000000117077'), findsOneWidget);
      expect(find.text('Recibido en Warehouse'), findsOneWidget);
      expect(find.text('1ZJ73E770323663880'), findsOneWidget);
      expect(find.text('ACCESORIO DE TELEFONO'), findsOneWidget);
      expect(find.text('Grupo Garza'), findsOneWidget);
    });

    testWidgets('debería mostrar mensaje cuando no se encuentra el paquete', (
      WidgetTester tester,
    ) async {
      when(mockBloc.state).thenReturn(const TrackingNotFound());
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.value(const TrackingNotFound()),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Paquete no encontrado'), findsOneWidget);
    });

    testWidgets(
        'debería mostrar mensaje de error diferenciado en estado error', (
      WidgetTester tester,
    ) async {
      when(mockBloc.state).thenReturn(
        const TrackingError(message: 'Error de conexión'),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.value(
          const TrackingError(message: 'Error de conexión'),
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Error de conexión'), findsOneWidget);
    });

    testWidgets('debería enviar evento SearchTracking al presionar Enter', (
      WidgetTester tester,
    ) async {
      when(mockBloc.state).thenReturn(const TrackingInitial());
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.value(const TrackingInitial()),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      const trackingNumber = '1ZJ73E770323663880';
      await tester.enterText(find.byType(TextField), trackingNumber);
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      verify(mockBloc.add(argThat(
        isA<SearchTracking>().having(
          (e) => e.trackingCourier,
          'trackingCourier',
          trackingNumber,
        ),
      ))).called(1);
    });

    testWidgets('debería mostrar Snackbar cuando el tracking está vacío', (
      WidgetTester tester,
    ) async {
      when(mockBloc.state).thenReturn(const TrackingInitial());
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.value(const TrackingInitial()),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      expect(find.text('El número de tracking es obligatorio'), findsOneWidget);
      verifyNever(mockBloc.add(any));
    });

    testWidgets('debería mostrar botón reintentar en estado error', (
      WidgetTester tester,
    ) async {
      when(mockBloc.state).thenReturn(
        const TrackingError(message: 'Error de conexión'),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.value(
          const TrackingError(message: 'Error de conexión'),
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Error de conexión'), findsOneWidget);
      expect(find.text('Reintentar'), findsOneWidget);
    });

    testWidgets('debería reintentar búsqueda al presionar Reintentar', (
      WidgetTester tester,
    ) async {
      when(mockBloc.state).thenReturn(
        const TrackingError(message: 'Error de conexión'),
      );
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.value(
          const TrackingError(message: 'Error de conexión'),
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      const trackingNumber = '1ZJ73E770323663880';
      await tester.enterText(find.byType(TextField), trackingNumber);
      await tester.pump();

      await tester.tap(find.text('Reintentar'));
      await tester.pump();

      verify(mockBloc.add(argThat(
        isA<SearchTracking>().having(
          (e) => e.trackingCourier,
          'trackingCourier',
          trackingNumber,
        ),
      ))).called(1);
    });
  });
}
