import 'package:flutter/material.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {
  final _textIDController = TextEditingController();
  final _textPassController = TextEditingController();
  final _textEmailController = TextEditingController();
  final _focusID = FocusNode();
  final _focusPass = FocusNode();
  final _focusEmail = FocusNode();

  bool _loading = false;
  bool _showPassword = false;
  String _validID;
  String _validPass;
  String _validEmail;

  ///On sign up
  void _signUp() {
    setState(() {
      _validID = UtilValidator.validate(
        data: _textIDController.text,
      );
      _validPass = UtilValidator.validate(
        data: _textPassController.text,
      );
      _validEmail = UtilValidator.validate(
        data: _textEmailController.text,
        type: Type.email,
      );
    });
    if (_validID == null && _validPass == null && _validEmail == null) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Translate.of(context).translate('sign_up'),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    Translate.of(context).translate('account'),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                AppTextInput(
                  hintText: Translate.of(context).translate('input_id'),
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
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Text(
                    Translate.of(context).translate('password'),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                AppTextInput(
                  hintText: Translate.of(context).translate(
                    'input_your_password',
                  ),
                  errorText: _validPass != null
                      ? Translate.of(context).translate(_validPass)
                      : null,
                  textInputAction: TextInputAction.next,
                  onChanged: (text) {
                    setState(() {
                      _validPass = UtilValidator.validate(
                        data: _textPassController.text,
                      );
                    });
                  },
                  onSubmitted: (text) {
                    UtilOther.fieldFocusChange(
                        context, _focusPass, _focusEmail);
                  },
                  onTapIcon: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                  obscureText: !_showPassword,
                  icon: Icon(
                    _showPassword ? Icons.lock_open : Icons.lock_outline,
                  ),
                  controller: _textPassController,
                  focusNode: _focusPass,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Text(
                    Translate.of(context).translate('email'),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                AppTextInput(
                  hintText: Translate.of(context).translate('input_email'),
                  errorText: _validEmail != null
                      ? Translate.of(context).translate(_validEmail)
                      : null,
                  focusNode: _focusEmail,
                  onTapIcon: () async {
                    await Future.delayed(Duration(milliseconds: 100));
                    _textEmailController.clear();
                  },
                  onSubmitted: (text) {
                    _signUp();
                  },
                  onChanged: (text) {
                    setState(() {
                      _validEmail = UtilValidator.validate(
                        data: _textEmailController.text,
                        type: Type.email,
                      );
                    });
                  },
                  icon: Icon(Icons.clear),
                  controller: _textEmailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                AppButton(
                  onPressed: () {
                    _signUp();
                  },
                  text: Translate.of(context).translate('sign_up'),
                  loading: _loading,
                  disableTouchWhenLoading: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
