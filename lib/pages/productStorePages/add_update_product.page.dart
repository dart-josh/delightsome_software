import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/productStoreModels/product.model.dart';
import 'package:delightsome_software/helpers/productStoreHelpers.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:delightsome_software/widgets/select_form.dart';
import 'package:delightsome_software/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AddUpdateProduct extends StatefulWidget {
  final ProductModel? product;
  final String page;
  const AddUpdateProduct({super.key, this.product, required this.page});

  @override
  State<AddUpdateProduct> createState() => _AddUpdateProductState();
}

class _AddUpdateProductState extends State<AddUpdateProduct> {
  final TextEditingController name_controller = TextEditingController();
  final TextEditingController old_qty_controller = TextEditingController();
  final TextEditingController new_qty_controller = TextEditingController();
  final TextEditingController restock_limit_controller =
      TextEditingController();
  final TextEditingController code_controller = TextEditingController();
  final TextEditingController store_price_controller = TextEditingController();
  final TextEditingController online_price_controller = TextEditingController();

  bool isAvailable = true;
  bool isOnline = false;

  String category = '';
  List<String> categories = [];

  bool edit = false;
  bool new_product = true;

  void get_categories() {
    var cats = Provider.of<AppData>(context).product_categories;

    categories = cats.map((e) => e.category).toList();
  }

