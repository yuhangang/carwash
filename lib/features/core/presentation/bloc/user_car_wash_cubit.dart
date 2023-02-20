import 'dart:async';

import 'package:quickwash/features/core/data/model/order_status.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:quickwash/features/core/data/model/order.dart';
import 'package:quickwash/features/core/data/model/vehicle.dart';
import 'package:quickwash/features/core/data/repo/queue_repository.dart';
part 'user_car_wash_state.dart';

class UserCarWashCubit extends Cubit<UserCarWashState> {
  final QueueRepository _queueRepository;
  late final StreamSubscription<Order> stateListener;

  StreamSubscription<Order>? subscription;

  UserCarWashCubit(
    this._queueRepository,
  ) : super(UserCarWashInitial()) {
    stateListener = _queueRepository
        .getOrderStream()
        .where((event) => event.vehicle.carPlate == "ABC 1234")
        .listen((event) {
      if (event.orderStatus == OrderStatus.queueing) {
        emit(UserCarInQueue(order: event));
      } else if (event.orderStatus == OrderStatus.washing) {
        emit(UserCarInWashing(order: event));
      } else if (event.orderStatus == OrderStatus.readyOrPickUp) {
        emit(UserCarReadyToPickup(order: event));
      } else if (event.orderStatus == OrderStatus.completed) {
        emit(UserCarWashCompleted());
      }
    });
  }

  @override
  Future<void> close() async {
    stateListener.cancel();
    super.close();
  }

  Future<void> putUserInQueue(Vehicle vehicle) async {
    _queueRepository.addOrder(vehicle);
  }

  Future<void> pickUpVehicle(String ticketNumber, Order order) async {
    final exception = await _queueRepository.pickUp(ticketNumber);
    if (exception != null) {
      emit(UserCarWashPickUpError(order: order, exception: exception));
    }
  }
}
