// ignore_for_file: must_be_immutable

import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:delightsome_software/widgets/options_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Select_form extends StatefulWidget {
  Select_form({
    super.key,
    required this.label,
    required this.options,
    required this.text_value,
    required this.setval,
    this.edit = true,
  });

  final String label;
  final List<String> options;
  String text_value;
  Function setval;
  final bool edit;

  @override
  State<Select_form> createState() => _Select_formState();
}

class _Select_formState extends State<Select_form> {
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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // label
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(widget.label, style: labelStyle),
          ),

          SizedBox(height: 3),

          // select field
          Container(
            // width: 250,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: isDarkTheme
                    ? AppColors.dark_dimTextColor
                    : AppColors.light_dimTextColor,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: InkWell(
              onTap: () async {
                if (!widget.edit) return;

                // open options dialog
                var response = await showDialog(
                  context: context,
                  builder: (context) => OptionsDialog(
                    title: widget.label,
                    options: widget.options,
                  ),
                );

                if (response != null) widget.setval(response);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // text
                    Expanded(
                      child: Text(
                        widget.text_value,
                        style: textfieldStyle,
                      ),
                    ),

                    // icon
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: (widget.edit)
                          ? isDarkTheme
                              ? Color(0xFF9b9B9B)
                              : Color.fromARGB(255, 84, 84, 84)
                          : Colors.transparent,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
