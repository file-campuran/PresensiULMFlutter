import 'package:flutter/material.dart';
import 'package:absen_online/api/api.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/utils/other.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';

class ChooseLocation extends StatefulWidget {
  final List<LocationModel> location;

  ChooseLocation({Key key, this.location}) : super(key: key);

  @override
  _ChooseLocationState createState() {
    return _ChooseLocationState();
  }
}

class _ChooseLocationState extends State<ChooseLocation> {
  final _textLanguageController = TextEditingController();
  bool _loading = false;

  List<LocationModel> _location;
  List<LocationModel> _locationBackup;
  List<LocationModel> _locationSelected;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  ///Fetch API
  Future<void> _loadData() async {
    final ResultApiModel result = await Api.getLocationList();
    if (result.success) {
      final Iterable data = result.data['location'] ?? [];
      setState(() {
        _location = data.map((item) {
          return LocationModel.fromJson(item);
        }).toList();
        _locationBackup = _location;
        _locationSelected = widget.location;
      });
    }
  }

  ///On filter location
  void _onFilter(String text) {
    if (text.isEmpty) {
      setState(() {
        _location = _locationBackup;
      });
      return;
    }
    setState(() {
      _location = _location.where(((item) {
        return item.name.toUpperCase().contains(text.toUpperCase());
      })).toList();
    });
  }

  ///On Select Location
  void _onSelect(LocationModel item) {
    if (_locationSelected.contains(item)) {
      _locationSelected.remove(item);
    } else {
      _locationSelected.add(item);
    }
    setState(() {
      _locationSelected = _locationSelected;
    });
  }

  ///Build List location
  Widget _buildContent() {
    if (_location == null) {
      return Center(
        child: SizedBox(
          width: 26,
          height: 26,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(left: 20, right: 20),
      itemBuilder: (context, index) {
        final item = _location[index];
        final trailing = _locationSelected.contains(item)
            ? Icon(
                Icons.check,
                color: Theme.of(context).primaryColor,
              )
            : null;
        return AppListTitle(
          title: item.name,
          textStyle: _locationSelected.contains(item)
              ? Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: Theme.of(context).primaryColor)
              : null,
          trailing: trailing,
          onPressed: () {
            _onSelect(item);
          },
        );
      },
      itemCount: _location.length,
    );
  }

  ///On change language
  Future<void> _onChange() async {
    UtilOther.hiddenKeyboard(context);
    setState(() {
      _loading = true;
    });
    await Future.delayed(Duration(seconds: 1));
    Navigator.pop(context, _locationSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('location'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 15,
                bottom: 15,
              ),
              child: AppTextInput(
                hintText: Translate.of(context).translate('search'),
                icon: Icon(Icons.clear),
                controller: _textLanguageController,
                onChanged: _onFilter,
                onSubmitted: _onFilter,
                onTapIcon: () async {
                  await Future.delayed(Duration(milliseconds: 100));
                  _textLanguageController.clear();
                },
              ),
            ),
            Expanded(
              child: _buildContent(),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 15,
                bottom: 15,
              ),
              child: AppButton(
                onPressed: () {
                  _onChange();
                },
                text: Translate.of(context).translate('apply'),
                loading: _loading,
                disableTouchWhenLoading: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
