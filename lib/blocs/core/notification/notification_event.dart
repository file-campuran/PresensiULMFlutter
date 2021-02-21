abstract class NotificationEvent {}

class OnReadDataNotification extends NotificationEvent {}

class OnAddNotification extends NotificationEvent {
  final String title;
  final String content;

  OnAddNotification(this.title, this.content);
}

class OnRemoveNotification extends NotificationEvent {
  final String id;

  OnRemoveNotification(this.id);
}

class OnMarkReadNotification extends NotificationEvent {
  final String id;

  OnMarkReadNotification(this.id);
}

class OnMarkAllReadNotification extends NotificationEvent {}

class OnGetCountNotification extends NotificationEvent {}
