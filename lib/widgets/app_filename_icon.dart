import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppFilenameIcon extends StatelessWidget {
  final String fileName;
  final Function onTap;
  const AppFilenameIcon({Key key, this.fileName, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 10,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _icon(fileName),
                SizedBox(
                  width: 3,
                ),
                Flexible(
                  child: Text(
                    fileName,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              child: Icon(
                Icons.close,
                color: Colors.grey,
                size: 18,
              ),
              onTap: onTap,
            ),
          )
        ],
      ),
    );
  }

  Widget _icon(String fileName) {
    String ext = fileName?.split("/")?.last;
    ext = ext?.split(".")?.last;

    IconData icon = Icons.file_present;

    switch (ext) {
      case 'jpeg':
      case 'jpg':
      case 'png':
        icon = Icons.image;
        break;

      case 'xls':
      case 'xlsx':
        icon = FontAwesomeIcons.fileExcel;
        break;

      case 'ppt':
      case 'pptx':
        icon = FontAwesomeIcons.filePowerpoint;
        break;

      case 'pdf':
        icon = FontAwesomeIcons.filePdf;
        break;

      case 'doc':
      case 'docx':
        icon = FontAwesomeIcons.fileWord;
        break;
    }

    return Icon(
      icon,
      size: 15,
      color: Colors.grey,
    );
  }
}
