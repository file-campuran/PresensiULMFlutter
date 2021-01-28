import 'package:absen_online/models/model.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/configs/config.dart';

class AppNotification {
  NotificationPageModel _notificationPage;

  NotificationPageModel get notification => _notificationPage;

  addNotification(String title, String message) {
    // _notificationPage.count++;
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
        "title": title,
        "content": message,
      },
    ));

    UtilPreferences.setString(
        Preferences.notification, _notificationPage.toString());
  }

  int getCount() {
    _notificationPage.count = 0;
    _notificationPage.notification.forEach((element) {
      if (element.isRead == 0) {
        _notificationPage.count++;
      }
    });

    return _notificationPage.count;
  }

  void markAsRead(int index) {
    _notificationPage.notification[index].isRead = 1;
    UtilPreferences.setString(
        Preferences.notification, _notificationPage.toString());
  }

  void removeNotif(int index) {
    _notificationPage.notification.removeAt(index);
    UtilPreferences.setString(
        Preferences.notification, _notificationPage.toString());
  }

  NotificationPageModel loadNotification() {
    if (_notificationPage == null) {
      print('NULL');
      final notificationPref =
          UtilPreferences.getString(Preferences.notification);

      if (notificationPref != null && notificationPref != '') {
        _notificationPage = notificationPageModelFromJson(notificationPref);
      } else {
        _notificationPage =
            NotificationPageModel.fromJson({'notification': []});
      }
    }

    _notificationPage.notification.sort((a, b) {
      var adate = b.date;
      var bdate = a.date;
      return adate.compareTo(bdate);
    });

    return _notificationPage;
  }

  ///Singleton factory
  static final AppNotification _instance = AppNotification._internal();

  factory AppNotification() {
    return _instance;
  }

  AppNotification._internal();
}
