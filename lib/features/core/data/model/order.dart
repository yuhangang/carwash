import 'package:quickwash/features/core/data/model/order_status.dart';
import 'package:quickwash/features/core/data/model/vehicle.dart';

class Order {
  final String ticket;
  final OrderStatus orderStatus;
  final Vehicle vehicle;

  Order.create({
    required this.ticket,
    required this.vehicle,
  }) : orderStatus = OrderStatus.queueing;

  Order._({
    required this.ticket,
    required this.orderStatus,
    required this.vehicle,
  });

  factory Order.moveVehicleToWashingPoint(Order order) => Order._(
      ticket: order.ticket,
      orderStatus: OrderStatus.washing,
      vehicle: order.vehicle);

  factory Order.moveVehicleToPickOutPoint(Order order) => Order._(
      ticket: order.ticket,
      orderStatus: OrderStatus.readyOrPickUp,
      vehicle: order.vehicle);

  factory Order.complete(Order order) => Order._(
      ticket: order.ticket,
      orderStatus: OrderStatus.completed,
      vehicle: order.vehicle);
}
