import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/api/presensi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'pengumuman_state.dart';

class PengumumanCubit extends Cubit<PengumumanState> {
  PengumumanCubit() : super(PengumumanInitial());

  List<PengumumanModel> listMessage = [];
  int countNotRead = 0;

  void readMessage() async {
    // await clearLocalData();
    if (listMessage.isEmpty) {
      final apiModel = await PresensiRepository().getPengumuman();
      UtilLogger.log('API MODEL', apiModel.toJson());
      if (apiModel.code == CODE.SUCCESS) {
        apiModel.data['rows'].forEach((model) async {
          PengumumanModel pengumumanModel = PengumumanModel.fromJson(model);
          await Application.db.insert(
            'Pengumuman',
            pengumumanModel.toJson(),
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        });
        loadData();
      }
      // FirebaseFirestore.instance
      //     .collection('message')
      //     .orderBy('tgl', descending: true)
      //     .get()
      //     .then((QuerySnapshot querySnapshot) {
      //   listMessage = [];
      //   querySnapshot.docs.forEach((element) async {
      //     Map<String, dynamic> model = element.data();
      //     model['id'] = element.id;
      //     PengumumanModel pengumumanModel = PengumumanModel.fromJson(model);
      //     await Application.db.insert(
      //       'Pengumuman',
      //       pengumumanModel.toJson(),
      //       conflictAlgorithm: ConflictAlgorithm.ignore,
      //     );
      //   });
      //   loadData();
      // });
    } else {
      loadData();
    }
  }

  void loadData() async {
    var res = await Application.db
        .rawQuery('SELECT * FROM Pengumuman ORDER BY tgl DESC');
    listMessage = res.isNotEmpty
        ? res.map((c) => PengumumanModel.fromJson(c)).toList()
        : [];
    countNotRead = await countUnRead();
    emit(PengumumanData(listMessage, countNotRead));
  }

  void markAsRead(String id) async {
    await Application.db
        .update('Pengumuman', {'isRead': 1}, where: 'id = ?', whereArgs: [id]);

    loadData();
  }

  /*
   * Read = 1
   * Unread = 0
   */
  void markAll(int isRead) async {
    await Application.db.update(
      'Pengumuman',
      {'isRead': isRead},
    );

    loadData();
  }

  Future<int> countUnRead() async {
    return Sqflite.firstIntValue(await Application.db
        .rawQuery('SELECT COUNT(*) FROM Pengumuman WHERE isRead = 0'));
  }

  //Clear all data from db
  Future<void> clearLocalData() async {
    await Application.db.rawDelete('Delete from Pengumuman');
  }
}
