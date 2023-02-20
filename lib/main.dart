import 'package:quickwash/features/core/data/repo/queue_repository.dart';
import 'package:quickwash/features/core/presentation/bloc/car_wash_queue_bloc.dart';
import 'package:quickwash/features/core/presentation/bloc/user_car_wash_cubit.dart';
import 'package:quickwash/features/core/presentation/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final queueRepositoryImpl = QueueRepositoryImpl();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => CarWashQueueBloc(queueRepositoryImpl),
        ),
        BlocProvider(
          create: (context) => UserCarWashCubit(queueRepositoryImpl),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
