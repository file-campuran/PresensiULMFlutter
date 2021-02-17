import 'dart:async';

import 'package:bloc/bloc.dart';
import 'bloc.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/models/model.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(InitialNotificationState());

  @override
  // ignore: override_on_non_overriding_member
  NotificationState get initialState => InitialNotificationState();
  NotificationPageModel _notificationPage;

  void _changeNotificationModel() {
    _notificationPage.count = 0;
    _notificationPage.notification.forEach((element) {
      if (element.isRead == 0) {
        _notificationPage.count++;
      }
    });
  }

  Future _getNotificationData() async {
    if (_notificationPage == null) {
      Database db = await DBProvider.db.database;
      UtilLogger.log('START READ', new DateTime.now());
      var res =
          await db.rawQuery('SELECT * FROM Notification ORDER BY date DESC');
      UtilLogger.log('END READ', new DateTime.now());
      List<NotificationModel> notificationModel = res.isNotEmpty
          ? res.map((c) => NotificationModel.fromJson(c)).toList()
          : [];

      _notificationPage = NotificationPageModel(notificationModel, 0);
    }
  }

  @override
  Stream<NotificationState> mapEventToState(event) async* {
    // OnReadDataNotification
    if (event is OnReadDataNotification) {
      await _getNotificationData();
      _changeNotificationModel();
      yield NotificationData(_notificationPage);
    }

    // OnAddNotification
    if (event is OnAddNotification) {
      final notificationModel = NotificationModel.fromJson(
        {
          "id": new DateTime.now().millisecondsSinceEpoch,
          "isRead": 0,
          "title": event.title,
          "content": event.content,
        },
      );

      Database db = await DBProvider.db.database;
      await db.insert(
        'Notification',
        notificationModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );

      _notificationPage.notification.insert(0, notificationModel);

      _changeNotificationModel();
      yield NotificationData(_notificationPage);
    }

    if (event is OnRemoveNotification) {
      Database db = await DBProvider.db.database;
      await db.delete('Notification', where: 'id = ?', whereArgs: [event.id]);
      _notificationPage.notification.removeWhere((item) => item.id == event.id);
      _changeNotificationModel();

      yield NotificationData(_notificationPage);
    }

    if (event is OnMarkReadNotification) {
      _notificationPage.notification.forEach((element) {
        if (element.id == event.id) {
          element.isRead = 1;
        }
      });

      Database db = await DBProvider.db.database;

      await db.update('Notification', {'isRead': 1},
          where: 'id = ?', whereArgs: [event.id]);

      _changeNotificationModel();

      yield NotificationData(_notificationPage);
    }
  }
}
