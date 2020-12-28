import 'package:flutter/material.dart';
import 'package:absen_online/models/model.dart';
import 'package:absen_online/models/screen_models/screen_models.dart';
import 'package:absen_online/utils/utils.dart';
import 'package:absen_online/widgets/widget.dart';

class TabContent extends StatelessWidget {
  final TabModel item;
  final ProductDetailTabPageModel page;
  final Function(ProductModel) onProductDetail;

  TabContent({
    Key key,
    this.item,
    this.page,
    this.onProductDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (item.key) {
      case 'information':
        return Container(
          key: item.keyContentItem,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Text(
                    Translate.of(context).translate(item.title),
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
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
                              page?.product?.address,
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
                              page?.product?.phone,
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
                              page?.product?.email,
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
                              page?.product?.website,
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
                Row(
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
                                  page?.product?.hour,
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
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: page.product.hourDetail.map((item) {
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
                        top: 8,
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
                            item.time == 'day_off'
                                ? Translate.of(context).translate('day_off')
                                : item.time,
                            style: Theme.of(context).textTheme.caption.copyWith(
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Text(
                  page?.product?.description,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(height: 1.3),
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
                              page?.product?.date,
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
                              page?.product?.priceRange,
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
              ],
            ),
          ),
        );

      case 'facilities':
        return Container(
          key: item.keyContentItem,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 15, top: 15),
                  child: Text(
                    Translate.of(context).translate('facilities'),
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: page.product.service.map((item) {
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
                ),
              ],
            ),
          ),
        );

      case 'featured':
        return Container(
          key: item.keyContentItem,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 15,
                  top: 15,
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
                    final ProductModel item = page?.product?.feature[index];
                    return Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: EdgeInsets.only(right: 15),
                      child: AppProductItem(
                        onPressed: onProductDetail,
                        item: item,
                        type: ProductViewType.gird,
                      ),
                    );
                  },
                  itemCount: page.product.feature.length,
                ),
              ),
              Container(
                height: 15,
                margin: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
              )
            ],
          ),
        );

      case 'nearly':
        return Container(
          key: item.keyContentItem,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 15,
                  top: 15,
                ),
                child: Text(
                  Translate.of(context).translate('nearly'),
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                height: 145,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 20),
                  itemBuilder: (context, index) {
                    final ProductModel item = page?.product?.feature[index];
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: EdgeInsets.only(right: 15),
                      child: AppProductItem(
                        onPressed: onProductDetail,
                        item: item,
                        type: ProductViewType.list,
                      ),
                    );
                  },
                  itemCount: page.product.feature.length,
                ),
              ),
              Container(
                height: 15,
                margin: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
              )
            ],
          ),
        );

      case 'related':
        return Container(
          key: item.keyContentItem,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Text(
                    Translate.of(context).translate('related'),
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Column(
                  children: page.product.related.map((item) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: AppProductItem(
                        onPressed: onProductDetail,
                        item: item,
                        type: ProductViewType.small,
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
          ),
        );

      default:
        return Container(
          key: item.keyContentItem,
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 20),
                child: Text(
                  Translate.of(context).translate(item.title),
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                height: 200,
                child: Placeholder(),
              )
            ],
          ),
        );
    }
  }
}
