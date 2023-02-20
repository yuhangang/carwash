part of 'user_car_wash_cubit.dart';

@immutable
abstract class UserCarWashState {}

class UserCarWashInitial extends UserCarWashState {}

class UserCarWashCompleted extends UserCarWashState {}

class UserCarInQueue extends UserCarWashState {
  final Order order;
  UserCarInQueue({
    required this.order,
  });
}

class UserCarInWashing extends UserCarWashState {
  final Order order;
  UserCarInWashing({
    required this.order,
  });
}

class UserCarReadyToPickup extends UserCarWashState {
  final Order order;
  UserCarReadyToPickup({
    required this.order,
  });
}
