import 'package:flutter/material.dart';

class AppRadioInput extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String errorText;
  final String title;
  final int maxLines;
  final List<dynamic> data;
  final dynamic value;

  AppRadioInput(
      {Key key,
      this.onChanged,
      this.errorText,
      this.title,
      this.maxLines = 1,
      this.value,
      this.data})
      : super(key: key);

  Widget _buildErrorLabel(BuildContext context) {
    if (errorText == null) {
      return Container();
    }

    return Container(
      padding: EdgeInsets.only(top: 2, left: 10),
      child: Text(
        errorText,
        style: TextStyle(fontSize: 12, color: Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .subtitle2
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: data.map((item) {
            final bool selected = value == item;
            return SizedBox(
              height: 32,
              child: FilterChip(
                selected: selected,
                label: Text(item),
                onSelected: (value) {
                  onChanged(item);
                },
              ),
            );
          }).toList(),
        ),
        _buildErrorLabel(context),
      ],
    );
  }
}
