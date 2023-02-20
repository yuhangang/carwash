import 'package:quickwash/features/core/data/model/order.dart';
import 'package:quickwash/features/core/data/model/vehicle.dart';
import 'package:quickwash/features/core/presentation/bloc/car_wash_queue_bloc.dart';
import 'package:quickwash/features/core/presentation/bloc/user_car_wash_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickwash/features/core/presentation/ui/widgets/ticket_number_input_dialog.dart';
import 'package:quickwash/features/core/presentation/ui/widgets/order_list.dart';
import 'package:quickwash/features/core/presentation/ui/widgets/my_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final carWashQueueBloc = BlocProvider.of<CarWashQueueBloc>(context);
  late final userCarWashCubit = BlocProvider.of<UserCarWashCubit>(context);
  static const vehicle = Vehicle(carPlate: "ABC 1234");
  late final TabController _tabController =
      TabController(length: 2, vsync: this);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      carWashQueueBloc.add(CarWashQueueLoadingEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCarWashCubit, UserCarWashState>(
      builder: (context, state) {
        return Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(
                  state is UserHasActiveOrder ? 95 : kToolbarHeight),
              child: MyAppBar(
                vehicle: vehicle,
                ticketNumber: state is UserHasActiveOrder
                    ? state.order.ticketNumber
                    : null,
              )),
          floatingActionButton: _buildFAB(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: Column(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    TabBar(
                        labelPadding: const EdgeInsets.all(16),
                        controller: _tabController,
                        tabs: const [
                          Text("In Queue"),
                          Text("Ready for Pickup")
                        ]),
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
                            controller: _tabController,
                            children: [
                              OrderList(queue: queue),
                              OrderList(queue: orderToBePickedUp),
                            ],
                          );
                        },
                      ),
                    ),
                    _buildBottomStatusBar()
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomStatusBar() {
    return BlocConsumer<UserCarWashCubit, UserCarWashState>(
      listener: (context, state) {
        if (state is UserCarInQueue) {
          Fluttertoast.showToast(
              msg: "You ticket number is ${state.order.ticketNumber}");
        }
        if (state is UserCarWashCompleted) {
          Fluttertoast.showToast(msg: "Thank you for choosing QuickWash!");
        } else if (state is UserCarWashPickUpError) {
          Fluttertoast.showToast(msg: state.exception.toString());
        }
      },
      builder: (context, state) {
        if (state is UserCarInQueue) {
          return _buildBottomBanner(context,
              title: "In queue ...", color: Colors.yellowAccent.shade700);
        }

        if (state is UserCarInWashing) {
          return _buildBottomBanner(context,
              title: "Washing your car ...", color: Colors.lightBlue.shade300);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBottomBanner(BuildContext context,
      {required String title, required Color color, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }

  MaterialAccentColor getContainerColorByState(UserCarWashState state) =>
      Colors.cyanAccent;

  Widget _buildFAB() {
    return BlocBuilder<UserCarWashCubit, UserCarWashState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Builder(builder: (context) {
                  if (state is UserCarWashInitial ||
                      state is UserCarWashCompleted) {
                    return FloatingActionButton.extended(
                      elevation: 1,
                      onPressed: () async {
                        userCarWashCubit.putUserInQueue(vehicle);
                      },
                      backgroundColor: Colors.cyan.shade600,
                      icon: const Icon(Icons.local_car_wash),
                      label: const Text("Join the Queue"),
                    );
                  }

                  if (state is UserCarReadyToPickup) {
                    return FloatingActionButton.extended(
                      elevation: 1,
                      onPressed: () async {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) {
                            return const TicketNumberInputDialog();
                          },
                        ).then((value) {
                          if (value != null) {
                            userCarWashCubit.pickUpVehicle(value, state.order);
                          }
                        });
                      },
                      backgroundColor: Colors.lightGreen.shade400,
                      icon: const Icon(Icons.local_car_wash),
                      label: const Text("Ready To Pickup"),
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
