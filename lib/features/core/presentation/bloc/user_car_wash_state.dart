part of 'user_car_wash_cubit.dart';

@immutable
abstract class UserCarWashState {}

class UserCarWashInitial extends UserCarWashState {}

class UserCarWashCompleted extends UserCarWashState {}

abstract class UserHasActiveOrder extends UserCarWashState {
  final Order order;
  UserHasActiveOrder({
    required this.order,
  });
}

class UserCarInQueue extends UserHasActiveOrder {
  UserCarInQueue({
    required super.order,
  });
}

class UserCarInWashing extends UserHasActiveOrder {
  UserCarInWashing({
    required super.order,
  });
}

class UserCarReadyToPickup extends UserHasActiveOrder {
  UserCarReadyToPickup({
    required super.order,
  });
}

class UserCarWashPickUpError extends UserCarReadyToPickup {
  final Exception exception;
  UserCarWashPickUpError({
    required super.order,
    required this.exception,
  });
}
