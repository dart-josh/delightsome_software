import 'package:collection/collection.dart';
import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/productStoreModels/product.model.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductSelector extends StatefulWidget {
  final List<ProductModel> products;
  const ProductSelector({super.key, required this.products});

  @override
  State<ProductSelector> createState() =>
      _ProductSelectorState();
}

class _ProductSelectorState extends State<ProductSelector> {
  TextStyle labelStyle = TextStyle(
      color: Color(0xFFc3c3c3), fontSize: 15, fontWeight: FontWeight.bold);

  List<GroupedProductModel> grouped_list = [];
  GroupedProductModel? selected_group;
  ProductModel? selected_product;

  void group_list() {
    var _list = widget.products;

    final groups = groupBy(
      _list,
      (e) => (e.category.isNotEmpty) ? e.category : 'Unkwown',
    );

    grouped_list.clear();
    GroupedProductModel val = GroupedProductModel(
      category: 'All',
      productMaterials: _list,
    );
    grouped_list.add(val);

    groups.forEach((key, value) {
      GroupedProductModel val = GroupedProductModel(
        category: key,
        productMaterials: value,
      );
      grouped_list.add(val);
      setState(() {});
    });
  }

  @override
  void initState() {
    group_list();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 300,
        height: 340,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // top bar
            top_bar(),

            // content
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 5),
                padding: EdgeInsets.only(bottom: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDarkTheme
                      ? AppColors.dark_dialogBackground_1
                      : AppColors.light_dialogBackground_1,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // category label
                        Text(
                          'Select Category',
                          style: TextStyle(
                            color: isDarkTheme
                                ? AppColors.dark_secondaryTextColor
                                : AppColors.light_secondaryTextColor,
                          ),
                        ),
                        SizedBox(height: 8),

                        // category
                        DropdownButtonFormField<GroupedProductModel>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: 'Category',
                            labelStyle: TextStyle(
                              color: isDarkTheme
                                  ? AppColors.dark_secondaryTextColor
                                  : AppColors.light_secondaryTextColor,
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(15, 12, 10, 12),
                          ),
                          dropdownColor: isDarkTheme
                              ? AppColors.dark_primaryBackgroundColor
                              : AppColors.light_dialogBackground_1,
                          value: selected_group,
                          items: grouped_list.isNotEmpty
                              ? grouped_list
                                  .map((e) => DropdownMenuItem<
                                          GroupedProductModel>(
                                      value: e, child: Text(e.category)))
                                  .toList()
                              : [],
                          onChanged: (val) {
                            if (val != null) {
                              selected_product = null;
                              selected_group = null;
                              setState(() {});

                              Future.delayed(Duration(milliseconds: 100), () {
                                selected_group = val;
                                setState(() {});
                              });
                            }
                          },
                        ),

                        SizedBox(height: 10),

                        // next bar
                        if (selected_group != null)
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Icon(
                              Icons.keyboard_double_arrow_down,
                              color: isDarkTheme
                                  ? AppColors.dark_secondaryTextColor
                                  : AppColors.light_secondaryTextColor,
                              size: 30,
                            ),
                          ),

                        // items label
                        if (selected_group != null)
                          Text(
                            'Select Product',
                            style: TextStyle(
                              color: isDarkTheme
                                  ? AppColors.dark_secondaryTextColor
                                  : AppColors.light_secondaryTextColor,
                            ),
                          ),

                        SizedBox(height: 8),

                        // items
                        if (selected_group != null)
                          DropdownButtonFormField<ProductModel>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: 'Product',
                              labelStyle: TextStyle(
                                color: isDarkTheme
                                    ? AppColors.dark_secondaryTextColor
                                    : AppColors.light_secondaryTextColor,
                              ),
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(15, 12, 10, 12),
                            ),
                            dropdownColor: isDarkTheme
                                ? AppColors.dark_primaryBackgroundColor
                                : AppColors.light_dialogBackground_1,
                            value: selected_product,
                            items: selected_group!.productMaterials.isNotEmpty
                                ? selected_group!.productMaterials
                                    .map(
                                      (e) => DropdownMenuItem<
                                          ProductModel>(
                                        value: e,
                                        enabled: e.isAvailable,
                                        child: Text(
                                          e.name,
                                          style: TextStyle(
                                            color: !e.isAvailable ? isDarkTheme ? AppColors.dark_dimTextColor : AppColors.light_dimTextColor : null,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList()
                                : [],
                            onChanged: (val) {
                              if (val != null) {
                                selected_product = val;
                                setState(() {});
                              }
                            },
                          ),

                        SizedBox(height: 30),

                        // submit
                        if (selected_product != null) submit_button(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGETS
  // top bar
  Widget top_bar() {
    return Container(
      width: double.infinity,
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 8),
      color: AppColors.primaryForegroundColor,
      child: Stack(
        children: [
          // action buttons
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // close button
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: AppColors.secondaryWhiteIconColor,
                  size: 22,
                ),
              ),

              Expanded(child: Container()),
            ],
          ),

          // title
          Center(
            child: Text(
              'Select Product',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // submit button
  Widget submit_button() {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () {
          Navigator.pop(context, selected_product);
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.orange_1,
            borderRadius: BorderRadius.circular(6),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check,
                  color: AppColors.secondaryWhiteIconColor,
                ),
                SizedBox(width: 8),
                Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//
}

class GroupedProductModel {
  List<ProductModel> productMaterials;
  String category;

  GroupedProductModel({
    required this.productMaterials,
    required this.category,
  });
}
