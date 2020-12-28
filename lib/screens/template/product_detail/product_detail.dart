import 'dart:async';

import 'package:flutter/material.dart';
import 'package:absen_online/api/api.dart';
import 'package:absen_online/configs/config.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/models/screen_models/screen_models.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetail extends StatefulWidget {
  ProductDetail({Key key, this.id = 0}) : super(key: key);

  final num id;

  @override
  _ProductDetailState createState() {
    return _ProductDetailState();
  }
}

class _ProductDetailState extends State<ProductDetail> {
  bool _like = false;
  bool _showHour = false;
  ProductDetailPageModel _detailPage;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  ///Fetch API
  Future<void> _loadData() async {
    final ResultApiModel result = await Api.getProductDetail(id: widget.id);
    if (result.success) {
      setState(() {
        _detailPage = ProductDetailPageModel.fromJson(result.data);
        _like = _detailPage?.product?.like;
      });
    }
  }

  ///On navigate gallery
  void _onPhotoPreview() {
    Navigator.pushNamed(
      context,
      Routes.gallery,
      arguments: _detailPage?.product?.photo,
    );
  }

  ///On navigate map
  void _onLocation() {
    Navigator.pushNamed(
      context,
      Routes.location,
      arguments: _detailPage?.product?.location,
    );
  }

  ///On navigate product detail
  void _onProductDetail(ProductModel item) {
    String route = item.type == ProductType.place
        ? Routes.productDetail
        : Routes.productDetailTab;
    Navigator.pushNamed(context, route, arguments: item.id);
  }

  ///On navigate review
  void _onReview() {
    Navigator.pushNamed(context, Routes.review);
  }

  ///On like product
  void _onLike() {
    setState(() {
      _like = !_like;
    });
  }

  ///Build banner UI
  Widget _buildBanner() {
    if (_detailPage?.product?.image == null) {
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
      _detailPage?.product?.image,
      fit: BoxFit.cover,
    );
  }

