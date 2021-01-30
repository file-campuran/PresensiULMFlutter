import 'package:absen_online/configs/config.dart';
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
    if (listMessage.isEmpty) {
      FirebaseFirestore.instance
          .collection('message')
          .orderBy('published_at', descending: true)
          .get()
          .then((QuerySnapshot querySnapshot) {
        listMessage = [];
        querySnapshot.docs.forEach((element) async {
          Map<String, dynamic> model = element.data();
          model['id'] = element.id;
          MessageModel messageModel = MessageModel.fromJson(model);
          await Application.db.insert(
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
    var res = await Application.db
        .rawQuery('SELECT * FROM Messages ORDER BY published_at DESC');
    listMessage =
        res.isNotEmpty ? res.map((c) => MessageModel.fromJson(c)).toList() : [];
    countNotRead = await countUnRead();
    emit(MessageData(listMessage, countNotRead));
  }

  void markAsRead(String id) async {
    await Application.db
        .update('Messages', {'read_at': 1}, where: 'id = ?', whereArgs: [id]);

    loadData();
  }

  /*
   * Read = 1
   * Unread = 0
   */
  void markAll(int readAt) async {
    await Application.db.update(
      'Messages',
      {'read_at': readAt},
    );

    loadData();
  }

  Future<int> countUnRead() async {
    return Sqflite.firstIntValue(await Application.db
        .rawQuery('SELECT COUNT(*) FROM Messages WHERE read_at = 0'));
  }

  //Clear all data from db
  Future<void> clearLocalData() async {
    await Application.db.rawDelete('Delete from Messages');
  }
}
