import 'package:collection/collection.dart';
import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/materialStoreModels/productMaterials.model.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductMaterialSelector extends StatefulWidget {
  final List<ProductMaterialsModel> product_materials;
  const ProductMaterialSelector({super.key, required this.product_materials});

  @override
  State<ProductMaterialSelector> createState() =>
      _ProductMaterialSelectorState();
}

class _ProductMaterialSelectorState extends State<ProductMaterialSelector> {
  TextStyle labelStyle = TextStyle(
      color: Color(0xFFc3c3c3), fontSize: 15, fontWeight: FontWeight.bold);

  List<GroupedProductMaterialsModel> grouped_list = [];
  GroupedProductMaterialsModel? selected_group;
  ProductMaterialsModel? selected_item;

  void group_list() {
    var _list = widget.product_materials;

    final groups = groupBy(
      _list,
      (e) => (e.category.isNotEmpty) ? e.category : 'Unkwown',
    );

    grouped_list.clear();
    GroupedProductMaterialsModel val = GroupedProductMaterialsModel(
      category: 'All',
      productMaterials: _list,
    );
    grouped_list.add(val);

    groups.forEach((key, value) {
      GroupedProductMaterialsModel val = GroupedProductMaterialsModel(
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
                        DropdownButtonFormField<GroupedProductMaterialsModel>(
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
                                          GroupedProductMaterialsModel>(
                                      value: e, child: Text(e.category)))
                                  .toList()
                              : [],
                          onChanged: (val) {
                            if (val != null) {
                              selected_item = null;
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
                            'Select Item',
                            style: TextStyle(
                              color: isDarkTheme
                                  ? AppColors.dark_secondaryTextColor
                                  : AppColors.light_secondaryTextColor,
                            ),
                          ),

                        SizedBox(height: 8),

                        // items
                        if (selected_group != null)
                          DropdownButtonFormField<ProductMaterialsModel>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: 'Item',
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
                            value: selected_item,
                            items: selected_group!.productMaterials.isNotEmpty
                                ? selected_group!.productMaterials
                                    .map(
                                      (e) => DropdownMenuItem<
                                          ProductMaterialsModel>(
                                        value: e,
                                        child: Text(
                                          e.itemName,
                                          style: TextStyle(),
                                        ),
                                      ),
                                    )
                                    .toList()
                                : [],
                            onChanged: (val) {
                              if (val != null) {
                                selected_item = val;
                                setState(() {});
                              }
                            },
                          ),

                        SizedBox(height: 30),

                        // submit
                        if (selected_item != null) submit_button(),
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
              'Select Item',
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
          Navigator.pop(context, selected_item);
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

class GroupedProductMaterialsModel {
  List<ProductMaterialsModel> productMaterials;
  String category;

  GroupedProductMaterialsModel({
    required this.productMaterials,
    required this.category,
  });
}
