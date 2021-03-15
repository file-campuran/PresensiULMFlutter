part of 'pengumuman_cubit.dart';

@immutable
abstract class PengumumanState {}

class PengumumanInitial extends PengumumanState {}

class PengumumanData extends PengumumanState {
  final int count;
  final List<PengumumanModel> data;

  PengumumanData(this.data, [this.count = 0]);
}
