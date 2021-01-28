import 'package:absen_online/configs/db_provider.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/models/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageInitial());

  List<MessageModel> listMessage = [];
  int countNotRead = 0;

  void readMessage() async {
    // await clearLocalData();
    Database db = await DBProvider.db.database;
    if (listMessage.isEmpty) {
      FirebaseFirestore.instance
          .collection('message')
          .orderBy('published_at', descending: true)
          .get()
          .then((QuerySnapshot querySnapshot) {
        listMessage = [];
        querySnapshot.docs.forEach((element) async {
          MessageModel messageModel = MessageModel.fromJson(element.data());
          await db.insert(
            'Messages',
            messageModel.toJson(),
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        });
        loadData();
      });
    } else {
      loadData();
    }
  }

  void loadData() async {
    Database db = await DBProvider.db.database;

    var res =
        await db.rawQuery('SELECT * FROM Messages ORDER BY published_at DESC');
    listMessage =
        res.isNotEmpty ? res.map((c) => MessageModel.fromJson(c)).toList() : [];
    countNotRead = await countRead();
    emit(MessageData(listMessage, countNotRead));
  }

  void markAsRead(String id) async {
    Database db = await DBProvider.db.database;

    await db.update('Messages', {'read_at': 1},
        where: 'id = ?', whereArgs: [id]);

    loadData();
  }

  void markAll(int readAt) async {
    Database db = await DBProvider.db.database;

    await db.update(
      'Messages',
      {'read_at': readAt},
    );

    loadData();
  }

  Future<int> countRead() async {
    Database db = await DBProvider.db.database;

    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM Messages WHERE read_at = 0'));
  }

  //Clear all data from db
  Future<void> clearLocalData() async {
    Database db = await DBProvider.db.database;

    await db.rawDelete('Delete from Messages');
  }
}
