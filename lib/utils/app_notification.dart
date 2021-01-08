import 'package:absen_online/models/model.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/configs/config.dart';

class AppNotification {
  addNotification(String title, String message) {
    NotificationPageModel _notificationPage;

    final notificationPref =
        UtilPreferences.getString(Preferences.notification);

    if (notificationPref != null && notificationPref != '') {
      _notificationPage = notificationPageModelFromJson(notificationPref);
    } else {
      _notificationPage = NotificationPageModel.fromJson({'notification': []});
    }

    _notificationPage.notification.add(NotificationModel.fromJson(
      {
        "id": 6,
        "title": title,
        "subtitle": message,
      },
    ));

    UtilPreferences.setString(
        Preferences.notification, _notificationPage.toString());
  }

  NotificationPageModel loadNotification() {
    NotificationPageModel _notificationPage;

    final notificationPref =
        UtilPreferences.getString(Preferences.notification);

    if (notificationPref != null && notificationPref != '') {
      _notificationPage = notificationPageModelFromJson(notificationPref);
      _notificationPage.notification.sort((a, b) {
        var adate = b.date;
        var bdate = a.date;
        return adate.compareTo(bdate);
      });
    } else {
      _notificationPage = NotificationPageModel.fromJson({'notification': []});
    }

    return _notificationPage;
  }

  ///Singleton factory
  static final AppNotification _instance = AppNotification._internal();

  factory AppNotification() {
    return _instance;
  }

  AppNotification._internal();
}
