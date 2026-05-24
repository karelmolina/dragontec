class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException: $message (status: $statusCode)';
}

class CacheException implements Exception {
  final String message;

  const CacheException({required this.message});

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({required this.message});

  @override
  String toString() => 'NetworkException: $message';
}

class UnauthorizedException implements Exception {
  final String message;

  const UnauthorizedException({this.message = 'Unauthorized'});

  @override
  String toString() => 'UnauthorizedException: $message';
}

class ConfigException implements Exception {
  final String message;

  const ConfigException({required this.message});

  @override
  String toString() => 'ConfigException: $message';
}

class NotFoundException implements Exception {
  final String message;

  const NotFoundException({this.message = 'Recurso no encontrado'});

  @override
  String toString() => 'NotFoundException: $message';
}

class ValidationException implements Exception {
  final String message;

  const ValidationException({this.message = 'Datos inválidos'});

  @override
  String toString() => 'ValidationException: $message';
}
