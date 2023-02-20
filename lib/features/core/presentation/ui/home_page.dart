import 'package:quickwash/features/core/data/model/order.dart';
import 'package:quickwash/features/core/data/model/order_status.dart';
import 'package:quickwash/features/core/data/model/vehicle.dart';
import 'package:quickwash/features/core/presentation/bloc/car_wash_queue_bloc.dart';
import 'package:quickwash/features/core/presentation/bloc/user_car_wash_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final carWashQueueBloc = BlocProvider.of<CarWashQueueBloc>(context);
  late final userCarWashCubit = BlocProvider.of<UserCarWashCubit>(context);
  static const vehicle = Vehicle(carPlate: "ABC 1234");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<UserCarWashCubit, UserCarWashState>(
          builder: (context, state) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(children: [
                Row(
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
                      "Perodua Myvi (White)",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ]),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFAB(),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                      labelPadding: EdgeInsets.all(16),
                      tabs: [Text("In Queue"), Text("Ready for Pickup")]),
                  Expanded(
                    child: BlocBuilder<CarWashQueueBloc, CarWashQueueState>(
                      builder: (context, state) {
                        final List<Order> queue =
                            state is CarWashQueueLoaded ? state.queue : [];
                        final List<Order> orderToBePickedUp =
                            state is CarWashQueueLoaded
                                ? state.orderToBePickedUp
                                : [];
                        return TabBarView(
                          children: [
                            CarList(queue: queue),
                            CarList(queue: orderToBePickedUp),
                          ],
                        );
                      },
                    ),
                  ),
                  BlocBuilder<UserCarWashCubit, UserCarWashState>(
                    builder: (context, state) {
                      if (state is UserCarInQueue) {
                        return _buildBottomBanner(context,
                            title: "In queue ...",
                            color: Colors.yellowAccent.shade700);
                      }

                      if (state is UserCarInWashing) {
                        return _buildBottomBanner(context,
                            title: "Washing your car ...",
                            color: Colors.lightBlue.shade300);
                      }

                      return const SizedBox.shrink();
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildBottomBanner(BuildContext context,
      {required String title, required Color color}) {
    return Container(
      color: color,
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SafeArea(
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  MaterialAccentColor getContainerColorByState(UserCarWashState state) =>
      Colors.cyanAccent;

  Widget _buildFAB() {
    return BlocConsumer<UserCarWashCubit, UserCarWashState>(
      listener: (context, state) {
        if (state is UserCarWashCompleted) {
          Fluttertoast.showToast(msg: "Thank you for choosing QuickWash!");
        }
      },
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Builder(builder: (context) {
                  if (state is UserCarReadyToPickup) {
                    return FloatingActionButton.extended(
                      onPressed: () async {
                        userCarWashCubit.pickUpVehicle(state.order);
                      },
                      backgroundColor: Colors.lightGreen,
                      icon: const Icon(Icons.queue),
                      label: const Text("Pick Up"),
                    );
                  }
                  if (state is UserCarWashInitial ||
                      state is UserCarWashCompleted) {
                    return FloatingActionButton.extended(
                      onPressed: () async {
                        userCarWashCubit.putUserInQueue(vehicle);
                      },
                      backgroundColor: Colors.cyan.shade600,
                      icon: const Icon(Icons.local_car_wash),
                      label: const Text("Join the Queue"),
                    );
                  }

                  return const SizedBox.shrink();
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CarList extends StatelessWidget {
  const CarList({
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
                      "#${order.ticket}",
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
