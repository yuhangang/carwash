import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickwash/features/core/data/model/order.dart';
import 'package:quickwash/features/core/data/repo/queue_repository.dart';

part 'car_wash_queue_event.dart';
part 'car_wash_queue_state.dart';

class CarWashQueueBloc extends Bloc<CarWashQueueEvent, CarWashQueueState> {
  final QueueRepository _queueRepository;
  Timer? _queueServeTimer;

  late StreamSubscription _sub;
  CarWashQueueBloc(this._queueRepository) : super(CarWashQueueInitial()) {
    Future.delayed(const Duration(seconds: 10), () {
      // _queueServeTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      //   add(CarWashQueueServeEvent());
      // });
    });

    _sub = _queueRepository.getOrderStream().listen((event) {
      add(CarWashQueueAddEvent(order: event));
    });

    on<CarWashQueueAddEvent>((event, emit) {
      final washing = _queueRepository.getCurrentWashingCar();
      emit(CarWashQueueLoaded(
          queue: [
            if (washing != null) washing,
            ...(_queueRepository.getQueue())
          ],
          washing: null,
          orderToBePickedUp: _queueRepository.getOrderToBePickedUp()));
    });

    on<CarWashQueueLoadingEvent>((event, emit) {
      _queueRepository.initStream();
    });
  }

  @override
  Future<void> close() {
    _queueServeTimer?.cancel();
    _sub.cancel();
    return super.close();
  }
}
