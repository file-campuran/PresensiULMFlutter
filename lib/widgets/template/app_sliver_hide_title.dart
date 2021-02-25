import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppSliverHideTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light));

    double appBarPadding = 50;
    double expandedHeight = 150;

    Brightness brightness = Brightness.dark;
    Color backgroundColor =
        brightness == Brightness.dark ? Color(0xff303030) : Colors.white;
    Color color =
        brightness == Brightness.dark ? Colors.white : Color(0xff303030);

    return MaterialApp(
      color: color,
      theme: ThemeData(
        brightness: brightness,
        appBarTheme: AppBarTheme(
          brightness: brightness,
        ),
      ),
      home: Scaffold(
        backgroundColor: backgroundColor,
        // drawer: Drawer(),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: backgroundColor,
              elevation: 1,
              primary: true,
              pinned: true,
              expandedHeight: 0,
              title: SABT(
                  child: Text(
                "The title",
                style: TextStyle(color: color),
              )),
              flexibleSpace: FlexibleSpaceBar(
                // title: Text('tes'),
                titlePadding: EdgeInsets.only(left: 18),
                background: Container(
                  alignment: Alignment.bottomLeft,
                  color: Colors.purple,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return ListTile(
                    title: Text("List tile $index"),
                  );
                },
                childCount: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SABT extends StatefulWidget {
  final Widget child;
  const SABT({
    Key key,
    @required this.child,
  }) : super(key: key);
  @override
  _SABTState createState() {
    return new _SABTState();
  }
}

class _SABTState extends State<SABT> {
  ScrollPosition _position;
  bool _visible;
  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }

  void _addListener() {
    _position = Scrollable.of(context)?.position;
    _position?.addListener(_positionListener);
    _positionListener();
  }

  void _removeListener() {
    _position?.removeListener(_positionListener);
  }

  void _positionListener() {
    final FlexibleSpaceBarSettings settings =
        context.inheritFromWidgetOfExactType(FlexibleSpaceBarSettings);
    bool visible =
        settings == null || settings.currentExtent <= settings.minExtent;
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: Duration(milliseconds: 300),
      child: widget.child,
    );
  }
}
