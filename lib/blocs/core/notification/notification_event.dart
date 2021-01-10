abstract class NotificationEvent {}

class OnReadDataNotification extends NotificationEvent {}

class OnAddNotification extends NotificationEvent {
  final String title;
  final String content;

  OnAddNotification(this.title, this.content);
}

class OnRemoveNotification extends NotificationEvent {
  final int index;

  OnRemoveNotification(this.index);
}

class OnMarkReadNotification extends NotificationEvent {
  final int index;

  OnMarkReadNotification(this.index);
}

class OnGetCountNotification extends NotificationEvent {}
