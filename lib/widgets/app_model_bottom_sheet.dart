// import 'package:flutter/material.dart';
// import 'package:absen_online/models/model.dart';
// import 'package:absen_online/utils/utils.dart';
// import 'package:absen_online/widgets/widget.dart';

// class AppModelBottomSheet extends StatefulWidget {
//   final SortModel selected;
//   final List<SortModel> option;
//   final ValueChanged onChange;

//   AppModelBottomSheet({
//     Key key,
//     this.selected,
//     this.option,
//     this.onChange,
//   }) : super(key: key);

//   @override
//   _AppModelBottomSheetState createState() {
//     return _AppModelBottomSheetState();
//   }
// }

// class _AppModelBottomSheetState extends State<AppModelBottomSheet> {
//   SortModel _currentSort;

//   @override
//   void initState() {
//     _currentSort = widget.selected;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       bottom: false,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Theme.of(context).scaffoldBackgroundColor,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(10),
//             topRight: Radius.circular(10),
//           ),
//         ),
//         child: Padding(
//           padding: EdgeInsets.only(left: 20, right: 20),
//           child: SingleChildScrollView(
//             child: IntrinsicHeight(
//               child: Column(
//                 children: <Widget>[
//                   Container(
//                     margin: EdgeInsets.all(10),
//                     width: 40,
//                     height: 3,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(10),
//                       ),
//                       color: Theme.of(context).dividerColor,
//                     ),
//                   ),
//                   Column(
//                     children: widget.option.map((item) {
//                       return AppListTitle(
//                         title: Translate.of(context).translate(item.name),
//                         textStyle: item.code == _currentSort.code
//                             ? Theme.of(context)
//                                 .textTheme
//                                 .subtitle1
//                                 .copyWith(color: Theme.of(context).primaryColor)
//                             : null,
//                         trailing: item.code == _currentSort.code
//                             ? Icon(
//                                 Icons.check,
//                                 color: Theme.of(context).primaryColor,
//                               )
//                             : Container(),
//                         onPressed: () {
//                           setState(() {
//                             _currentSort = item;
//                           });
//                         },
//                       );
//                     }).toList(),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(top: 20, bottom: 20),
//                     child: AppButton(
//                       onPressed: () {
//                         widget.onChange(_currentSort);
//                         Navigator.pop(context);
//                       },
//                       text: Translate.of(context).translate('apply'),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
