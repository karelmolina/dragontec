# Workflows Desactivados

Esta carpeta contiene workflows de GitHub Actions que están temporalmente desactivados.

## deploy.yml

**Estado:** Desactivado (movido desde `.github/workflows/`)
**Razón:** El proyecto aún no está listo para deploy automático a tiendas.

### ¿Cuándo reactivarlo?

Reactivar cuando:
1. El proyecto Firebase esté configurado con archivos reales
2. El keystore de Android esté generado
3. Las cuentas de Google Play Console y App Store Connect estén creadas
4. Los secrets de GitHub estén configurados:
   - `ANDROID_KEYSTORE_BASE64`
   - `ANDROID_KEYSTORE_PASSWORD`
   - `ANDROID_KEY_PASSWORD`
   - `ANDROID_KEY_ALIAS`
   - `PLAY_STORE_SERVICE_ACCOUNT`
   - `APPSTORE_ISSUER_ID`
   - `APPSTORE_API_KEY_ID`
   - `APPSTORE_API_PRIVATE_KEY`

### Cómo reactivar

```bash
mv .github/workflows/disabled/deploy.yml .github/workflows/
```

Luego hacer commit y push.

---

*Desactivado el: 2026-05-24*
