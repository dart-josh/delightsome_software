import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SearchQtyDialog extends StatefulWidget {
  final String name;
  const SearchQtyDialog({super.key, required this.name});

  @override
  State<SearchQtyDialog> createState() => _SearchQtyDialogState();
}

class _SearchQtyDialogState extends State<SearchQtyDialog> {
  final TextEditingController search_qty_controller = TextEditingController();

  final FocusNode search_qty_node = FocusNode();

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) FocusScope.of(context).requestFocus(search_qty_node);
    });
    super.initState();
  }

  @override
  void dispose() {
    search_qty_controller.dispose();
    search_qty_node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 300,
        ),
        child: Container(
          width: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // heading
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF000000),
                      offset: Offset(0.7, 0.7),
                      blurRadius: 6,
                    ),
                  ],
                  color: isDarkTheme
                      ? AppColors.dark_primaryBackgroundColor
                      : AppColors.light_dialogBackground_3,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 2),

                    // title
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isDarkTheme
                                ? AppColors.dark_primaryTextColor
                                : AppColors.light_primaryTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),

                    // horizontal line
                    Container(
                      height: 1,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isDarkTheme
                                ? AppColors.dark_dimTextColor
                                : AppColors.light_dimTextColor,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 4),

                    // subtitle
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      child: Text(
                        'Enter quantity of Item below',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDarkTheme
                              ? AppColors.dark_secondaryTextColor
                              : AppColors.light_secondaryTextColor,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),

              Container(
                width: 100,
                height: 50,
                child: TextField(
                  onSubmitted: (val) {
                    apply_qty();
                  },
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  focusNode: search_qty_node,
                  controller: search_qty_controller,
                  cursorColor: Colors.white70,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isDarkTheme
                            ? Colors.white
                            : AppColors.light_dialogBackground_1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.dark_dimTextColor,
                      ),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),

              SizedBox(height: 10),

              // action buttons
              InkWell(
                onTap: () {
                  apply_qty();
                },
                child: Container(
                  // width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.orange_2,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Center(
                    child: Text(
                      'ADD',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        // height: 1,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  apply_qty() {
    if (search_qty_controller.text.isNotEmpty &&
        int.parse(search_qty_controller.text) != 0) {
      int search_qty = int.parse(search_qty_controller.text);
      Navigator.pop(context, search_qty);
    } else {
      UniversalHelpers.showToast(
        context: context,
        color: Colors.redAccent,
        toastText: 'Enter a quantity',
        icon: Icons.error_outline,
      );
      FocusScope.of(context).requestFocus(search_qty_node);
      return;
    }
  }
}
