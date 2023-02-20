import 'dart:async';

import 'package:quickwash/core/commons/constant.dart';
import 'package:quickwash/core/utils/random/random_generator.dart';
import 'package:quickwash/features/core/data/model/order.dart';
import 'package:quickwash/features/core/data/model/order_status.dart';
import 'package:quickwash/features/core/data/model/vehicle.dart';
import 'package:queue/queue.dart';

abstract class QueueRepository {
  List<Order> getQueue();
  List<Order> getOrderToBePickedUp();
  Order? getCurrentWashingCar();

  void initStream();
  Stream<Order> getOrderStream();
  Future<void> addOrder(Vehicle vehicle);
  Future<Exception?> pickUp(String ticketNumber);
}

class QueueRepositoryImpl implements QueueRepository {
  final CircularQueue<Order> _queue = CircularQueue();
  int _counter = 0;
  final List<Order> _orderToBePickedUp = [];
  final _streamController = StreamController<Order>.broadcast();

  QueueRepositoryImpl();
  Order? washing;

  @override
  List<Order> getQueue() => _queue.getQueue();
  @override
  List<Order> getOrderToBePickedUp() => _orderToBePickedUp;
  @override
  Order? getCurrentWashingCar() => washing;

  String get _nextTicketNumber {
    _counter++;
    return "#${_counter.toString().padLeft(6, "0")}";
  }

  @override
  void initStream() {
    addOrder(Vehicle(carPlate: getRandomCarPlate()));
    addOrder(Vehicle(carPlate: getRandomCarPlate()));
    addOrder(Vehicle(carPlate: getRandomCarPlate()));

    Timer.periodic(const Duration(seconds: AppConfig.newQueueFrequencyInSecond),
        (timer) {
      addOrder(Vehicle(carPlate: getRandomCarPlate()));
    });
  }

  serveStream() async {
    if (_queue.isNotEmpty()) {
      if (washing == null) {
        washing = Order.moveVehicleToWashingPoint(_queue.dequeue());
        _streamController.sink.add(washing!);
        Future.delayed(
            const Duration(seconds: AppConfig.carWashFrequencyInSecond), () {
          var order = Order.moveVehicleToPickOutPoint(washing!);
          _streamController.sink.add(order);
          _orderToBePickedUp.insert(0, order);

          washing = null;
        });
      } else {
        await _streamController.stream
            .firstWhere((e) => e.orderStatus == OrderStatus.readyOrPickUp);
        serveStream();
      }
    }
  }

  @override
  Stream<Order> getOrderStream() => _streamController.stream;

  @override
  Future<void> addOrder(Vehicle vehicle) async {
    final order =
        Order.create(ticketNumber: _nextTicketNumber, vehicle: vehicle);
    _streamController.sink.add(order);
    _queue.enqueue(order);
    serveStream();
  }

  @override
  Future<Exception?> pickUp(String ticketNumber) async {
    final index = _orderToBePickedUp
        .indexWhere((element) => element.ticketNumber == ticketNumber);
    if (index != -1) {
      final order = _orderToBePickedUp.removeAt(index);
      _streamController.sink.add(Order.complete(order));
      return null;
    } else {
      return Exception("Invalid tickets");
    }
  }
}
