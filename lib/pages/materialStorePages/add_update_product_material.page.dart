import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/materialStoreModels/productMaterials.model.dart';
import 'package:delightsome_software/helpers/materialStoreHelpers.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:delightsome_software/widgets/select_form.dart';
import 'package:delightsome_software/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddUpdateProductMaterial extends StatefulWidget {
  final ProductMaterialsModel? item;
  const AddUpdateProductMaterial({super.key, this.item});

  @override
  State<AddUpdateProductMaterial> createState() =>
      _AddUpdateProductMaterialState();
}

class _AddUpdateProductMaterialState extends State<AddUpdateProductMaterial> {
  final TextEditingController name_controller = TextEditingController();
  final TextEditingController old_qty_controller = TextEditingController();
  final TextEditingController new_qty_controller = TextEditingController();
  final TextEditingController restock_limit_controller =
      TextEditingController();

  String category = '';
  List<String> categories = [];

  bool edit = false;
  bool new_item = true;

  void get_categories() {
    var cats = Provider.of<AppData>(context).product_material_categories;

    categories = cats.map((e) => e.category).toList();
  }

  void get_values() {
    if (widget.item == null) {
      new_item = true;
      edit = true;
    } else {
      name_controller.text = widget.item!.itemName;
      old_qty_controller.text = widget.item!.quantity.toString();
      restock_limit_controller.text = widget.item!.restockLimit.toString();
      category = widget.item!.category;
      edit = false;
      new_item = false;
    }
  }

  @override
  void initState() {
    get_values();
    super.initState();
  }

  @override
  void dispose() {
    name_controller.dispose();
    old_qty_controller.dispose();
    new_qty_controller.dispose();
    restock_limit_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;
    double width = MediaQuery.of(context).size.width;

    get_categories();

    // dialog
    if (width > 600) {
      return Dialog(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        child: Container(
          width: 600,
          height: 520,
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
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Column(
                              children: [
                                // details
                                if (widget.item != null) details(),

                                SizedBox(height: 20),

                                formBox(),

                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),

                      if (edit) SizedBox(height: 10),

                      // submit
                      if (edit) submit_button(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // scaffold
    return Scaffold(
      backgroundColor: isDarkTheme
          ? AppColors.dark_primaryBackgroundColor
          : AppColors.light_dialogBackground_3,
      body: Column(
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
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Column(
                          children: [
                            // details
                            if (widget.item != null) details(),

                            SizedBox(height: 20),

                            formBox(),

                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),

                  if (edit) SizedBox(height: 10),

                  // submit
                  if (edit) submit_button(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGETS

  // top bar
  Widget top_bar() {
    var auth_staff = Provider.of<AppData>(context).active_staff;

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
              if (!new_item &&
                  (auth_staff!.fullaccess))
                InkWell(
                  onTap: () {
                    edit = !edit;

                    if (!edit) {
                      get_values();
                    }

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
              if (edit && !new_item && (auth_staff!.fullaccess))
                InkWell(
                  onTap: () async {
                    bool? response = await UniversalHelpers.showConfirmBox(
                      context,
                      title: 'Delete Item',
                      subtitle:
                          'This would permanently remove this item from the database!\nWould you like to proceed?',
                    );

                    if (response != null && response == true) {
                      bool res =
                          await MaterialStoreHelpers.delete_product_materials(
                              context, widget.item!.key!);

                      if (res) Navigator.pop(context);
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
              new_item
                  ? 'New Product Material'
                  : edit
                      ? 'Edit Product Material'
                      : 'Manage Product Material',
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
              Text('Item Name', style: labelStyle),
              Text(widget.item!.itemName, style: mainStyle),
            ],
          ),
          Expanded(child: Container()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Quantity', style: labelStyle),
              Text(widget.item!.quantity.toString(), style: mainStyle),
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
              controller: name_controller,
              label: 'Item Name',
              edit: !edit,
            ),
          ),

          // category
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Select_form(
              label: 'Category',
              options: categories,
              text_value: category,
              edit: edit,
              setval: (val) {
                if (val != null) {
                  category = val;
                  setState(() {});
                }
              },
            ),
          ),

          // quantity
          if (new_item || !edit)
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text_field(
                label: 'Qunatity',
                controller: old_qty_controller,
                edit: !edit,
                format: [FilteringTextInputFormatter.digitsOnly],
              ),
            )
          else
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  // old qty
                  Expanded(
                    child: Container(
                      child: Text_field(
                        label: 'Old Qunatity',
                        controller: old_qty_controller,
                        format: [FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.only(top: 20),
                    child: Icon(Icons.add, size: 22),
                  ),

                  // new qty
                  Expanded(
                    child: Container(
                      child: Text_field(
                        label: 'New Qunatity',
                        controller: new_qty_controller,
                        format: [FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // restock limit
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text_field(
              label: 'Restock Limit',
              controller: restock_limit_controller,
              format: [FilteringTextInputFormatter.digitsOnly],
              edit: !edit,
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
          if (name_controller.text.isEmpty) {
            UniversalHelpers.showToast(
              context: context,
              color: Colors.redAccent,
              toastText: 'Item name cannot be empty!!',
              icon: Icons.error,
            );
            return;
          }

          if (category.isEmpty) {
            UniversalHelpers.showToast(
              context: context,
              color: Colors.redAccent,
              toastText: 'Select a category!!',
              icon: Icons.error,
            );
            return;
          }

          int quantity = (old_qty_controller.text.isNotEmpty
                  ? int.parse(old_qty_controller.text.trim())
                  : 0) +
              (new_qty_controller.text.isNotEmpty
                  ? int.parse(new_qty_controller.text.trim())
                  : 0);

          bool? response = await UniversalHelpers.showConfirmBox(
            context,
            title: 'Save Item',
            subtitle:
                'You are about to save this item!\nWould you like to proceed?',
          );

          if (response != null && response) {
            ProductMaterialsModel new_item = ProductMaterialsModel(
              key: widget.item?.key,
              itemName: name_controller.text.trim(),
              category: category,
              quantity: quantity,
              restockLimit: restock_limit_controller.text.isNotEmpty
                  ? int.parse(restock_limit_controller.text)
                  : 0,
            );

            Map map = new_item.toJson();

            bool done = await MaterialStoreHelpers.add_update_product_materials(
                context, map);
            if (done) {
              Navigator.pop(context, true);
            }
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
