import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/category.model.dart';
import 'package:delightsome_software/globalvariables.dart';
import 'package:delightsome_software/helpers/materialStoreHelpers.dart';
import 'package:delightsome_software/helpers/productStoreHelpers.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:delightsome_software/widgets/select_form.dart';
import 'package:delightsome_software/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ManageCategory extends StatefulWidget {
  final CategoryModel? category;
  final String? category_type;
  const ManageCategory({super.key, this.category_type, this.category});

  @override
  State<ManageCategory> createState() => _ManageCategoryState();
}

class _ManageCategoryState extends State<ManageCategory> {
  final TextEditingController category_controller = TextEditingController();
  final TextEditingController sort_controller = TextEditingController();

  String category_type = '';

  bool edit = false;
  bool new_cat = true;

  void get_values() {
    category_type = widget.category_type ?? '';
    if (widget.category == null) {
      new_cat = true;
      edit = true;
    } else {
      category_controller.text = widget.category!.category;
      sort_controller.text = widget.category!.sort.toString();
      new_cat = false;
      edit = false;
    }
  }

  @override
  void initState() {
    get_values();
    super.initState();
  }

  @override
  void dispose() {
    category_controller.dispose();
    sort_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;
    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320,
        height: 450,
        child: Column(
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
                      children: [
                        // details
                        if (widget.category != null) details(),

                        SizedBox(height: 20),

                        formBox(),

                        SizedBox(height: 30),

                        // submit
                        if (edit) submit_button(),
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

              // edit button
              if (!new_cat && activeStaff!.fullaccess)
                InkWell(
                  onTap: () {
                    edit = !edit;

                    if (!edit) get_values();
                    setState(() {});
                  },
                  child: Icon(
                    edit ? Icons.check_circle : Icons.edit,
                    color: AppColors.secondaryWhiteIconColor,
                    size: 20,
                  ),
                ),

              SizedBox(width: 10),

              // delete button
              if (edit && !new_cat && activeStaff!.fullaccess)
                InkWell(
                  onTap: () async {
                    if (category_type.isEmpty ||
                        !category_type_list.contains(category_type)) {
                      UniversalHelpers.showToast(
                        context: context,
                        color: Colors.red,
                        toastText: 'Invalid Category Type',
                        icon: Icons.error,
                      );
                    }

                    bool? res = await UniversalHelpers.showConfirmBox(
                      context,
                      title: 'Delete Category',
                      subtitle:
                          'This would permanently remove this category from the database!\Would you like to proceed?',
                    );

                    if (res != null && res) {
                      bool done = false;
                      // product material store
                      if (category_type == 'Product Material Store') {
                        done = await MaterialStoreHelpers
                            .delete_product_materials_category(
                                context, widget.category!.key!);
                      }

                      // raw material store
                      if (category_type == 'Raw Material Store') {
                        done = await MaterialStoreHelpers
                            .delete_raw_materials_category(
                                context, widget.category!.key!);
                      }

                      // product store
                      if (category_type == 'Product Store') {
                        done =
                            await ProductStoreHelpers.delete_product_category(
                                context, widget.category!.key!);
                      }

                      if (done) Navigator.pop(context);
                    }
                  },
                  child: Icon(
                    Icons.delete,
                    color: AppColors.secondaryWhiteIconColor,
                    size: 20,
                  ),
                ),
            ],
          ),

          // title
          Center(
            child: Text(
              new_cat
                  ? 'New Category'
                  : edit
                      ? 'Edit Category'
                      : 'Manage Category',
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

  // details
  Widget details() {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    TextStyle labelStyle = TextStyle(
      fontSize: 12,
      color: isDarkTheme
          ? AppColors.dark_secondaryTextColor
          : AppColors.light_secondaryTextColor,
    );
    TextStyle mainStyle = TextStyle(
      fontSize: 16,
      color: isDarkTheme
          ? AppColors.dark_primaryTextColor
          : AppColors.light_primaryTextColor,
      fontWeight: FontWeight.bold,
    );

    return Container(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Category Name', style: labelStyle),
              Text(widget.category!.category, style: mainStyle),
            ],
          ),
          Expanded(child: Container()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Sort', style: labelStyle),
              Text(widget.category!.sort.toString(), style: mainStyle),
            ],
          ),
        ],
      ),
    );
  }

  Widget formBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // name
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text_field(
              controller: category_controller,
              label: 'Category Name',
              edit: !edit,
            ),
          ),

          // sort
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text_field(
              controller: sort_controller,
              label: 'Category Sort',
              edit: !edit,
              format: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),

          // category type
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Select_form(
              label: 'Category Section',
              edit: new_cat,
              options: category_type_list,
              text_value: category_type,
              setval: (val) {
                category_type = val;
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  // submit button
  Widget submit_button() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () async {
          if (category_type.isEmpty ||
              !category_type_list.contains(category_type)) {
            UniversalHelpers.showToast(
              context: context,
              color: Colors.red,
              toastText: 'Invalid Category Type',
              icon: Icons.error,
            );
            return;
          }

          Map map = CategoryModel(
                  category: category_controller.text.trim(),
                  sort: int.parse(sort_controller.text.trim()),
                  key: widget.category?.key)
              .toJson();

          bool? res = await UniversalHelpers.showConfirmBox(
            context,
            title: 'Save Category',
            subtitle:
                'This would save this category to the database!\Would you like to proceed?',
          );

          if (res != null && res) {
            bool done = false;
            // product material store
            if (category_type == 'Product Material Store') {
              done = await MaterialStoreHelpers
                  .add_update_product_materials_category(context, map);
            }

            // raw material store
            if (category_type == 'Raw Material Store') {
              done =
                  await MaterialStoreHelpers.add_update_raw_materials_category(
                      context, map);
            }

            // product store
            if (category_type == 'Product Store') {
              done = await ProductStoreHelpers.add_update_product_category(
                  context, map);
            }

            if (done) Navigator.pop(context);
          }
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
