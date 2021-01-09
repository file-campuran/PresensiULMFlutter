import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:absen_online/blocs/notification/bloc.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/models/model.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  @override
  NotificationState get initialState => InitialNotificationState();

  NotificationPageModel _notificationPage;

  void changeNotificationModel() {
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

  @override
  Stream<NotificationState> mapEventToState(event) async* {
    if (event is OnReadDataNotification) {
      print('READNOTIFICATION');
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

      changeNotificationModel();
      yield NotificationData(_notificationPage, _notificationPage.count);
    }

    if (event is OnAddNotification) {
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

      _notificationPage.notification.add(NotificationModel.fromJson(
        {
          "id": 6,
          "isRead": false,
          "title": event.title,
          "content": event.content,
        },
      ));

      changeNotificationModel();
      yield NotificationData(_notificationPage, _notificationPage.count);

      UtilPreferences.setString(
          Preferences.notification, _notificationPage.toString());
    }

    if (event is OnRemoveNotification) {
      _notificationPage.notification.removeAt(event.index);
      UtilPreferences.setString(
          Preferences.notification, _notificationPage.toString());

      changeNotificationModel();

      yield NotificationData(_notificationPage, _notificationPage.count);
    }

    if (event is OnMarkReadNotification) {
      _notificationPage.notification[event.index].isRead = true;
      UtilPreferences.setString(
          Preferences.notification, _notificationPage.toString());

      changeNotificationModel();

      yield NotificationData(_notificationPage, _notificationPage.count);
    }
  }
}
