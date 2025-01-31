import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(const CounterInitialState());

  void increment() {
    final int newCounter = state.counter + 1;
    final newStatus = newCounter % 2 == 0 ? 'GENAP' : 'GANJIL';
    emit(CounterState(counter: newCounter, status: newStatus));
  }

  void decrement() {
    final int newCounter = state.counter - 1;
    final newStatus = newCounter % 2 == 0 ? 'GENAP' : 'GANJIL';
    emit(CounterState(counter: newCounter, status: newStatus));
  }
}
