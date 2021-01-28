import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<int> {
  MessageCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
