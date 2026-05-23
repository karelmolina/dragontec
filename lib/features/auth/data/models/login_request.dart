class LoginRequest {
  final String usuario;
  final String clave;
  final String deviceName;

  LoginRequest({
    required this.usuario,
    required this.clave,
    required this.deviceName,
  });

  Map<String, dynamic> toJson() => {
        'usuario': usuario,
        'clave': clave,
        'device_name': deviceName,
      };
}
