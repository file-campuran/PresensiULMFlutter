import 'package:flutter/material.dart';
import 'package:absen_online/api/api.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/models/screen_models/screen_models.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

class AboutUs extends StatefulWidget {
  AboutUs({Key key}) : super(key: key);

  @override
  _AboutUsState createState() {
    return _AboutUsState();
  }
}

class _AboutUsState extends State<AboutUs> {
  AboutUsPageModel _aboutUsPage;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  ///Fetch API
  Future<void> _loadData() async {
    final ResultApiModel result = await Api.getAboutUs();
    if (result.success) {
      setState(() {
        _aboutUsPage = new AboutUsPageModel.fromJson(result.data);
      });
    }
  }

  ///Build UI
  Widget _buildBanner() {
    if (_aboutUsPage?.banner == null) {
      return Shimmer.fromColors(
        baseColor: Theme.of(context).hoverColor,
        highlightColor: Theme.of(context).highlightColor,
        enabled: true,
        child: Container(
          color: Colors.white,
        ),
      );
    }

    return Image.asset(
      _aboutUsPage.banner,
      fit: BoxFit.cover,
    );
  }

  ///Build UI
  Widget _buildWhoWeAre() {
    if (_aboutUsPage?.whoWeAre == null) {
      return Shimmer.fromColors(
        baseColor: Theme.of(context).hoverColor,
        highlightColor: Theme.of(context).highlightColor,
        enabled: true,
        child: Column(
          children: [1, 2, 3, 4, 5].map((item) {
            return Container(
              height: 10,
              margin: EdgeInsets.only(bottom: 3),
              color: Colors.white,
            );
          }).toList(),
        ),
      );
    }

    return Text(
      _aboutUsPage.whoWeAre,
      style: Theme.of(context).textTheme.bodyText1,
    );
  }

  ///Build UI
  Widget _buildWhatWeDo() {
    if (_aboutUsPage?.whatWeDo == null) {
      return Shimmer.fromColors(
        baseColor: Theme.of(context).hoverColor,
        highlightColor: Theme.of(context).highlightColor,
        enabled: true,
        child: Column(
          children: [1, 2, 3, 4, 5].map((item) {
            return Container(
              height: 15,
              margin: EdgeInsets.only(bottom: 3),
              color: Colors.white,
            );
          }).toList(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _aboutUsPage.whatWeDo.map((item) {
        return Padding(
          padding: EdgeInsets.only(bottom: 3),
          child: Text(
            "$item",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        );
      }).toList(),
    );
  }

  ///Build UI
  Widget _buildTeam() {
    if (_aboutUsPage?.team == null) {
      return Shimmer.fromColors(
        baseColor: Theme.of(context).hoverColor,
        highlightColor: Theme.of(context).highlightColor,
        enabled: true,
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          runSpacing: 15,
          children: [1, 2, 3, 4].map((item) {
            return FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                margin: EdgeInsets.only(left: 20),
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.all(10),
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      runSpacing: 15,
      children: _aboutUsPage.team.map((item) {
        return FractionallySizedBox(
          widthFactor: 0.5,
          child: Container(
            margin: EdgeInsets.only(left: 20),
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.all(10),
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(item.image),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              child: Row(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.level,
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(color: Colors.white),
                      ),
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            centerTitle: true,
            title: Text(
              Translate.of(context).translate('about_us'),
            ),
            expandedHeight: 200.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: _buildBanner(),
            ),
          ),
          SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              Translate.of(context).translate('who_we_are'),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          _buildWhoWeAre(),
                          Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 5),
                            child: Text(
                              Translate.of(context).translate('what_we_do'),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          _buildWhatWeDo(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 15,
                        bottom: 15,
                        left: 20,
                        right: 20,
                      ),
                      child: Text(
                        Translate.of(context).translate('meet_our_team'),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: _buildTeam(),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
