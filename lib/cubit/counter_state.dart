part of 'counter_cubit.dart';

@immutable
class CounterState {
  final int counter;
  final String? status;
  final Color statusColor;

  const CounterState({required this.counter, this.status})
      : statusColor = status == 'GENAP' ? Colors.green : Colors.red;
}

class CounterInitialState extends CounterState {
  const CounterInitialState() : super(counter: 0, status: 'GENAP');
}