  void get_values() {
    if (widget.product == null) {
      new_product = true;
      edit = true;
    } else {
      name_controller.text = widget.product!.name;
      old_qty_controller.text = widget.product!.quantity.toString();
      restock_limit_controller.text = widget.product!.restockLimit.toString();
      category = widget.product!.category;
      code_controller.text = widget.product!.code;
      store_price_controller.text = widget.product!.storePrice.toString();
      online_price_controller.text = widget.product!.onlinePrice.toString();
      isAvailable = widget.product!.isAvailable;
      isOnline = widget.product!.isOnline;

      edit = false;
      new_product = false;
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
    code_controller.dispose();
    store_price_controller.dispose();
    online_price_controller.dispose();
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
                                if (widget.product != null) details(),

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
                            if (widget.product != null) details(),

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
              if (!new_product && (auth_staff!.fullaccess))
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
              if (edit &&
                  !new_product &&
                  (widget.page != 'outlet_product') &&
                  (widget.page != 'terminal_product') &&
                  (widget.page != 'dangote_product') &&
                  (auth_staff!.fullaccess))
                InkWell(
                  onTap: () async {
                    bool? response = await UniversalHelpers.showConfirmBox(
                      context,
                      title: 'Delete Product',
                      subtitle:
                          'This would permanently remove this product from the database!\nWould you like to proceed?',
                    );

                    if (response != null && response == true) {
                      bool res = await ProductStoreHelpers.delete_product(
                          context, widget.product!.key!);

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
              new_product
                  ? 'New Product'
                  : edit
                      ? 'Edit Product'
                      : 'Manage Product',
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
              Text('Product Name', style: labelStyle),
              Text(widget.product!.name, style: mainStyle),
            ],
          ),
          Expanded(child: Container()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Quantity', style: labelStyle),
              Text(widget.product!.quantity.toString(), style: mainStyle),
            ],
          ),
        ],
      ),
    );
  }

  Widget formBox() {
    double width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // name && code
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                // name
                Expanded(
                  child: Text_field(
                    controller: name_controller,
                    label: 'Product Name',
                    edit: !edit,
                  ),
                ),

                SizedBox(width: 10),

                // code
                Container(
                  width: 100,
                  child: Text_field(
                    controller: code_controller,
                    label: 'Product Code',
                    edit: !edit,
                  ),
                ),
              ],
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

          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                // store price
                Expanded(
                  child: Container(
                    child: Text_field(
                      label: 'Store price',
                      controller: store_price_controller,
                      edit: !edit,
                      format: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ),

                SizedBox(width: width < 400 ? 30 : 50),

                // online price
                Expanded(
                  child: Text_field(
                    label: 'Online price',
                    controller: online_price_controller,
                    format: [FilteringTextInputFormatter.digitsOnly],
                    edit: !edit,
                  ),
                ),
              ],
            ),
          ),

          // quantity && restock limit
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                // old qty
                Expanded(
                  child: Container(
                    child: Text_field(
                      label:
                          (!new_product && edit) ? 'Old Qunatity' : 'Quantity',
                      controller: old_qty_controller,
                      edit: !edit,
                      format: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ),

                if (!new_product && edit)
                  SizedBox(width: width < 400 ? 30 : 50),

                // new qty
                if (!new_product && edit)
                  Expanded(
                    child: Container(
                      child: Text_field(
                        label: 'New Qunatity',
                        controller: new_qty_controller,
                        edit: !edit,
                        format: [FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                  ),

                SizedBox(width: width < 400 ? 30 : 50),

                // restock limit
                Expanded(
                  child: Text_field(
                    label: 'Restock Limit',
                    controller: restock_limit_controller,
                    format: [FilteringTextInputFormatter.digitsOnly],
                    edit: !edit,
                  ),
                ),
              ],
            ),
          ),

          // isavailable & isonline
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                // isAvailable
                Expanded(
                  child: Select_form(
                    label: 'Available',
                    options: ['Yes', 'No'],
                    text_value: isAvailable ? 'Yes' : 'No',
                    edit: edit,
                    setval: (val) {
                      if (val != null) {
                        isAvailable = val == 'Yes';

                        setState(() {});
                      }
                    },
                  ),
                ),

                SizedBox(width: 50),

                // isOnline
                Expanded(
                  child: Select_form(
                    label: 'Online',
                    options: ['Yes', 'No'],
                    text_value: isOnline ? 'Yes' : 'No',
                    edit: edit,
                    setval: (val) {
                      if (val != null) {
                        isOnline = val == 'Yes';

                        setState(() {});
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          // restock limit
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
              toastText: 'Product name cannot be empty!!',
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

          if (store_price_controller.text.isEmpty) {
            UniversalHelpers.showToast(
              context: context,
              color: Colors.redAccent,
              toastText: 'Enter store price!!',
              icon: Icons.error,
            );
            return;
          }

          // if (online_price_controller.text.isEmpty) {
          //   UniversalHelpers.showToast(
          //     context: context,
          //     color: Colors.redAccent,
          //     toastText: 'Enter online price!!',
          //     icon: Icons.error,
          //   );
          //   return;
          // }

          int quantity = (old_qty_controller.text.isNotEmpty
                  ? int.parse(old_qty_controller.text.trim())
                  : 0) +
              (new_qty_controller.text.isNotEmpty
                  ? int.parse(new_qty_controller.text.trim())
                  : 0);

          int store_price = int.parse(store_price_controller.text.trim());

          int online_price =
              int.tryParse(online_price_controller.text.trim()) ?? 0;

          bool? response = await UniversalHelpers.showConfirmBox(
            context,
            title: 'Save Product',
            subtitle:
                'You are about to save this product!\nWould you like to proceed?',
          );

          if (response != null && response) {
            ProductModel new_product = ProductModel(
              key: widget.product?.key,
              name: name_controller.text.trim(),
              category: category,
              quantity: quantity,
              restockLimit: restock_limit_controller.text.isNotEmpty
                  ? int.parse(restock_limit_controller.text)
                  : 0,
              storePrice: store_price,
              code: code_controller.text.trim().toUpperCase(),
              onlinePrice: online_price,
              isAvailable: isAvailable,
              isOnline: isOnline,
            );

            Map map = new_product.toJson();
            bool done = false;

            if (widget.page == 'product') {
              done = await ProductStoreHelpers.add_update_product(context, map);
            }

            if (widget.page == 'outlet_product') {
              done = await ProductStoreHelpers.add_update_outlet_product(
                  context, map);
            }
            if (widget.page == 'terminal_product') {
              done = await ProductStoreHelpers.add_update_terminal_product(
                  context, map);
            }
            if (widget.page == 'dangote_product') {
              done = await ProductStoreHelpers.add_update_dangote_product(
                  context, map);
            }

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
