import 'package:equatable/equatable.dart';

import '../../domain/usecases/create_alerta_paquete.dart';

abstract class AlertasEvent extends Equatable {
  const AlertasEvent();

  @override
  List<Object?> get props => [];
}

class CreateAlerta extends AlertasEvent {
  final CreateAlertaPaqueteParams params;

  const CreateAlerta({required this.params});

  @override
  List<Object?> get props => [params];
}

class ResetAlerta extends AlertasEvent {
  const ResetAlerta();
}
