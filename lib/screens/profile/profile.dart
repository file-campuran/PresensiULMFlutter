import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:absen_online/blocs/bloc.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  LoginBloc _loginBloc;

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///On logout
  Future<void> _logout() async {
    _loginBloc.add(OnLogout());
  }

  ///Build profile UI
  Widget _buildProfile() {
    return AppUserInfo(
      user: Application.user,
      onPressed: () {},
      type: AppUserType.basic,
    );
  }

  ///On navigation
  void _onNavigate(String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //     statusBarIconBrightness: Brightness.light));

    return Scaffold(
      appBar: AppCustomAppBar.defaultAppBar(
          title: Translate.of(context).translate('profile'), context: context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(
                  top: 15,
                ),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
                    child: Column(
                      children: <Widget>[
                        _buildProfile(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        AppListTitle(
                          icon: Icon(EvaIcons.personOutline),
                          title: Translate.of(context).translate(
                            'edit_profile',
                          ),
                          trailing: RotatedBox(
                            quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                          onPressed: () {
                            _onNavigate(Routes.editProfile);
                          },
                        ),
                        // AppListTitle(
                        //   icon: Icon(EvaIcons.questionMarkCircleOutline),
                        //   title: Translate.of(context).translate(
                        //     'guide',
                        //   ),
                        //   onPressed: () {
                        //     _onNavigate(Routes.panduan);
                        //   },
                        //   trailing: RotatedBox(
                        //     quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
                        //     child: Icon(
                        //       Icons.keyboard_arrow_right,
                        //       textDirection: TextDirection.ltr,
                        //     ),
                        //   ),
                        // ),
                        AppListTitle(
                          icon: Icon(EvaIcons.settingsOutline),
                          title: Translate.of(context).translate('setting'),
                          onPressed: () {
                            _onNavigate(Routes.setting);
                          },
                          trailing: RotatedBox(
                            quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              textDirection: TextDirection.ltr,
                            ),
                          ),
                        ),
                        AppListTitle(
                          icon: Icon(EvaIcons.smartphoneOutline),
                          title: Translate.of(context).translate('version'),
                          onPressed: () {
                            _onNavigate(Routes.version);
                          },
                          trailing: Row(
                            children: <Widget>[
                              Text(
                                Environment.VERSION,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              RotatedBox(
                                quarterTurns: UtilLanguage.isRTL() ? 2 : 0,
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  textDirection: TextDirection.ltr,
                                ),
                              ),
                            ],
                          ),
                          border: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _buildCs(),
            _buildTermsConditions(),
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 15,
                bottom: 15,
              ),
              child: BlocBuilder<LoginBloc, LoginState>(
                builder: (context, login) {
                  return OutlineButton(
                    borderSide: BorderSide(color: Color(0xffEB5757)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    color: Colors.white,
                    onPressed: () {
                      appMyInfoDialog(
                          context: context,
                          message: Translate.of(context)
                              .translate('confirm_sign_out'),
                          image: Images.Reading,
                          title: Translate.of(context).translate('sign_out'),
                          onTapText:
                              Translate.of(context).translate('sign_out'),
                          onTap: () {
                            _logout();
                            Navigator.of(context).pop();
                          });
                      return;
                      showDialog<void>(
                        context: context,
                        barrierDismissible: true, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Logout'),
                            content: Text(Translate.of(context)
                                .translate('confirm_sign_out')),
                            actions: <Widget>[
                              FlatButton(
                                child: Text(
                                    Translate.of(context).translate('close')),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              RaisedButton(
                                child: Text('OK'),
                                onPressed: () {
                                  _logout();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                              child: Text(
                            Translate.of(context).translate('sign_out'),
                            style: TextStyle(
                                color: Color(0xffEB5757),
                                fontWeight: FontWeight.bold),
                          ))),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildCs() {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 15,
      ),
      child: RichText(
        text: TextSpan(
          text: Translate.of(context).translate('customer_service') +
              ' (${Environment.namaCs}) : ',
          style: Theme.of(context)
              .textTheme
              .caption
              .copyWith(fontWeight: FontWeight.w600),
          children: <TextSpan>[
            TextSpan(
                text: Environment.noCs,
                style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    await launchExternal('tel:082149091899');
                  })
          ],
        ),
      ),
    );
  }

  // Function to build text terms and conditions
  _buildTermsConditions() {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 15,
      ),
      child: RichText(
        text: TextSpan(
          text: Translate.of(context).translate('privacy_policy_title'),
          style: Theme.of(context)
              .textTheme
              .caption
              .copyWith(fontWeight: FontWeight.w600),
          children: <TextSpan>[
            TextSpan(
                text: Translate.of(context).translate('privacy_policy'),
                style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _onNavigate(Routes.privacyPolicy);
                  })
          ],
        ),
      ),
    );
  }
}
