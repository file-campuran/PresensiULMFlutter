import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:absen_online/blocs/bloc.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart' as model;
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:absen_online/api/presensi.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() {
    return _EditProfileState();
  }
}

class _EditProfileState extends State<EditProfile> {
  final _nomorPonsel = TextEditingController();
  final _textAlamatController = TextEditingController();
  final _focusNoPonsel = FocusNode();
  final _focusAlamat = FocusNode();

  bool _loading = false;
  String _validNoPonsel;
  String _validAlamat;
  String _validGolDar;
  String _golonganDarah = '';

  List<String> _listGolDarah = [
    'A',
    'B',
    'AB',
    '0',
  ];

  @override
  void initState() {
    super.initState();
    _textAlamatController.text = '';
    _nomorPonsel.text = '';
  }

  ///On update image
  Future<void> _update() async {
    print('UPDATE');
    UtilOther.hiddenKeyboard(context);
    setState(() {
      _validNoPonsel = UtilValidator.validate(
        data: _nomorPonsel.text,
        type: Type.phone,
      );
      _validAlamat = UtilValidator.validate(
        data: _textAlamatController.text,
      );
      _validGolDar = UtilValidator.validate(
        data: _golonganDarah,
      );
    });

    if (_validNoPonsel == null &&
        _validAlamat == null &&
        _validGolDar == null) {
      setState(() {
        _loading = true;
      });
      final apiModel = await PresensiRepository().setBiodata();
      setState(() {
        _loading = false;
      });
      if (apiModel.code == model.CODE.SUCCESS) {
        Navigator.pop(context);
      } else {
        setState(() {
          _validAlamat = apiModel.message['namaJenis'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Translate.of(context).translate('edit_profile')),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(left: 20, right: 20, top: 15),
                children: <Widget>[
                  ///ADDRESS
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      Translate.of(context).translate(
                        'address',
                      ),
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  AppTextInput(
                    hintText: Translate.of(context).translate(
                      'input_address',
                    ),
                    errorText: _validAlamat != null
                        ? Translate.of(context).translate(_validAlamat)
                        : null,
                    focusNode: _focusAlamat,
                    maxLines: 5,
                    onTapIcon: () async {
                      await Future.delayed(Duration(milliseconds: 100));
                      _textAlamatController.clear();
                    },
                    onSubmitted: (text) {
                      _update();
                    },
                    onChanged: (text) {
                      setState(() {
                        _validAlamat = UtilValidator.validate(
                          data: _textAlamatController.text,
                          type: Type.normal,
                        );
                      });
                    },
                    icon: Icon(Icons.clear),
                    controller: _textAlamatController,
                  ),

                  ///PHONE NUUMBER
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      Translate.of(context).translate(
                        'phone_number',
                      ),
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  AppTextInput(
                    hintText: Translate.of(context).translate('phone_number'),
                    errorText: _validNoPonsel != null
                        ? Translate.of(context).translate(_validNoPonsel)
                        : null,
                    focusNode: _focusNoPonsel,
                    textInputAction: TextInputAction.next,
                    onTapIcon: () async {
                      await Future.delayed(Duration(milliseconds: 100));
                      _nomorPonsel.clear();
                    },
                    onSubmitted: (text) {
                      UtilOther.fieldFocusChange(
                        context,
                        _focusNoPonsel,
                        _focusAlamat,
                      );
                    },
                    onChanged: (text) {
                      setState(() {
                        _validNoPonsel = UtilValidator.validate(
                          data: _nomorPonsel.text,
                          type: Type.phone,
                        );
                      });
                    },
                    icon: Icon(Icons.clear),
                    controller: _nomorPonsel,
                  ),

                  ///BLOD TYPE
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      Translate.of(context).translate('blood_type'),
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _listGolDarah.map((item) {
                      final bool selected = _golonganDarah == item;
                      return SizedBox(
                        height: 32,
                        child: FilterChip(
                          selected: selected,
                          label: Text(item),
                          onSelected: (value) {
                            setState(() {
                              _golonganDarah = item;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  if (_validGolDar != null) ...[
                    Container(
                      padding: EdgeInsets.only(top: 2, left: 10),
                      child: Text(
                        Translate.of(context).translate(_validGolDar),
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 15,
                bottom: 15,
              ),
              child: BlocBuilder<LoginBloc, LoginState>(
                builder: (context, login) {
                  return AppButton(
                    onPressed: () {
                      _update();
                    },
                    text: Translate.of(context).translate('confirm'),
                    loading: _loading,
                    disableTouchWhenLoading: true,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
