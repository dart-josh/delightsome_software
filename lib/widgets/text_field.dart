import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Text_field extends StatelessWidget {
  const Text_field({
    super.key,
    this.label = '',
    required this.controller,
    this.node,
    this.hintText = '',
    this.maxLine = 1,
    this.edit = false,
    this.icon = null,
    this.prefix = null,
    this.center = false,
    this.ontap = null,
    this.format,
    this.label_left_padding = 10,
    this.obscure = false,
  });

  final String label;
  final TextEditingController controller;
  final FocusNode? node;
  final String hintText;
  final int maxLine;
  final bool edit;
  final Widget? icon;
  final Widget? prefix;
  final bool center;
  final void Function()? ontap;
  final List<TextInputFormatter>? format;
  final double label_left_padding;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    TextStyle labelStyle = TextStyle(
      color: isDarkTheme ? Color(0xFFc3c3c3) : Color.fromARGB(255, 61, 61, 61),
      fontSize: 12,
    );
    TextStyle textfieldStyle = TextStyle(
      color: isDarkTheme ? Colors.white : Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: 16,
    );
    TextStyle hintStyle = TextStyle(
      color: isDarkTheme ? Color(0xFFc3c3c3) : Color.fromARGB(255, 61, 61, 61),
      fontSize: 12,
      letterSpacing: 0.6,
      fontStyle: FontStyle.italic,
    );

    return Column(
      crossAxisAlignment:
          center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // label
        label.isNotEmpty
            ? Padding(
                padding: EdgeInsets.only(left: label_left_padding),
                child: Text(label, style: labelStyle),
              )
            : Container(),

        label.isNotEmpty ? SizedBox(height: 3) : Container(),
        Container(
          height: (maxLine == 1) ? 40 : null,
          child: TextField(
            style: textfieldStyle,
            readOnly: edit,
            controller: controller,
            focusNode: node,
            textInputAction: (maxLine == 1) ? TextInputAction.next : null,
            maxLines: maxLine,
            inputFormatters: format,
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: hintStyle,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isDarkTheme
                      ? AppColors.dark_dimTextColor
                      : AppColors.light_dimTextColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isDarkTheme
                      ? AppColors.dark_dimTextColor
                      : AppColors.light_dimTextColor,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isDarkTheme
                      ? AppColors.dark_secondaryTextColor
                      : AppColors.light_secondaryTextColor,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              contentPadding: EdgeInsets.fromLTRB(
                12,
                (maxLine == 1) ? 6 : 15,
                (icon == null) ? 12 : 1,
                (maxLine == 1) ? 6 : 15,
              ),
              suffixIcon: icon,
              prefix: prefix != null
                  ? Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: prefix,
                    )
                  : null,
            ),
            onTap: ontap,
          ),
        ),
      ],
    );
  }
}
