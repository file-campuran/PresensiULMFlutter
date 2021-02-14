part of 'jadwal_cubit.dart';

@immutable
abstract class JadwalState {}

class JadwalInitial extends JadwalState {}

class JadwalLoaded extends JadwalState {
  final JadwalListModel data;

  JadwalLoaded(this.data);
}

class JadwalError extends JadwalState {
  final bool isLoading;
  final Map<String, dynamic> error;

  JadwalError(this.error, this.isLoading);
}

class JadwalInfo extends JadwalState {
  final Map<String, dynamic> info;

  JadwalInfo(this.info);
}

class Logout extends JadwalState {}
