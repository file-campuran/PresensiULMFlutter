import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:absen_online/blocs/bloc.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:absen_online/configs/config.dart';
import 'package:flutter_svg/svg.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  final _textIDController = TextEditingController();
  final _textPassController = TextEditingController();
  final _focusID = FocusNode();
  final _focusPass = FocusNode();

  LoginBloc _loginBloc;
  bool _showPassword = false;
  String _validID;
  String _validPass;

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _textIDController.text = Environment.DEBUG ? "130239244" : '';
    _textPassController.text = Environment.DEBUG ? "1q2w3e4r" : '';
    super.initState();
  }

  ///On navigate forgot password
  void _forgotPassword() {
    // Navigator.pushNamed(context, Routes.setting);
    appMyInfoDialog(
      context: context,
      message: {
        0: 'Operator Fakultas, jika anda seorang Dosen.',
        1: 'Admin Tenaga Kependidikan (Subbag Tenaga Kependidikan kepegawaian rektorat), jika anda seorang Tenaga Kependidikan.',
      },
      image: Images.ForgotPassword,
      title: Translate.of(context).translate('forgot_password'),
    );
    return;
    // showDialog<void>(
    //   context: context,
    //   barrierDismissible: false, // user must tap button!
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Text(Translate.of(context).translate('forgot_password')),
    //       content: SingleChildScrollView(
    //         child: ListBody(
    //           children: <Widget>[
    //             AppTextList('Operator Fakultas, jika anda seorang Dosen.'),
    //             AppTextList(
    //                 'Admin Tenaga Kependidikan (Subbag Tenaga Kependidikan kepegawaian rektorat), jika anda seorang Tenaga Kependidikan.'),
    //           ],
    //         ),
    //       ),
    //       actions: <Widget>[
    //         FlatButton(
    //           child: Text('Close'),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  ///On login
  void _login() {
    UtilOther.hiddenKeyboard(context);
    setState(() {
      _validID = UtilValidator.validate(data: _textIDController.text);
      _validPass = UtilValidator.validate(data: _textPassController.text);
    });
    if (_validID == null && _validPass == null) {
      _loginBloc.add(OnLogin(
        username: _textIDController.text,
        password: _textPassController.text,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        brightness: Theme.of(context).brightness,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Color(0xff303030)
            : Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Images.Logo),
                ),
              ),
            ),
            SizedBox(width: 15),
            Text(
              'Presensi ULM',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Color(0xff303030)),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 40),
              child: Column(
                children: <Widget>[
                  Center(
                    child: SvgPicture.asset(
                      Images.Login,
                      matchTextDirection: true,
                      width: 300,
                    ),
                  ),
                  SizedBox(height: 40),
                  AppTextInput(
                    hintText: 'NIP / NIPK',
                    errorText: _validID != null
                        ? Translate.of(context).translate(_validID)
                        : null,
                    icon: Icon(Icons.clear),
                    controller: _textIDController,
                    focusNode: _focusID,
                    textInputAction: TextInputAction.next,
                    onChanged: (text) {
                      setState(() {
                        _validID = UtilValidator.validate(
                          data: _textIDController.text,
                        );
                      });
                    },
                    onSubmitted: (text) {
                      UtilOther.fieldFocusChange(context, _focusID, _focusPass);
                    },
                    onTapIcon: () async {
                      await Future.delayed(Duration(milliseconds: 100));
                      _textIDController.clear();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  AppTextInput(
                    hintText: Translate.of(context).translate('password'),
                    errorText: _validPass != null
                        ? Translate.of(context).translate(_validPass)
                        : null,
                    textInputAction: TextInputAction.done,
                    onChanged: (text) {
                      setState(() {
                        _validPass = UtilValidator.validate(
                          data: _textPassController.text,
                        );
                      });
                    },
                    onSubmitted: (text) {
                      _login();
                    },
                    onTapIcon: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    obscureText: !_showPassword,
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    controller: _textPassController,
                    focusNode: _focusPass,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, login) {
                      return BlocListener<LoginBloc, LoginState>(
                        listener: (context, loginListener) {
                          if (loginListener is LoginFail) {
                            appMyInfoDialog(
                              context: context,
                              message: loginListener.message,
                              image: Images.Error,
                              title: 'Error',
                            );
                          }
                        },
                        child: AppButton(
                          onPressed: () {
                            _login();
                          },
                          text: Translate.of(context).translate('sign_in'),
                          loading: login is LoginLoading,
                          disableTouchWhenLoading: true,
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        onPressed: _forgotPassword,
                        child: Text(
                          Translate.of(context).translate('forgot_password'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
