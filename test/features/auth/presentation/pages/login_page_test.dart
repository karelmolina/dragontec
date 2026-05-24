import 'package:dragontec/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dragontec/features/auth/presentation/bloc/auth_event.dart';
import 'package:dragontec/features/auth/presentation/bloc/auth_state.dart';
import 'package:dragontec/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthBloc>()])
void main() {
  late MockAuthBloc mockBloc;

  setUp(() {
    mockBloc = MockAuthBloc();
    when(mockBloc.state).thenReturn(const AuthInitial());
    when(mockBloc.stream).thenAnswer(
      (_) => Stream.value(const AuthInitial()),
    );
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockBloc,
        child: const LoginPage(),
      ),
    );
  }

  group('LoginPage', () {
    testWidgets('debería mostrar campos de usuario y contraseña', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Usuario'), findsOneWidget);
      expect(find.text('Contraseña'), findsOneWidget);
    });

    testWidgets('debería mostrar botón de iniciar sesión', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('INICIAR SESIÓN'), findsOneWidget);
    });

    testWidgets('debería validar campos vacíos', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('INICIAR SESIÓN'));
      await tester.pump();

      expect(find.text('Ingrese su usuario'), findsOneWidget);
      expect(find.text('Ingrese su contraseña'), findsOneWidget);
    });

    testWidgets('debería enviar LoginRequested al presionar botón', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Usuario'),
        'testuser',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Contraseña'),
        'password',
      );
      await tester.tap(find.text('INICIAR SESIÓN'));
      await tester.pump();

      verify(mockBloc.add(argThat(
        isA<LoginRequested>().having(
          (e) => e.usuario,
          'usuario',
          'testuser',
        ),
      ))).called(1);
    });

    testWidgets('debería mostrar indicador de carga en estado loading', (
      WidgetTester tester,
    ) async {
      when(mockBloc.state).thenReturn(const AuthLoading());
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.value(const AuthLoading()),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('debería mostrar error en estado error', (
      WidgetTester tester,
    ) async {
      when(mockBloc.state).thenReturn(const AuthError('Error de login'));
      when(mockBloc.stream).thenAnswer(
        (_) => Stream.value(const AuthError('Error de login')),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(); // Pump para que el BlocListener muestre el SnackBar

      expect(find.text('Error de login'), findsOneWidget);
    });
  });
}
