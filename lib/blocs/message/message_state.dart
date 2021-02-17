part of 'message_cubit.dart';

@immutable
abstract class MessageState {}

class MessageInitial extends MessageState {}

class MessageData extends MessageState {
  final int count;
  final List<MessageModel> data;

  MessageData(this.data, [this.count = 0]);
}
