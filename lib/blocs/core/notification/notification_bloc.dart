import 'dart:async';

import 'package:bloc/bloc.dart';
import 'bloc.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/models/model.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  @override
  NotificationState get initialState => InitialNotificationState();

  NotificationPageModel _notificationPage;

  void _changeNotificationModel() {
    _notificationPage.notification.sort((a, b) {
      var adate = b.date;
      var bdate = a.date;
      return adate.compareTo(bdate);
    });

    _notificationPage.count = 0;
    _notificationPage.notification.forEach((element) {
      if (!element.isRead) {
        _notificationPage.count++;
      }
    });
  }

  void _getNotificationData() {
    if (_notificationPage == null) {
      final notificationPref =
          UtilPreferences.getString(Preferences.notification);

      if (notificationPref != null && notificationPref != '') {
        _notificationPage = notificationPageModelFromJson(notificationPref);
      } else {
        _notificationPage =
            NotificationPageModel.fromJson({'notification': []});
      }
    }
  }

  void _saveNotification() {
    UtilPreferences.setString(
        Preferences.notification, _notificationPage.toString());
  }

  @override
  Stream<NotificationState> mapEventToState(event) async* {
    // OnReadDataNotification
    if (event is OnReadDataNotification) {
      _getNotificationData();
      _changeNotificationModel();
      yield NotificationData(_notificationPage);
    }

    // OnAddNotification
    if (event is OnAddNotification) {
      _notificationPage.notification.add(NotificationModel.fromJson(
        {
          "id": 6,
          "isRead": false,
          "title": event.title,
          "content": event.content,
        },
      ));

      _changeNotificationModel();
      yield NotificationData(_notificationPage);
      _saveNotification();
    }

    if (event is OnRemoveNotification) {
      _notificationPage.notification.removeAt(event.index);
      _saveNotification();
      _changeNotificationModel();

      yield NotificationData(_notificationPage);
    }

    if (event is OnMarkReadNotification) {
      _notificationPage.notification[event.index].isRead = true;
      _saveNotification();
      _changeNotificationModel();

      yield NotificationData(_notificationPage);
    }
  }
}
