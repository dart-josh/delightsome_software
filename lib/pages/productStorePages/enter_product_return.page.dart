import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/productStoreModels/product.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/productItem.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/productReturnRecord.model.dart';
import 'package:delightsome_software/dataModels/userModels/staff.model.dart';
import 'package:delightsome_software/globalvariables.dart';
import 'package:delightsome_software/helpers/productStoreHelpers.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/pages/productStorePages/widgets/product_selector.dart';
import 'package:delightsome_software/pages/universalPages/select_staff_dialog.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:delightsome_software/widgets/enter_qty_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnterProductReturnPage extends StatefulWidget {
  final ProductReturnRecordModel? editModel;
  const EnterProductReturnPage({super.key, this.editModel});

  @override
  State<EnterProductReturnPage> createState() => _EnterProductReturnPageState();
}

class _EnterProductReturnPageState extends State<EnterProductReturnPage> {
  TextEditingController search_controller = TextEditingController();
  FocusNode searchNode = FocusNode();

  int total_qty = 0;

  bool small_screen = false;

  List<ProductModel> products = [];

  List<ProductItemModel> selected_products = [];

  List<ProductModel> search_products = [];
  bool search_on = false;

  bool search_open = false;

  StaffModel? staff;
  String? shortNote;

  get_products() {
    products = Provider.of<AppData>(context).product_list;
  }

  void get_edit_values() {
    if (widget.editModel != null) {
      selected_products = widget.editModel!.products;
      staff = widget.editModel!.returnedBy;
      shortNote = widget.editModel!.shortNote;
    }
  }

  @override
  void initState() {
    get_edit_values();
    super.initState();
  }

  @override
  void dispose() {
    search_controller.dispose();
    searchNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    get_products();

    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;
    double width = MediaQuery.of(context).size.width;

    if (width > 600) {
      small_screen = false;
    } else {
      small_screen = true;
    }

    // dialog (big screen)
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
                      // product selection
                      selection(),

                      Expanded(
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                // list
                                Expanded(child: product_list()),

                                // bottom area
                                bottom_area(),
                              ],
                            ),

                            // search list
                            if (search_on)
                              Positioned.fill(
                                child: Stack(
                                  children: [
                                    // Back cover
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          search_on = false;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(.8),
                                        ),
                                      ),
                                    ),

