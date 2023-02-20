import 'package:flutter/material.dart';
import 'package:quickwash/features/core/data/model/vehicle.dart';

class MyAppBar extends StatelessWidget {
  final String? ticketNumber;
  const MyAppBar({
    Key? key,
    this.ticketNumber,
    required this.vehicle,
  }) : super(key: key);

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: [
        if (ticketNumber != null)
          Container(
            color: Colors.cyan.shade200,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Your Ticket No",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey.shade900, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  ticketNumber!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                vehicle.carPlate,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                "Perodua Myvi (white)",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 4,
        ),
      ]),
    );
  }
}
