import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/productStoreModels/product.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/productItem.model.dart';
import 'package:delightsome_software/dataModels/saleModels/shop.model.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/pages/productStorePages/widgets/product_selector.dart';
import 'package:delightsome_software/pages/salePages/terminal_sales_record.page.dart';
import 'package:delightsome_software/pages/salePages/widgets/shop_box.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:delightsome_software/widgets/enter_qty_dialog.dart';
import 'package:flutter/material.dart';
import 'package:indexed/indexed.dart';
import 'package:provider/provider.dart';

class TerminalSalesPage extends StatefulWidget {
  const TerminalSalesPage({super.key});

  @override
  State<TerminalSalesPage> createState() => Terminal_SalesPageState();
}

class Terminal_SalesPageState extends State<TerminalSalesPage> {
  TextEditingController search_controller = TextEditingController();
  FocusNode searchNode = FocusNode();

  List<ProductModel> products = [];

  List<ProductModel> search_products = [];
  bool search_on = false;

  bool search_open = false;

  List<ShopModel> shops = [];
  ShopModel? active_shop;

  get_products() {
    products = Provider.of<AppData>(context).terminal_product_list;
    shops = Provider.of<AppData>(context).terminal_shops;
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    double width = MediaQuery.of(context).size.width;

    get_products();

    if (active_shop != null && (!active_shop!.isExpanded || active_shop!.done))
      active_shop = null;

    if (active_shop != null &&
        shops.where((e) => e.key == active_shop!.key).isEmpty)
      active_shop = null;

    if (width < 800) if (active_shop == null) if (shops.isNotEmpty)
      active_shop = shops[0];

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: (width < 800) ? null : add_button(),
      backgroundColor: isDarkTheme
          ? AppColors.dark_primaryBackgroundColor
          : AppColors.light_dialogBackground_2,
      body: Column(
        children: [
          // top bar
          top_bar(),

          // product selector
          selection(),

          // content
          Expanded(
            child: Stack(
              children: [
                // shop
                shop_area(),

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
                          left: (width > 600) ? null : 0,
                          child: Container(
                            height: (width > 600) ? 300 : 200,
                            width: (width > 600) ? 350 : double.infinity,
                            margin: (width > 600)
                                ? EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0)
                                : null,
                            decoration: BoxDecoration(
                              color: isDarkTheme
                                  ? AppColors.dark_primaryBackgroundColor
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
    );
  }

  // WIDGETS

  // top bar
  Widget top_bar({String? title}) {
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
              if (!(width > 600) && active_shop != null  && !active_shop!.done)
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

              IconButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TerminalSalesRecordPage()));
                },
                icon: Icon(
                  Icons.list,
                  color: Colors.white,
                ),
              ),

              SizedBox(width: 10),
            ],
          ),

