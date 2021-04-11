import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppSliverStagged extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light));

    double appBarPadding = 50;
    double expandedHeight = 150;

    Brightness brightness = Brightness.light;
    Color backgroundColor =
        brightness == Brightness.dark ? Color(0xff303030) : Colors.white;
    Color color =
        brightness == Brightness.dark ? Colors.white : Color(0xff303030);

    return MaterialApp(
      showSemanticsDebugger: false,
      theme: ThemeData(
        brightness: brightness,
        appBarTheme: AppBarTheme(
          brightness: brightness,
        ),
      ),
      home: Scaffold(
        backgroundColor: backgroundColor,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: Icon(
                Icons.arrow_back,
                color: color,
              ),
              elevation: 0,
              backgroundColor: backgroundColor,
              pinned: false,
              floating: true,
              onStretchTrigger: () {
                // Function callback for stretch
                print('TES');
                return;
              },
              expandedHeight: expandedHeight,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double percent = ((constraints.maxHeight - kToolbarHeight) *
                      appBarPadding /
                      ((expandedHeight + appBarPadding) - kToolbarHeight));

                  double dx = 0;
                  dx = appBarPadding - percent;

                  // dx = 19.511263841160744;
                  print('percent');
                  print(constraints.toString());

                  return Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: kToolbarHeight / 4, left: 0.0),
                        child: Transform.translate(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.78,
                            // color: Colors.red,
                            child: Text(
                              'Jaringan',
                              // textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                          offset: Offset(dx + 10,
                              constraints.maxHeight - kToolbarHeight + 2),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                for (var item in new List<int>.generate(20, (i) => i + 1)) ...[
                  ListTile(
                    leading: Icon(Icons.wb_sunny),
                    title: Text('Sunday $item'),
                    subtitle: Text('sunny, h: 80, l: 65'),
                  ),
                ],
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
