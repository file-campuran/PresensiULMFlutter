// import 'package:flutter/material.dart';
// import 'package:absen_online/models/model.dart';
// import 'package:absen_online/utils/utils.dart';
// import 'package:shimmer/shimmer.dart';

// class HomeCategoryItem extends StatelessWidget {
//   final CategoryModel item;
//   final ValueChanged<CategoryModel> onPressed;

//   HomeCategoryItem({
//     Key key,
//     this.item,
//     this.onPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (item == null) {
//       return Shimmer.fromColors(
//         baseColor: Theme.of(context).hoverColor,
//         highlightColor: Theme.of(context).highlightColor,
//         enabled: true,
//         child: Container(
//           width: MediaQuery.of(context).size.width * 0.21,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Container(
//                 width: 36,
//                 height: 36,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white,
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(top: 3),
//                 child: Text(
//                   Translate.of(context).translate('loading'),
//                   style: Theme.of(context)
//                       .textTheme
//                       .caption
//                       .copyWith(fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return Container(
//       width: MediaQuery.of(context).size.width * 0.21,
//       child: GestureDetector(
//         onTap: () => onPressed(item),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//               width: 36,
//               height: 36,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: item.color,
//               ),
//               child: Icon(
//                 item.icon,
//                 size: 18,
//                 color: Colors.white,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(top: 3, left: 2, right: 2),
//               child: Text(
//                 item.title,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: Theme.of(context)
//                     .textTheme
//                     .caption
//                     .copyWith(fontWeight: FontWeight.w500),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
