import 'package:absen_online/blocs/bloc.dart';
import 'package:flutter/material.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:html/parser.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/api/presensi.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class HariLibur extends StatefulWidget {
  HariLibur({Key key}) : super(key: key);

  @override
  _HariLiburState createState() {
    return _HariLiburState();
  }
}

class _HariLiburState extends State<HariLibur> {
  ScrollController _scrollController = ScrollController();
  EventListModel listEvent;
  HariKerjaListModel listHariKerja;
  Map<String, dynamic> _errorData;
  bool _btnLoading = false;

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
    setState(() {
      _btnLoading = true;
    });

    final ApiModel result = await PresensiRepository().getEvent();
    final ApiModel resultHariKerja = await PresensiRepository().getHariKerja();

    if (this.mounted) {
      setState(() {
        _btnLoading = false;
      });

      if (result.code == CODE.SUCCESS) {
        listEvent = EventListModel.fromJson(result.data);
        listHariKerja = HariKerjaListModel.fromJson(resultHariKerja.data);
        setState(() {});
      } else {
        _errorData = result.message;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppCustomAppBar.defaultAppBar(
        title: Translate.of(context).translate('day_off'),
        context: context,
      ),
      body: _buildContent(),
    );
  }

  String _parseHtmlString(String htmlString) {
    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  _buildLoading() {
    if (_errorData != null) {
      return Center(
        child: AppError(
          title: _errorData['title'].toString(),
          message: _errorData['content'],
          image: _errorData['image'],
          onPress: initData,
          btnRefreshLoading: _btnLoading,
        ),
      );
    }

    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Container(
          margin: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
          child: Container(
            margin: EdgeInsets.all(15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(right: 10.0, top: 5.0),
                    child: AppSkeleton(
                      width: 24.0,
                      height: 24.0,
                    )),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AppSkeleton(
                          width: MediaQuery.of(context).size.width,
                          height: 20.0),
                      AppSkeleton(
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 20.0,
                            margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
                            color: Theme.of(context).highlightColor),
                      ),
                      AppSkeleton(
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 20.0,
                            margin: EdgeInsets.only(bottom: 5.0),
                            color: Theme.of(context).highlightColor),
                      ),
                      AppSkeleton(
                          width: MediaQuery.of(context).size.width - 250,
                          height: 15.0),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _hariKerja({@required bool active, @required String text}) {
    return Container(
      width: 80,
      margin: EdgeInsets.only(right: 5, bottom: 10),
      padding: EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: active ? Colors.transparent : Colors.grey.withOpacity(0.5),
          width: active ? 0 : 0.5,
        ),
        borderRadius: BorderRadius.circular(7),
        color: active ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
      ),
      child: Row(
        children: <Widget>[
          Icon(
            active ? Icons.check : EvaIcons.calendarOutline,
            size: 12,
            color: active ? Theme.of(context).primaryColor : null,
          ),
          SizedBox(width: 5),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
              color: active ? Theme.of(context).primaryColor : null,
            ),
          ),
        ],
      ),
    );
  }

  _buildContent() {
    if (listEvent == null) {
      return _buildLoading();
    } else {
      return ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: Dimens.padding),
            child: Wrap(
              runAlignment: WrapAlignment.center,
              children: listHariKerja.list
                  .map((hariKerja) => _hariKerja(
                      text: hariKerja.hari, active: hariKerja.isLibur))
                  .toList(),
            ),
          ),
          for (EventModel event in listEvent.list) ...[
            GestureDetector(
              child: Container(
                // color: Theme.of(context).dialogBackgroundColor,
                padding: EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 2.0),
                              child: Icon(EvaIcons.calendarOutline,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ],
                        )),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            event.nama,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
                            child: Text(
                              event.tanggalManusia,
                              style:
                                  TextStyle(fontSize: 12.0, color: Colors.grey),
                            ),
                          ),
                          Text(
                            _parseHtmlString(event.keterangan),
                            maxLines: 3,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                return appMyInfoDialog(
                  context: context,
                  title: event.nama,
                  message: event.keterangan,
                );
              },
            ),
          ]
        ],
      );
    }
  }
}
