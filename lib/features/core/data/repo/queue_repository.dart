import 'dart:async';

import 'package:quickwash/core/commons/constant.dart';
import 'package:quickwash/core/utils/random/random_generator.dart';
import 'package:quickwash/features/core/data/model/order.dart';
import 'package:quickwash/features/core/data/model/order_status.dart';
import 'package:quickwash/features/core/data/model/vehicle.dart';
import 'package:queue/queue.dart';

abstract class QueueRepository {
  Stream<Order> getOrderStream();
  Future<void> addOrder(Vehicle vehicle);
  List<Order> getQueue();
  List<Order> getOrderToBePickedUp();
  Order? getCurrentWashingCar();
  Future<void> pickUp(Order order);
}

class QueueRepositoryImpl implements QueueRepository {
  final CircularQueue<Order> _queue = CircularQueue();
  int _counter = 0;
  Timer? carPlateGenerationTimer;
  final List<Order> _orderToBePickedUp = [];

  QueueRepositoryImpl() {
    initStream();
  }
  Order? washing;

  String get _nextTicketNumber {
    _counter++;
    return _counter.toString().padLeft(6, "0");
  }

  final controller = StreamController<Order>.broadcast();

  initStream() {
    carPlateGenerationTimer = Timer.periodic(
        const Duration(seconds: AppConfig.newQueueFrequencyInSecond), (timer) {
      addOrder(Vehicle(carPlate: getRandomCarPlate()));
    });

    controller.stream
        .where((event) => event.orderStatus == OrderStatus.readyOrPickUp)
        .listen((event) {});
  }

  serveStream() async {
    if (_queue.isNotEmpty()) {
      if (washing == null) {
        washing = Order.moveVehicleToWashingPoint(_queue.dequeue());
        controller.sink.add(washing!);
        Future.delayed(
            const Duration(seconds: AppConfig.carWashFrequencyInSecond), () {
          var order = Order.moveVehicleToPickOutPoint(washing!);
          controller.sink.add(order);
          _orderToBePickedUp.insert(0, order);

          washing = null;
        });
      } else {
        await controller.stream
            .firstWhere((e) => e.orderStatus == OrderStatus.readyOrPickUp);
        serveStream();
      }
    }
  }

  @override
  Stream<Order> getOrderStream() => controller.stream;

  @override
  Future<void> addOrder(Vehicle vehicle) async {
    final order = Order.create(ticket: _nextTicketNumber, vehicle: vehicle);
    controller.sink.add(order);
    _queue.enqueue(order);
    serveStream();
  }

  @override
  List<Order> getQueue() => _queue.getQueue();

  @override
  List<Order> getOrderToBePickedUp() => _orderToBePickedUp;

  @override
  Order? getCurrentWashingCar() => washing;

  @override
  Future<void> pickUp(Order order) async {
    if (_orderToBePickedUp.contains(order)) {
      bool success = _orderToBePickedUp.remove(order);
      if (success) {
        controller.sink.add(Order.complete(order));
      }
    }
  }
}
