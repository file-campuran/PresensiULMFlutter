part of 'message_cubit.dart';

@immutable
abstract class MessageState {}

class MessageInitial extends MessageState {}

class MessageData extends MessageState {
  int count = 0;
  final List<MessageModel> data;

  MessageData(this.data, this.count);
}
