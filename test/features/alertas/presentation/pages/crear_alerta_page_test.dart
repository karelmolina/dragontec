import 'package:dragontec/features/agencias/domain/entities/agencia.dart';
import 'package:dragontec/features/agencias/presentation/bloc/agencias_bloc.dart';
import 'package:dragontec/features/agencias/presentation/bloc/agencias_event.dart';
import 'package:dragontec/features/agencias/presentation/bloc/agencias_state.dart';
import 'package:dragontec/features/alertas/presentation/bloc/alertas_bloc.dart';
import 'package:dragontec/features/alertas/presentation/bloc/alertas_event.dart';
import 'package:dragontec/features/alertas/presentation/bloc/alertas_state.dart';
import 'package:dragontec/features/alertas/presentation/pages/crear_alerta_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'crear_alerta_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AlertasBloc>(),
  MockSpec<AgenciasBloc>(),
])
void main() {
  late MockAlertasBloc mockAlertasBloc;
  late MockAgenciasBloc mockAgenciasBloc;

  setUp(() {
    mockAlertasBloc = MockAlertasBloc();
    mockAgenciasBloc = MockAgenciasBloc();

    when(mockAlertasBloc.state).thenReturn(const AlertasInitial());
    when(mockAlertasBloc.stream).thenAnswer(
      (_) => Stream.value(const AlertasInitial()),
    );

    when(mockAgenciasBloc.state).thenReturn(
      const AgenciasLoaded(
        agencias: [Agencia(id: 1, nombre: 'Agencia Central')],
      ),
    );
    when(mockAgenciasBloc.stream).thenAnswer(
      (_) => Stream.value(
        const AgenciasLoaded(
          agencias: [Agencia(id: 1, nombre: 'Agencia Central')],
        ),
      ),
    );
  });

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AlertasBloc>.value(value: mockAlertasBloc),
        BlocProvider<AgenciasBloc>.value(value: mockAgenciasBloc),
      ],
      child: MediaQuery(
        data: const MediaQueryData(size: Size(800, 1400)),
        child: const MaterialApp(
          home: CrearAlertaPage(),
        ),
      ),
    );
  }

  group('CrearAlertaPage', () {
    testWidgets('debería mostrar todos los campos del formulario en estado inicial', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Crear Alerta de Paquete'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Nombre del cliente'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Tracking courier'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Cantidad de piezas'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Descripción'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Instrucciones'), findsOneWidget);
      expect(find.text('Courier'), findsOneWidget);
      expect(find.text('Agencia'), findsOneWidget);
      expect(find.text('Tipo de alerta'), findsOneWidget);
      expect(find.text('Flete'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Crear Alerta'), findsOneWidget);
    });

    testWidgets('debería mostrar indicador de carga en estado loading', (
      WidgetTester tester,
    ) async {
      when(mockAlertasBloc.state).thenReturn(const AlertasLoading());
      when(mockAlertasBloc.stream).thenAnswer(
        (_) => Stream.value(const AlertasLoading()),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('debería mostrar mensaje de éxito en estado created', (
      WidgetTester tester,
    ) async {
      when(mockAlertasBloc.state).thenReturn(const AlertasCreated());
      when(mockAlertasBloc.stream).thenAnswer(
        (_) => Stream.value(const AlertasCreated()),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Alerta creada exitosamente'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Nueva Alerta'), findsOneWidget);
    });

    testWidgets('debería mostrar mensaje de error en estado error', (
      WidgetTester tester,
    ) async {
      when(mockAlertasBloc.state).thenReturn(
        const AlertasError(message: 'Error de conexión'),
      );
      when(mockAlertasBloc.stream).thenAnswer(
        (_) => Stream.value(const AlertasError(message: 'Error de conexión')),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Error de conexión'), findsOneWidget);
    });

    testWidgets('debería validar campos requeridos al enviar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final button = find.widgetWithText(ElevatedButton, 'Crear Alerta');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.text('El nombre del cliente es obligatorio'), findsOneWidget);
      expect(find.text('El tracking es obligatorio'), findsOneWidget);
      expect(find.text('Seleccione un courier'), findsOneWidget);
      expect(find.text('Seleccione una agencia'), findsOneWidget);
      expect(find.text('Seleccione un tipo de alerta'), findsOneWidget);
      expect(find.text('Seleccione un tipo de flete'), findsOneWidget);
      expect(find.text('La cantidad de piezas es obligatoria'), findsOneWidget);
      expect(find.text('La descripción es obligatoria'), findsOneWidget);
    });

    testWidgets(
        'debería enviar evento CreateAlerta cuando todos los campos son válidos',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Llenar nombre
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre del cliente'),
        'Juan Pérez',
      );

      // Llenar tracking
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Tracking courier'),
        '1Z999AA10123456784',
      );

      // Llenar cantidad de piezas
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Cantidad de piezas'),
        '5',
      );

      // Llenar descripción
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Descripción'),
        'Electrónicos',
      );

      // Llenar instrucciones
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Instrucciones'),
        'Frágil',
      );

      // Setear dropdowns directamente usando dropdown onChanged callbacks
      // Courier
      final courierDropdown = tester.widget<DropdownButtonFormField<int>>(
        find.byKey(const Key('dropdown_courier')),
      );
      courierDropdown.onChanged!(1);
      await tester.pumpAndSettle();

      // Tipo alerta
      final tipoDropdown = tester.widget<DropdownButtonFormField<int>>(
        find.byKey(const Key('dropdown_tipoalerta')),
      );
      tipoDropdown.onChanged!(1);
      await tester.pumpAndSettle();

      // Agencia
      final agenciaDropdown = tester.widget<DropdownButtonFormField<int>>(
        find.byKey(const Key('dropdown_agencia')),
      );
      agenciaDropdown.onChanged!(1);
      await tester.pumpAndSettle();

      // Flete
      final fleteDropdown = tester.widget<DropdownButtonFormField<String>>(
        find.byKey(const Key('dropdown_flete')),
      );
      fleteDropdown.onChanged!('Aéreo');
      await tester.pumpAndSettle();

      final button = find.widgetWithText(ElevatedButton, 'Crear Alerta');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button);
      await tester.pumpAndSettle();

      verify(mockAlertasBloc.add(argThat(
        isA<CreateAlerta>().having(
          (e) => e.params.nombreCliente,
          'nombreCliente',
          'Juan Pérez',
        ).having(
          (e) => e.params.trackingCourier,
          'trackingCourier',
          '1Z999AA10123456784',
        ).having(
          (e) => e.params.idCourier,
          'idCourier',
          1,
        ).having(
          (e) => e.params.idTipoalerta,
          'idTipoalerta',
          1,
        ).having(
          (e) => e.params.flete,
          'flete',
          'Aéreo',
        ).having(
          (e) => e.params.cantPiezas,
          'cantPiezas',
          5,
        ).having(
          (e) => e.params.descripcion,
          'descripcion',
          'Electrónicos',
        ).having(
          (e) => e.params.instrucciones,
          'instrucciones',
          'Frágil',
        ),
      ))).called(1);
    });

    testWidgets('debería mostrar botón reintentar en estado error', (
      WidgetTester tester,
    ) async {
      when(mockAlertasBloc.state).thenReturn(
        const AlertasError(message: 'Error de conexión'),
      );
      when(mockAlertasBloc.stream).thenAnswer(
        (_) => Stream.value(const AlertasError(message: 'Error de conexión')),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Error de conexión'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Reintentar'), findsOneWidget);
    });

    testWidgets('debería emitir ResetAlerta al presionar Nueva Alerta', (
      WidgetTester tester,
    ) async {
      when(mockAlertasBloc.state).thenReturn(const AlertasCreated());
      when(mockAlertasBloc.stream).thenAnswer(
        (_) => Stream.value(const AlertasCreated()),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final button = find.widgetWithText(ElevatedButton, 'Nueva Alerta');
      await tester.ensureVisible(button);
      await tester.pumpAndSettle();
      await tester.tap(button);
      await tester.pumpAndSettle();

      verify(mockAlertasBloc.add(argThat(isA<ResetAlerta>()))).called(1);
    });
  });
}
