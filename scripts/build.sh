#!/bin/bash
# build.sh — Script de build para Horus Logistic Mobile
# Uso: ./scripts/build.sh [dev|prod] [apk|appbundle|ios|web]

set -e

ENV=${1:-dev}
TARGET=${2:-apk}

echo "🏗️  Build environment: $ENV"
echo "🎯 Build target: $TARGET"

# Verificar que Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter no está instalado o no está en PATH"
    exit 1
fi

# Seleccionar entorno
if [ "$ENV" == "prod" ]; then
    DART_DEFINE="--dart-define=ENV=prod"
    echo "🔒 Usando configuración de PRODUCCIÓN"
else
    DART_DEFINE="--dart-define=ENV=dev"
    echo "🔧 Usando configuración de DESARROLLO"
fi

# Ejecutar build según target
case $TARGET in
    apk)
        echo "📱 Building APK..."
        flutter build apk --release $DART_DEFINE --obfuscate --split-debug-info=symbols/
        ;;
    appbundle)
        echo "📦 Building App Bundle..."
        flutter build appbundle --release $DART_DEFINE --obfuscate --split-debug-info=symbols/
        ;;
    ios)
        echo "🍎 Building iOS..."
        flutter build ios --release $DART_DEFINE --obfuscate --split-debug-info=symbols/
        ;;
    web)
        echo "🌐 Building Web..."
        flutter build web --release $DART_DEFINE
        ;;
    *)
        echo "❌ Target no válido: $TARGET"
        echo "Uso: ./scripts/build.sh [dev|prod] [apk|appbundle|ios|web]"
        exit 1
        ;;
esac

echo "✅ Build completado exitosamente"
