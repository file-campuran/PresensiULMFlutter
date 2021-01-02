import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:absen_online/api/api.dart';
import 'package:absen_online/blocs/bloc.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/models/screen_models/screen_models.dart';
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
  ProfilePageModel _profilePage;

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _loadData();
    super.initState();
  }

  ///Fetch API
  Future<void> _loadData() async {
    String user = UtilPreferences.getString('user');
    UserModel userModel = userModelFromJson(user);
    if (this.mounted) {
      setState(() {
        _profilePage = ProfilePageModel(userModel, [
          {"title": "feedback", "value": "97.01%"},
          {"title": "post", "value": "245"},
          {"title": "follower", "value": "78"}
        ]);
      });
    }
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
      user: _profilePage?.user,
      onPressed: () {},
      type: AppUserType.information,
    );
  }

  ///Build value
  Widget _buildValue() {
    return AppProfilePerformance(
      data: _profilePage?.value,
      onPressed: (item) {},
    );
  }

  ///On navigation
  void _onNavigate(String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('profile'),
        ),
      ),
      body: SafeArea(
        child: Column(
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
                        _buildValue(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        AppListTitle(
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
                        AppListTitle(
                          title: Translate.of(context).translate('contact_us'),
                          onPressed: () {
                            _onNavigate(Routes.contactUs);
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
                          title:
                              Translate.of(context).translate('privacy_policy'),
                          onPressed: () {
                            _onNavigate(Routes.privacyPolicy);
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
                          border: false,
                        ),
                      ],
                    ),
                  )
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
                    text: Translate.of(context).translate('sign_out'),
                    loading: login is LoginLoading,
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