  ///Build info
  Widget _buildInfo() {
    if (_detailPage == null) {
      return Shimmer.fromColors(
        baseColor: Theme.of(context).hoverColor,
        highlightColor: Theme.of(context).highlightColor,
        enabled: true,
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  bottom: 20,
                  top: 20,
                ),
                height: 10,
                width: 150,
                color: Colors.white,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 10,
                        width: 100,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                      ),
                      Container(
                        height: 20,
                        width: 150,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  Container(
                    height: 10,
                    width: 100,
                    color: Colors.white,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 10,
                          width: 100,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 3),
                        ),
                        Container(
                          height: 10,
                          width: 200,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 10,
                          width: 100,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 3),
                        ),
                        Container(
                          height: 10,
                          width: 200,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 10,
                          width: 100,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 3),
                        ),
                        Container(
                          height: 10,
                          width: 200,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 10,
                          width: 100,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 3),
                        ),
                        Container(
                          height: 10,
                          width: 200,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 10,
                          width: 100,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 3),
                        ),
                        Container(
                          height: 10,
                          width: 200,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 25),
                child: Container(height: 10, color: Colors.white),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Container(height: 10, color: Colors.white),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Container(height: 10, color: Colors.white),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Container(height: 10, color: Colors.white),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Container(height: 10, color: Colors.white),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Container(height: 10, color: Colors.white),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Container(height: 10, width: 50, color: Colors.white),
              )
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                _detailPage?.product?.title,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              IconButton(
                icon: Icon(
                  _like ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).primaryColorLight,
                ),
                onPressed: _onLike,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: _onReview,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _detailPage?.product?.subtitle,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 3),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        AppTag(
                          "${_detailPage?.product?.rate}",
                          type: TagType.rateSmall,
                        ),
                        Padding(padding: EdgeInsets.only(left: 5)),
                        StarRating(
                          rating: _detailPage?.product?.rate,
                          size: 14,
                          color: AppTheme.yellowColor,
                          borderColor: AppTheme.yellowColor,
                          onRatingChanged: (v) {
                            _onReview();
                          },
                        ),
                        Padding(padding: EdgeInsets.only(left: 5)),
                        Text(
                          "(${_detailPage?.product?.numRate})",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              _detailPage?.product?.status != null
                  ? AppTag(
                      _detailPage?.product?.status,
                      type: TagType.status,
                    )
                  : Container(),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          InkWell(
            onTap: () {},
            child: Row(
              children: <Widget>[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).dividerColor,
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        Translate.of(context).translate('address'),
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        _detailPage?.product?.address,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          InkWell(
            onTap: () {},
            child: Row(
              children: <Widget>[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).dividerColor,
                  ),
                  child: Icon(
                    Icons.phone,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        Translate.of(context).translate('phone'),
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        _detailPage?.product?.phone,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          InkWell(
            onTap: () {},
            child: Row(
              children: <Widget>[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).dividerColor),
                  child: Icon(
                    Icons.email,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        Translate.of(context).translate('email'),
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        _detailPage?.product?.email,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          InkWell(
            onTap: () {},
            child: Row(
              children: <Widget>[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).dividerColor),
                  child: Icon(
                    Icons.language,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        Translate.of(context).translate('website'),
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        _detailPage?.product?.website,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          InkWell(
            onTap: () {
              setState(() {
                _showHour = !_showHour;
              });
            },
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).dividerColor,
                        ),
                        child: Icon(
                          Icons.access_time,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              Translate.of(context).translate('open_time'),
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Text(
                              _detailPage?.product?.hour,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _showHour
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                )
              ],
            ),
          ),
          Visibility(
            visible: _showHour,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _detailPage.product.hourDetail.map((item) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                  ),
                  margin: EdgeInsets.only(
                    left: 42,
                  ),
                  padding: EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        Translate.of(context).translate(item.title),
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        item.title == 'day_off'
                            ? Translate.of(context).translate('day_off')
                            : item.title,
                        style: Theme.of(context).textTheme.caption.copyWith(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Text(
            _detailPage?.product?.description,
            style: Theme.of(context).textTheme.bodyText1.copyWith(height: 1.3),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      Translate.of(context).translate('date_established'),
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: Text(
                        _detailPage?.product?.date,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      Translate.of(context).translate('price_range'),
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: Text(
                        _detailPage?.product?.priceRange,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 10, bottom: 20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    Translate.of(context).translate('facilities'),
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _detailPage.product.service.map((item) {
                    return IntrinsicWidth(
                      child: AppTag(
                        item.title,
                        type: TagType.chip,
                        icon: Icon(
                          UtilIcon.getIconData(item.icon),
                          size: 12,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///Build list feature
  Widget _buildFeature() {
    if (_detailPage?.product?.feature == null) {
      return Container();
    }

    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 15,
            ),
            child: Text(
              Translate.of(context).translate('featured'),
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 20),
              itemBuilder: (context, index) {
                final ProductModel item = _detailPage.product.feature[index];
                return Container(
                  width: MediaQuery.of(context).size.width / 2,
                  padding: EdgeInsets.only(right: 15),
                  child: AppProductItem(
                    onPressed: _onProductDetail,
                    item: item,
                    type: ProductViewType.gird,
                  ),
                );
              },
              itemCount: _detailPage.product.feature.length,
            ),
          )
        ],
      ),
    );
  }

  ///Build list related
  Widget _buildRelated() {
    if (_detailPage?.product?.related == null) {
      return Container();
    }

    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Text(
              Translate.of(context).translate('related'),
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Column(
            children: _detailPage.product.related.map((item) {
              return Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: AppProductItem(
                  onPressed: _onProductDetail,
                  item: item,
                  type: ProductViewType.small,
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.map),
                onPressed: _onLocation,
              ),
              IconButton(
                icon: Icon(Icons.photo_library),
                onPressed: _onPhotoPreview,
              )
            ],
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
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: AppUserInfo(
                        user: _detailPage?.product?.author,
                        onPressed: () {},
                        type: AppUserType.basic,
                      ),
                    ),
                    _buildInfo(),
                    _buildFeature(),
                    _buildRelated()
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
