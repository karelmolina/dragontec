# Horus Logistic Mobile

> Cliente móvil multiplataforma para la API SANCTUM-HORUS.
> Gestión de autenticación, usuarios, clientes, agencias, tracking de paquetes y alertas.

---

## 🚀 Demo en Vivo

**[https://karelmolina.github.io/dragontec/](https://karelmolina.github.io/dragontec/)**

Demo web deployada automáticamente en GitHub Pages en cada push a `main`.

---

## 🛠 Stack Tecnológico

| Capa | Tecnología |
|------|-----------|
| Framework | Flutter 3.44.0 |
| State Management | `flutter_bloc` |
| HTTP Client | `dio` |
| Routing | `go_router` |
| DI | `get_it` |
| Local Storage | `flutter_secure_storage` |
| Firebase | Crashlytics, Analytics, FCM |

---

## 📋 Requisitos

- **Flutter:** 3.44.0 (gestionado via [FVM](https://fvm.app))
- **Dart:** ^3.12.0
- **Java:** 17 (Android)
- **Node:** Para Firebase CLI (opcional)

---

## 🏃‍♂️ Quick Start

### Con FVM (recomendado)

```bash
# Instalar FVM
dart pub global activate fvm

# Usar la versión del proyecto
fvm use

# Correr en modo desarrollo
fvm flutter run --dart-define=API_BASE_URL=https://horus-api/api
```

### Sin FVM

```bash
flutter run --dart-define=API_BASE_URL=https://horus-api/api
```

---

## 🧪 Testing

```bash
# Correr tests
flutter test

# Con coverage
flutter test --coverage

# Análisis estático
flutter analyze
```

---

## 🔧 CI/CD

| Workflow | Trigger | Acción |
|----------|---------|--------|
| `ci-cd.yml` | Push/PR a `main` | Lint, tests, build |
| `github-pages.yml` | Push a `main` | Deploy a GitHub Pages |
| `deploy.yml` | Release publicado | Deploy a tiendas (desactivado) |

---
