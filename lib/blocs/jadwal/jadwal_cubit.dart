import 'package:absen_online/models/model.dart';
import 'package:absen_online/api/presensi.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'jadwal_state.dart';

class JadwalCubit extends Cubit<JadwalState> {
  JadwalCubit() : super(JadwalInitial());

  JadwalListModel data;
  dynamic errorMessage;
  bool isLoading = false;

  Future<dynamic> initData() async {
    if (data == null) {
      final ApiModel result = await PresensiRepository().getJadwal();

      if (result.code == CODE.SUCCESS) {
        data = JadwalListModel.fromJson(result.data);
        emit(JadwalLoaded(data));
      } else if (result.code == CODE.INFO) {
        emit(JadwalInfo(result.message));
      } else if (result.code == CODE.TOKEN_EXPIRED) {
        emit(Logout());
      } else {
        errorMessage = result.message;
        emit(JadwalError(errorMessage, isLoading));
      }
    } else {
      emit(JadwalLoaded(data));
    }
  }

  reload() async {
    isLoading = true;
    emit(JadwalError(errorMessage, isLoading));
    isLoading = false;
    initData();
  }
}
