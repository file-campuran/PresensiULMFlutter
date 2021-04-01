import 'package:flutter/material.dart';

final bool cleanStyle = true;

class AppCustomAppBar {
  static AppBar defaultAppBar(
      {@required BuildContext context,
      Widget leading,
      Color backgroundColor,
      Brightness brightness,
      @required String title,
      double elavation = 0,
      List<Widget> actions,
      PreferredSizeWidget bottom}) {
    return AppBar(
      actionsIconTheme: cleanStyle
          ? IconThemeData(
              color: Theme.of(context).brightness == Brightness.light
                  ? Color(0xff303030)
                  : Colors.white)
          : null,
      iconTheme: cleanStyle
          ? IconThemeData(
              color: Theme.of(context).brightness == Brightness.light
                  ? Color(0xff303030)
                  : Colors.white, //change your color here
            )
          : null,
      centerTitle: false,
      brightness: brightness ?? Theme.of(context).brightness,
      leading: leading,
      backgroundColor: backgroundColor == null
          ? Theme.of(context).brightness == Brightness.dark
              ? Color(0xff303030)
              : Colors.white
          : backgroundColor,
      elevation: elavation,
      title: setTitleAppBar(
        context,
        title,
      ),
      actions: actions,
      bottom: bottom,
    );
  }

  static AppBar searchAppBar(
      BuildContext context, TextEditingController textController) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
        child: Wrap(children: [
          Container(
              width: 25.0,
              height: 30.0,
              child: Icon(
                Icons.search,
                color: Colors.grey,
                size: 20.0,
              )),
          Container(
            width: MediaQuery.of(context).size.width - 100,
            height: 30.0,
            child: TextField(
                controller: textController,
                autofocus: true,
                maxLines: 1,
                minLines: 1,
                maxLength: 255,
                style: TextStyle(color: Colors.black, fontSize: 15.0),
                decoration: InputDecoration(
                    hintText: 'Dictionary.hintSearch',
                    counterText: "",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(5.0))),
          ),
        ]),
      ),
      titleSpacing: 0.0,
    );
  }

  // static AppBar bottomSearchAppBar(
  //     {@required TextEditingController searchController,
  //     @required String title,
  //     @required String hintText,
  //     ValueChanged<String> onChanged}) {
  //   return AppBar(
  //       backgroundColor: Colors.white,
  //       bottom: PreferredSize(
  //         preferredSize: Size.fromHeight(60.0),
  //         child: buildSearchField(searchController, hintText, onChanged),
  //       ),
  //       title: AppCustomAppBar.setTitleAppBar(context, title));
  // }

  static Widget setTitleAppBar(BuildContext context, String title) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          child: child,
          position:
              Tween<Offset>(begin: Offset(0.0, 0.5), end: Offset(0.0, 0.0))
                  .animate(animation),
        );
      },
      child: Text(title,
          key: ValueKey<String>(title),
          style: TextStyle(
            // fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: cleanStyle
                ? Theme.of(context).brightness == Brightness.light
                    ? Color(0xff303030)
                    : Colors.white
                : null,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
    );
  }

  static Widget buildSearchField(TextEditingController searchController,
      String hintText, ValueChanged<String> onChanged) {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20),
      height: 40.0,
      decoration: BoxDecoration(
          color: Color(0xffFAFAFA),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0)),
      child: TextField(
        controller: searchController,
        autofocus: false,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Color(0xff828282),
            ),
            hintText: hintText,
            border: InputBorder.none,
            hintStyle:
                TextStyle(color: Color(0xff828282), fontSize: 12, height: 2.2),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0)),
        style: TextStyle(color: Colors.black, fontSize: 16.0),
        onChanged: onChanged,
      ),
    );
  }
}
