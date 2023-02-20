part of 'car_wash_queue_bloc.dart';

@immutable
abstract class CarWashQueueState {}

class CarWashQueueInitial extends CarWashQueueState {}

class CarWashQueueError extends CarWashQueueState {}

class CarWashQueueLoaded extends CarWashQueueState {
  final List<Order> queue;
  final Order? washing;
  final List<Order> orderToBePickedUp;
  CarWashQueueLoaded({
    required this.queue,
    this.washing,
    required this.orderToBePickedUp,
  });
}
