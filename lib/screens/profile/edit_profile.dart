import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:absen_online/blocs/bloc.dart';
import 'package:absen_online/models/model.dart';
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
  String _golonganDarah;

  UserModel _userModel;
  bool _loading = false;

  Map<String, String> _validate = {
    'alamat': null,
    'golDarah': null,
    'noHp': null,
  };

  List<String> _listGolDarah = [
    'A',
    'B',
    'AB',
    '0',
  ];

  @override
  void initState() {
    super.initState();
    String user = UtilPreferences.getString('user');
    _userModel = userModelFromJson(user);
    _textAlamatController.text = _userModel.alamat;
    _nomorPonsel.text = _userModel.noHp;
    _golonganDarah = _userModel.golDarah;
  }

  bool isValid() {
    bool isValid = true;

    localValidate();
    _validate.forEach((key, value) {
      if (value != null) {
        isValid = false;
      }
    });

    return isValid;
  }

  void localValidate() {
    setState(() {
      _validate['noHp'] = UtilValidator.validate(
        data: _nomorPonsel.text,
        type: TypeValidate.phone,
      );
      _validate['alamat'] = UtilValidator.validate(
        data: _textAlamatController.text,
      );
      _validate['golDarah'] = UtilValidator.validate(
        data: _golonganDarah,
      );
    });
  }

  void serverValidate(Map<String, dynamic> message) {
    _validate.forEach((key, value) {
      _validate[key] = message[key];
    });
    setState(() {});
  }

  ///On update image
  Future<void> _update() async {
    UtilOther.hiddenKeyboard(context);

    if (isValid()) {
      setState(() {
        _loading = true;
      });
      final apiModel = await PresensiRepository().setBiodata(
        alamat: _textAlamatController.text,
        noPonsel: _nomorPonsel.text,
        golDarah: _golonganDarah,
      );
      setState(() {
        _loading = false;
      });
      if (apiModel.code == CODE.SUCCESS) {
        _userModel.golDarah = _golonganDarah;
        _userModel.noHp = _nomorPonsel.text;
        _userModel.alamat = _textAlamatController.text;

        UtilPreferences.setString('user', _userModel.toString());

        Navigator.pop(context);
      } else if (apiModel.code == CODE.VALIDATE) {
        serverValidate(apiModel.message);
      } else {
        showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('ERROR'),
                content: SingleChildScrollView(
                  child: AppTextList(apiModel.message is String
                      ? apiModel.message
                      : apiModel.message['content']),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
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
                  AppTextInput(
                    title: Translate.of(context).translate(
                      'address',
                    ),
                    hintText: Translate.of(context).translate(
                      'input_address',
                    ),
                    errorText: Translate.of(context)
                        .translate(_validate['alamat'] ?? ''),
                    maxLines: 5,
                    onTapIcon: () async {
                      _textAlamatController.clear();
                    },
                    onChanged: (text) {
                      localValidate();
                    },
                    icon: Icon(Icons.clear),
                    controller: _textAlamatController,
                  ),

                  ///PHONE NUUMBER
                  AppTextInput(
                    title: Translate.of(context).translate(
                      'phone_number',
                    ),
                    hintText: Translate.of(context).translate('phone_number'),
                    errorText: Translate.of(context)
                        .translate(_validate['noHp'] ?? ''),
                    textInputAction: TextInputAction.next,
                    onTapIcon: () async {
                      _nomorPonsel.clear();
                    },
                    onChanged: (text) {
                      localValidate();
                    },
                    icon: Icon(Icons.clear),
                    controller: _nomorPonsel,
                  ),

                  ///BLOD TYPE
                  AppRadioInput(
                      title: Translate.of(context).translate('blood_type'),
                      errorText: Translate.of(context)
                          .translate(_validate['golDarah'] ?? ''),
                      data: _listGolDarah,
                      value: _golonganDarah,
                      onChanged: (value) {
                        setState(() {
                          _golonganDarah = value;
                          localValidate();
                        });
                      }),
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
