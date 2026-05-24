# ProGuard rules for Horus Logistic Mobile
# Mantener clases de Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Mantener clases de Dio
-keep class com.google.gson.** { *; }
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Mantener excepciones
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
