import 'package:equatable/equatable.dart';

abstract class TrackingEvent extends Equatable {
  const TrackingEvent();

  @override
  List<Object?> get props => [];
}

class SearchTracking extends TrackingEvent {
  final String trackingCourier;

  const SearchTracking({required this.trackingCourier});

  @override
  List<Object?> get props => [trackingCourier];
}
