import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';
import 'core/services/firebase_service.dart';
import 'injection_container.dart';

/// Entorno de ejecución detectado vía --dart-define o fallback a .env
const String _environment = String.fromEnvironment(
  'ENV',
  defaultValue: 'dev',
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase (solo en plataformas nativas, no web)
  if (!kIsWeb) {
    try {
      await FirebaseService().initialize();
    } catch (_) {
      // Firebase no está configurado — continuar sin él
    }
  }

  // Cargar .env solo si existe (opcional gracias a dart-define)
  final envFile = _environment == 'prod' ? '.env.prod' : '.env.dev';
  try {
    await dotenv.load(fileName: envFile);
  } catch (_) {
    // .env no encontrado — confiar en dart-define o fallar luego
  }

  await initDependencies();
  runApp(const DragontecApp());
}
