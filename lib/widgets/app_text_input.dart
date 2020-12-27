import 'package:flutter/material.dart';

class AppTextInput extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onTapIcon;
  final GestureTapCallback onTap;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final Icon icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String errorText;
  final int maxLines;

  AppTextInput({
    Key key,
    this.hintText,
    this.controller,
    this.focusNode,
    this.onTapIcon,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.errorText,
    this.maxLines = 1,
  }) : super(key: key);

  Widget _buildErrorLabel(BuildContext context) {
    if (errorText == null) {
      return Container();
    }

    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Text(
        errorText,
        style: Theme.of(context)
            .textTheme
            .caption
            .copyWith(color: Theme.of(context).errorColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          TextField(
            onTap: onTap,
            textAlignVertical: TextAlignVertical.center,
            onSubmitted: onSubmitted,
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              suffixIcon: icon != null
                  ? IconButton(
                      icon: icon,
                      onPressed: onTapIcon,
                    )
                  : null,
              border: InputBorder.none,
            ),
          ),
          _buildErrorLabel(context)
        ],
      ),
    );
  }
}