                                    // list
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      // left: 0,
                                      child: Container(
                                        height: 250,
                                        width: 255,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 0),
                                        decoration: BoxDecoration(
                                          color: isDarkTheme
                                              ? AppColors
                                                  .dark_dialogBackground_1
                                              : AppColors
                                                  .light_dialogBackground_1,
                                        ),
                                        child: search_products.isNotEmpty
                                            ? SingleChildScrollView(
                                                child: Column(
                                                  children: search_products
                                                      .map(
                                                          (e) => search_tile(e))
                                                      .toList(),
                                                ),
                                              )
                                            : Center(
                                                child:
                                                    Text('No Product Found !!'),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // scaffold (small screen)
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
              // padding: EdgeInsets.only(bottom: 10),
              width: double.infinity,
              child: Column(
                children: [
                  // product selection
                  selection(),

                  Expanded(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            // list
                            Expanded(child: product_list()),

                            // bottom area
                            bottom_area(),
                          ],
                        ),

                        // search list
                        if (search_on)
                          Positioned.fill(
                            child: Stack(
                              children: [
                                // back cover
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      search_on = false;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(.8),
                                    ),
                                  ),
                                ),

                                // list
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  left: 0,
                                  child: Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: isDarkTheme
                                          ? AppColors
                                              .dark_primaryBackgroundColor
                                          : AppColors.light_dialogBackground_3,
                                    ),
                                    child: search_products.isNotEmpty
                                        ? SingleChildScrollView(
                                            child: Column(
                                              children: search_products
                                                  .map((e) => search_tile(e))
                                                  .toList(),
                                            ),
                                          )
                                        : Center(
                                            child: Text('No Product Found !!'),
                                          ),
                                  ),
                                ),

                                //
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
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
    double width = MediaQuery.of(context).size.width;

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
                  // save model
                  if (selected_products.isNotEmpty) {
                    var prrm = ProductReturnRecordModel(
                      products: selected_products,
                      shortNote: shortNote,
                      returnedBy: staff,
                    );

                    if (widget.editModel?.key == null) {
                      saved_product_return_model = prrm;
                    }
                  } else {
                    saved_product_return_model = null;
                  }

                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: AppColors.secondaryWhiteIconColor,
                  size: 22,
                ),
              ),

              Expanded(child: Container()),

              // search button
              if (!(width > 600))
                InkWell(
                  onTap: () {
                    search_open = !search_open;

                    if (!search_open) {
                      search_controller.clear();
                      search_on = false;
                      search_products.clear();
                    } else {
                      Future.delayed(Duration(milliseconds: 300), () {
                        FocusScope.of(context).requestFocus(searchNode);
                      });
                    }

                    setState(() {});
                  },
                  child: Container(
                    // height: 35,
                    child: Center(
                      child: Icon(
                        search_open ? Icons.close : Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

              SizedBox(width: 10),
            ],
          ),

          // title
          Center(
            child: Text(
              'Enter Return Product',
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

  // product selection
  Widget selection() {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Row(
        children: [
          // selector
          if (!search_open || (width > 600))
            InkWell(
              onTap: () async {
                ProductModel? product = await showDialog(
                  context: context,
                  builder: (context) => ProductSelector(products: products),
                );

                if (product != null) {
                  add_product(product);
                }
              },
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                  color: AppColors.orange_1,
                  borderRadius: BorderRadius.circular(3),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  children: [
                    Icon(Icons.select_all, color: Colors.white),
                    SizedBox(width: 5),
                    Text('Select Product',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),

          if (!search_open) SizedBox(width: 10),

          if (width > 600) Expanded(child: Container()),

          // search bar
          if (width > 600)
            search_bar()
          else if (search_open)
            Expanded(child: search_bar()),
        ],
      ),
    );
  }

  // search bar
  Widget search_bar() {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: (width > 600) ? 250 : double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: isDarkTheme
              ? AppColors.dark_dimTextColor
              : AppColors.light_dimTextColor,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      height: 35,
      child: Center(
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: isDarkTheme
                  ? AppColors.dark_dimTextColor
                  : AppColors.light_dimTextColor,
              size: 22,
            ),

            SizedBox(width: 5),

            // search field
            Expanded(
              child: TextField(
                controller: search_controller,
                focusNode: searchNode,
                style: TextStyle(
                  color: isDarkTheme
                      ? AppColors.dark_primaryTextColor
                      : AppColors.light_primaryTextColor,
                ),
                onChanged: search,
                onTap: () {
                  if (search_products.isNotEmpty) {
                    setState(() {
                      search_on = true;
                    });
                  }
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(2, 0, 2, 3.8),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  isDense: true,
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkTheme
                        ? AppColors.dark_dimTextColor
                        : AppColors.light_dimTextColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),

            if (search_controller.text.isNotEmpty)
              InkWell(
                onTap: () {
                  search_controller.clear();
                  search_products.clear();
                  search_on = false;
                  setState(() {});
                },
                child: Icon(
                  Icons.clear,
                  color: isDarkTheme
                      ? AppColors.dark_secondaryTextColor
                      : AppColors.light_secondaryTextColor,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // search tile
  Widget search_tile(ProductModel product) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;
    double width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () async {
        if (product.isAvailable) add_product(product);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDarkTheme
                  ? AppColors.dark_dimTextColor
                  : AppColors.light_dimTextColor,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            if (!(width > 600)) SizedBox(width: 5),
            Expanded(
              child: Text(
                product.name,
                style: TextStyle(
                  fontSize: 16,
                  color: !product.isAvailable
                      ? isDarkTheme
                          ? AppColors.dark_dimTextColor
                          : AppColors.light_dimTextColor
                      : isDarkTheme
                          ? AppColors.dark_primaryTextColor
                          : AppColors.light_primaryTextColor,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              UniversalHelpers.format_number(product.quantity),
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: !product.isAvailable
                    ? isDarkTheme
                        ? AppColors.dark_dimTextColor
                        : AppColors.light_dimTextColor
                    : isDarkTheme
                        ? AppColors.dark_primaryTextColor
                        : AppColors.light_primaryTextColor,
              ),
            ),
            if (!(width > 600)) SizedBox(width: 10) else SizedBox(width: 5),
          ],
        ),
      ),
    );
  }

  // product list
  Widget product_list() {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    total_qty = 0;

    TextStyle header_style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );

    TextStyle product_style = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 15,
    );

    return Container(
      child: Column(
        children: [
          SizedBox(height: 2),

          // header
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDarkTheme
                      ? AppColors.dark_dimTextColor
                      : AppColors.light_dimTextColor,
                ),
                top: BorderSide(
                  color: isDarkTheme
                      ? AppColors.dark_dimTextColor
                      : AppColors.light_dimTextColor,
                ),
              ),
            ),
            child: Row(
              children: [
                // s/n
                Container(
                  width: 40,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: isDarkTheme
                            ? AppColors.dark_dimTextColor
                            : AppColors.light_dimTextColor,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                    child: Text(
                      'S/N',
                      style: product_style,
                    ),
                  ),
                ),

                // name
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Product',
                      style: header_style,
                    ),
                  ),
                ),

                // quantity
                Container(
                  width: small_screen ? 80 : 120,
                  child: Center(
                    child: Text(
                      'Quantity',
                      style: header_style,
                    ),
                  ),
                ),

                // delete all
                Container(
                  width: 50,
                  child: selected_products.isNotEmpty
                      ? Center(
                          child: InkWell(
                              onTap: () async {
                                var conf =
                                    await UniversalHelpers.showConfirmBox(
                                  context,
                                  title: 'Remove all',
                                  subtitle:
                                      'You are about to remove all products from this list.',
                                );

                                if (conf != null && conf)
                                  setState(() {
                                    selected_products.clear();
                                  });
                              },
                              child: Icon(Icons.clear_all,
                                  size: 22, color: Colors.red)),
                        )
                      : null,
                ),
              ],
            ),
          ),

          // list
          Expanded(
            child: selected_products.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      children: selected_products.map(
                        (e) {
                          return selected_products_tile(e);
                        },
                      ).toList(),
                    ),
                  )
                : Center(
                    child: Text('No Products Selected !!', style: header_style),
                  ),
          ),
        ],
      ),
    );
  }

  // selected Products tile
  Widget selected_products_tile(ProductItemModel product) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    TextStyle product_style = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 15,
    );

    int sn = selected_products.indexOf(product) + 1;
    total_qty += product.quantity;

    return Container(
      decoration: BoxDecoration(
        color: sn.isEven
            ? Color.fromARGB(89, 123, 117, 117)
            : Color.fromARGB(90, 211, 202, 202),
      ),
      child: Row(
        children: [
          // s/n
          Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: isDarkTheme
                      ? AppColors.dark_dimTextColor
                      : AppColors.light_dimTextColor,
                ),
              ),
            ),
            width: 40,
            height: 40,
            child: Center(
              child: Text(
                sn.toString(),
                style: product_style,
              ),
            ),
          ),

          // name
          Expanded(
            flex: 6,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                product.product.name,
                style: product_style,
              ),
            ),
          ),

          // quantity
          Container(
            width: small_screen ? 80 : 120,
            child: Center(
              child: InkWell(
                onTap: () async {
                  var res = await showDialog(
                    context: context,
                    builder: (context) =>
                        SearchQtyDialog(name: product.product.name),
                  );

                  if (res != null) {
                    product.quantity = res;

                    setState(() {});
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDarkTheme
                          ? AppColors.dark_dimTextColor
                          : AppColors.light_dimTextColor,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  width: 55,
                  height: 30,
                  // padding: EdgeInsets.all(6),
                  child: Center(
                    child: Text(
                      UniversalHelpers.format_number(product.quantity),
                      style: product_style,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // delete
          InkWell(
            onTap: () {
              selected_products.remove(product);
              setState(() {});
            },
            child: Container(
              width: 50,
              height: 40,
              child: Center(
                child: Icon(
                  Icons.cancel,
                  color: Colors.redAccent,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // bottom area
  Widget bottom_area() {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: (width > 600)
          ? EdgeInsets.symmetric(horizontal: 20, vertical: 15)
          : null,
      child: Column(
        children: [
          // total quantity
          Row(
            children: [
              SizedBox(width: 10),
              Text(
                'Total:',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(width: 8),
              Text(
                UniversalHelpers.format_number(total_qty),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),

          // submit area
          Row(
            children: [
              // submit button
              Expanded(
                child: InkWell(
                  onTap: () async {
                    if (selected_products.isEmpty) {
                      UniversalHelpers.showToast(
                        context: context,
                        color: Colors.red,
                        toastText: 'No Products Selected',
                        icon: Icons.error,
                      );
                      return;
                    }

                    var res = await showDialog(
                      context: context,
                      builder: (context) => SelectStaffDialog(
                        staff_label: 'Returned By',
                        note_label: 'Short note',
                        staff: staff,
                        note: shortNote,
                        date: widget.editModel?.recordDate,
                        staff_list_type: 'Production, Sales, Terminal, Dangote, Admin, Management',
                      ),
                    );

                    if (res != null) {
                      staff = res[0];
                      shortNote = res[1];
                      DateTime dt = res[2] ?? DateTime.now();

                      var prrm = ProductReturnRecordModel(
                        key: widget.editModel?.key,
                        products: selected_products,
                        shortNote: shortNote,
                        returnedBy: staff,
                        recordDate: dt,
                      );

                      if (widget.editModel?.key == null) {
                        var prrm_s = ProductReturnRecordModel(
                          products: selected_products,
                          shortNote: shortNote,
                          returnedBy: staff,
                        );
                        saved_product_return_model = prrm_s;
                      }

                      var auth_staff =
                          Provider.of<AppData>(context, listen: false)
                              .active_staff;

                      if (auth_staff == null) {
                        return UniversalHelpers.showToast(
                          context: context,
                          color: Colors.red,
                          toastText: 'Invalid Authentication',
                          icon: Icons.error,
                        );
                      }

                      Map map = prrm.enter_toJson(
                          returnedBy: staff!.key!,
                          editedBy: auth_staff.key ?? '');

                      bool done =
                          await ProductStoreHelpers.enter_product_return_record(
                              context, map, widget.editModel?.recordId);

                      if (widget.editModel?.key != null) {
                        Navigator.pop(context);
                      } else if (done) {
                        saved_product_return_model = null;
                        selected_products.clear();
                        shortNote = null;
                        staff = null;
                        setState(() {});
                      }
                    }
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.orange_1,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // FUNCTIONS
  // search products
  void search(String value) {
    if (value.isNotEmpty) {
      search_on = true;
      search_products = products
          .where((product) =>
              product.name.toLowerCase().contains(value.toLowerCase()) ||
              product.code.toLowerCase().contains(value.toLowerCase()) ||
              product.category.toLowerCase().contains(value.toLowerCase()))
          .toList();
    } else {
      search_on = false;
      search_products.clear();
    }

    setState(() {});
  }

  // add product to selected product
  Future<void> add_product(ProductModel product) async {
    var chk = selected_products.where((e) => e.product.key == product.key);

    if (chk.isEmpty) {
      var res = await showDialog(
        context: context,
        builder: (context) => SearchQtyDialog(name: product.name),
      );

      if (res != null) {
        selected_products.add(
          ProductItemModel(product: product, quantity: res),
        );
        search_on = false;
        setState(() {});
      }
    } else {
      UniversalHelpers.showToast(
        context: context,
        color: Colors.red,
        toastText: 'Product added already',
        icon: Icons.error,
      );
    }
  }

  //
}