          // title
          Center(
            child: Text(
              'Terminal Sales Page',
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
      height: 50,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          // selector
          if ((!search_open || (width > 600)) && active_shop != null && !active_shop!.done)
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
          if (active_shop != null && !active_shop!.done)
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
      width: (width > 600)
          ? (width < 800)
              ? 290
              : 350
          : double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: isDarkTheme
              ? AppColors.dark_secondaryTextColor
              : AppColors.light_secondaryTextColor,
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
                  ? AppColors.dark_secondaryTextColor
                  : AppColors.light_secondaryTextColor,
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
                        ? AppColors.dark_secondaryTextColor
                        : AppColors.light_secondaryTextColor,
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

            // price
            SizedBox(width: 10),
            Text(
              UniversalHelpers.format_number(product.storePrice,
                  currency: true),
              style: TextStyle(
                fontSize: 14,
                color: !product.isAvailable
                    ? isDarkTheme
                        ? AppColors.dark_dimTextColor
                        : AppColors.light_dimTextColor
                    : isDarkTheme
                        ? AppColors.dark_primaryTextColor
                        : AppColors.light_primaryTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(width: 15),

            // quantity
            Text(
              '(${UniversalHelpers.format_number(product.quantity)})',
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

  // shop box
  Widget shop_area() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (width < 800) {
      if (active_shop == null) if (shops.isNotEmpty)
        null;
      else
        return Center(
          child: add_button(),
        );

      active_shop!.isExpanded = true;
      return ShopBox(
        shop: active_shop!,
        active_key: active_shop?.key,
        shop_type: 'terminal',
      );
    }

    return Indexer(
      children: shops.map((shop) {
        Widget child = GestureDetector(
          onTap: () {
            if (!shop.isExpanded) shop.isExpanded = true;
            if (!shop.done) active_shop = shop;
            Provider.of<AppData>(context, listen: false)
                .update_terminal_shop(shop);
          },
          child: ShopBox(
            shop: shop,
            active_key: active_shop?.key,
            shop_type: 'terminal',
          ),
        );

        return Indexed(
          index: (active_shop != null && active_shop!.key == shop.key)
              ? shops.length
              : shops.indexOf(shop),
          key: Key('${shops.indexOf(shop)}-${shop.key}'),
          child: Positioned(
            left: shop.position.dx,
            top: shop.position.dy,
            child: Draggable(
              maxSimultaneousDrags: 1,
              feedback: Dialog(
                child: child,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              childWhenDragging: Opacity(
                opacity: 0,
                child: child,
              ),
              dragAnchorStrategy: (d, context, position) {
                return childDragAnchorStrategy(
                    d, context, Offset(position.dx + 40, position.dy + 23));
              },
              onDragEnd: (details) {
                double x_end = width - 520;
                double y_end = height -
                    ((!shop.isExpanded)
                        ? 60
                        : (height > 400 ? 540 : height - 100));

                double dx = (details.offset.dx < 0)
                    ? 10
                    : (details.offset.dx > x_end)
                        ? x_end
                        : details.offset.dx + 40;

                double dy = ((details.offset.dy < 100)
                    ? 10
                    : (details.offset.dy > y_end)
                        ? (y_end - 90)
                        : details.offset.dy - 66);

                Offset offset = Offset(dx, dy);
                shop.position = offset;
                Provider.of<AppData>(context, listen: false)
                    .update_terminal_shop(shop);
              },
              child: child,
            ),
          ),
        );
      }).toList(),
    );
  }

  // add shop
  Widget add_button() {
    double width = MediaQuery.of(context).size.width;
    return IconButton(
      onPressed: () {
        if (shops.length >= 8 && width >= 800) {
          UniversalHelpers.showToast(
            context: context,
            color: Colors.red,
            toastText: 'Max number of ticket reached',
            icon: Icons.error,
          );
          return;
        }

        ShopModel new_shop = ShopModel(
          key: UniqueKey().toString(),
          customer: null,
          products: [],
          position: set_offset(),
        );

        Provider.of<AppData>(context, listen: false)
            .new_terminal_shop(new_shop);
        active_shop = new_shop;
        setState(() {});
      },
      icon: Icon(Icons.add, size: 40),
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
    if (active_shop == null) {
      UniversalHelpers.showToast(
        context: context,
        color: Colors.red,
        toastText: 'Please select shop',
        icon: Icons.error,
      );
      return;
    }

    var chk = active_shop!.products.where((e) => e.product.key == product.key);

    if (chk.isEmpty) {
      var res = await showDialog(
        context: context,
        builder: (context) => SearchQtyDialog(name: product.name),
      );

      if (res != null) {
        if (res > product.quantity) {
          UniversalHelpers.showToast(
            context: context,
            color: Colors.redAccent,
            toastText: 'Insufficient quantity',
            icon: Icons.error,
          );
          return;
        }

        active_shop!.products.add(
          ProductItemModel(product: product, quantity: res, price: active_shop!.is_online ? product.onlinePrice : product.storePrice,),
        );

        Provider.of<AppData>(context, listen: false)
            .update_terminal_shop(active_shop!);
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

  // set offset
  Offset set_offset() {
    if (shops.isEmpty)
      return Offset(100, 20);
    else {
      if (shops
          .where((e) => e.position.dx == 100 || e.position.dy == 20)
          .isNotEmpty) {
        return Offset(140, 70);
      } else {
        return Offset(100, 20);
      }
    }
  }

  //
}
