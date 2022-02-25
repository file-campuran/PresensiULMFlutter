import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/api/presensi.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'pengumuman_state.dart';

class PengumumanCubit extends Cubit<PengumumanState> {
  PengumumanCubit() : super(PengumumanInitial());

  List<PengumumanModel> listMessage = [];
  int countNotRead = 0;

  void readMessage() async {
    if (listMessage.isEmpty) {
      loadData();

      ApiModel apiModel;
      final lastDate = await getLastDate();

      if (lastDate.isNotEmpty) {
        apiModel =
            await PresensiRepository().getPengumuman(startDate: lastDate);
      } else {
        apiModel = await PresensiRepository().getPengumuman();
      }

      if (apiModel.code == CODE.SUCCESS) {
        await apiModel.data['rows'].forEach((model) async {
          PengumumanModel pengumumanModel = PengumumanModel.fromJson(model);
          await Application.db.insert(
            'Pengumuman',
            pengumumanModel.toJson(),
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        });
        loadData();
      }
    } else {
      // loadData();
    }
  }

  /*
   * Ambil waktu terakhir pemberitahuan
   */
  Future<String> getLastDate() async {
    var res = await Application.db
        .rawQuery('SELECT * FROM Pengumuman ORDER BY tgl DESC limit 1');

    if (res.isNotEmpty) {
      // UtilLogger.log('DATA FIRST', res[0]);
      final data = PengumumanModel.fromJson(res[0]);
      return data.tgl;
    }

    return '';
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

  reload() async {
    listMessage = [];
    readMessage();
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
