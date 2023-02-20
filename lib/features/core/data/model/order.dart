import 'package:quickwash/features/core/data/model/order_status.dart';
import 'package:quickwash/features/core/data/model/vehicle.dart';

class Order {
  final String ticketNumber;
  final OrderStatus orderStatus;
  final Vehicle vehicle;

  Order.create({
    required this.ticketNumber,
    required this.vehicle,
  }) : orderStatus = OrderStatus.queueing;

  Order._({
    required this.ticketNumber,
    required this.orderStatus,
    required this.vehicle,
  });

  factory Order.moveVehicleToWashingPoint(Order order) => Order._(
      ticketNumber: order.ticketNumber,
      orderStatus: OrderStatus.washing,
      vehicle: order.vehicle);

  factory Order.moveVehicleToPickOutPoint(Order order) => Order._(
      ticketNumber: order.ticketNumber,
      orderStatus: OrderStatus.readyOrPickUp,
      vehicle: order.vehicle);

  factory Order.complete(Order order) => Order._(
      ticketNumber: order.ticketNumber,
      orderStatus: OrderStatus.completed,
      vehicle: order.vehicle);
}
