import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const baseUrl = 'assets/icons/duotone';
enum MyIconDuotoneIcon {
  alarm,
  account,
  address,
  calendar,
  clock_checked,
  commercial,
  developer_mode,
  home_page,
  save_close,
  search,
  settings,
}

const iconsMap = <MyIconDuotoneIcon, String>{
  MyIconDuotoneIcon.alarm: '$baseUrl/alarm.svg',
  MyIconDuotoneIcon.account: '$baseUrl/account.svg',
  MyIconDuotoneIcon.address: '$baseUrl/address.svg',
  MyIconDuotoneIcon.calendar: '$baseUrl/calendar.svg',
  MyIconDuotoneIcon.clock_checked: '$baseUrl/clock_checked.svg',
  MyIconDuotoneIcon.commercial: '$baseUrl/commercial.svg',
  MyIconDuotoneIcon.developer_mode: '$baseUrl/developer_mode.svg',
  MyIconDuotoneIcon.home_page: '$baseUrl/home_page.svg',
  MyIconDuotoneIcon.save_close: '$baseUrl/save_close.svg',
  MyIconDuotoneIcon.search: '$baseUrl/search.svg',
  MyIconDuotoneIcon.settings: '$baseUrl/settings.svg',
};

class MyIconDuotone extends StatelessWidget {
  final double height;
  final Color color;
  final MyIconDuotoneIcon icon;
  const MyIconDuotone(this.icon,
      {Key key, this.height, this.color = Colors.grey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      iconsMap[icon],
      color: color,
      height: height,
    );
  }
}
