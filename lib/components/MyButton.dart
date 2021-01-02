import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final bool loading;
  final String text;
  final Function onPress;
  final IconData icon;

  const MyButton(
      {Key key, @required this.loading, this.icon, this.text, this.onPress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 30,
        child: RaisedButton.icon(
          onPressed: loading ? null : onPress,
          label: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
          icon: !loading
              ? Icon(
                  icon,
                  color: Colors.white,
                )
              : SizedBox(
                  height: 16.0,
                  width: 16.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  )),
          textColor: Colors.white,
          color: Theme.of(context).primaryColor,
        ));
  }
}
