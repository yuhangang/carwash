part of 'car_wash_queue_bloc.dart';

@immutable
abstract class CarWashQueueEvent {}

class CarWashQueueAddEvent extends CarWashQueueEvent {
  final Order order;
  CarWashQueueAddEvent({
    required this.order,
  });
}

class CarWashQueueLoadingEvent extends CarWashQueueEvent {}

class CarWashQueueServeEvent extends CarWashQueueEvent {}
