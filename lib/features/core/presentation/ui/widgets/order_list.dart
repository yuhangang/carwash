import 'package:flutter/material.dart';
import 'package:quickwash/features/core/data/model/order.dart';
import 'package:quickwash/features/core/data/model/order_status.dart';

class OrderList extends StatelessWidget {
  const OrderList({
    super.key,
    required this.queue,
  });

  final List<Order> queue;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding:
            const EdgeInsets.only(bottom: 120, top: 16, left: 16, right: 16),
        itemBuilder: (context, index) {
          final order = queue[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: order.orderStatus == OrderStatus.washing
                    ? Colors.cyan.shade50
                    : Colors.white,
                boxShadow: const [BoxShadow()]),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        Text(order.vehicle.carPlate),
                        if (order.orderStatus == OrderStatus.washing)
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade900,
                            ),
                            child: Text(
                              "Washing",
                              style: TextStyle(color: Colors.grey.shade100),
                            ),
                          )
                      ],
                    )),
                    Text(
                      order.ticketNumber,
                      style: Theme.of(context).textTheme.labelMedium,
                    )
                  ],
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
              height: 12,
            ),
        itemCount: queue.length);
  }
}
