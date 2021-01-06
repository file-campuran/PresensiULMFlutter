import 'package:flutter/material.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/api/presensi.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_html/flutter_html.dart';
import 'package:absen_online/widgets/app_color_loader.dart';

class PrivacyPolicy extends StatefulWidget {
  PrivacyPolicy({Key key}) : super(key: key);

  @override
  _PrivacyPolicyState createState() {
    return _PrivacyPolicyState();
  }
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  String _privacyText;
  bool _loading = true;

  @override
  void initState() {
    _loadPrivacy();
    super.initState();
  }

  void _loadPrivacy() async {
    final res = await PresensiRepository.getPrivacyPolicy();
    setState(() {
      _loading = false;
      _privacyText = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Translate.of(context).translate('privacy_policy')),
      ),
      body: SafeArea(
        child: Center(
          child: !_loading
              ? Column(
                  children: <Widget>[
                    Expanded(
                        child: SingleChildScrollView(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Html(
                          data: _privacyText,
                          defaultTextStyle: TextStyle(
                              color: Colors.grey[600], fontSize: 14.0),
                          onLinkTap: (url) {
                            print(url);
                            launchExternal(url);
                          },
                          customTextAlign: (dom.Node node) {
                            return TextAlign.left;
                          },
                        ),
                      ),
                    )),
                  ],
                )
              : AppColorLoader(),
        ),
      ),
    );
  }
}
