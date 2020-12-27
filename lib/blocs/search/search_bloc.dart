import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:absen_online/api/api.dart';
import 'package:absen_online/models/model.dart';

import './bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  @override
  SearchState get initialState => SearchEmpty();

  @override
  Stream<SearchState> mapEventToState(event) async* {
    if (event is OnSearch) {
      if (event.keyword.isEmpty) {
        yield SearchEmpty();
      } else {
        yield Searching();
        final ResultApiModel result = await Api.onSearchData();
        if (result.success) {
          final Iterable refactorResult = result.data['tab'] ?? [];
          final listTabResult = refactorResult.map((item) {
            return TabModel.fromJson(item);
          }).toList();

          yield Success(listTabResult);
        }
      }
    }
  }
}
