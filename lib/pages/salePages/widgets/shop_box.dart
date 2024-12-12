import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/productStoreModels/product.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/productItem.model.dart';
import 'package:delightsome_software/dataModels/saleModels/paymentMethod.model.dart';
import 'package:delightsome_software/dataModels/saleModels/sales.model.dart';
import 'package:delightsome_software/dataModels/saleModels/shop.model.dart';
import 'package:delightsome_software/helpers/saleHelpers.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/pages/salePages/print.page.dart';
import 'package:delightsome_software/pages/salePages/widgets/complete_sale_dialog.dart';
import 'package:delightsome_software/pages/userPages/customer_list.page.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:delightsome_software/widgets/enter_qty_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ShopBox extends StatefulWidget {
  final ShopModel shop;
  final String? active_key;
  final bool outlet_shop;
  const ShopBox({
    super.key,
    required this.shop,
    required this.active_key,
    required this.outlet_shop,
  });

  @override
  State<ShopBox> createState() => _ShopBoxState();
}

class _ShopBoxState extends State<ShopBox> {
  TextEditingController customer_controller = TextEditingController();

  late ShopModel shop = widget.shop;

  @override
  void dispose() {
    customer_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: (width < 800) ? double.infinity : 500,
      margin: (width < 800) ? null : EdgeInsets.symmetric(horizontal: 8),
      height: (width < 800)
          ? double.infinity
          : height > 600
              ? 520
              : height - 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!(width < 800)) top_bar(shop.key),

          // shop content
          if (shop.isExpanded)
            Expanded(
              child: Container(
                margin: !(width < 800) ? EdgeInsets.only(top: 8) : null,
                decoration: BoxDecoration(
                  color: isDarkTheme
                      ? AppColors.dark_dialogBackground_2
                      : AppColors.light_dialogBackground_3,
                  border: Border.all(
                    color: isDarkTheme
                        ? AppColors.dark_primaryBackgroundColor
                        : AppColors.light_dialogBackground_2,
                  ),
                ),
                width: double.infinity,
                child: !shop.done ? main_area() : done_area(),
              ),
            ),
        ],
      ),
    );
  }

  // WIDGETS

  // top bar
  Widget top_bar(String title) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;
    bool is_active = shop.key == widget.active_key;

    int total_price = shop.products.fold(0, (int previousValue, element) {
      int price = (shop.is_online)
          ? element.product.onlinePrice
          : element.product.storePrice;
      return previousValue + (element.quantity * price);
    });

    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 8),
        color: is_active
            ? AppColors.primaryForegroundColor
            : isDarkTheme
                ? AppColors.dark_dimTextColor
                : AppColors.light_dimTextColor,
        child: Stack(
          children: [
            // action buttons
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // close button
                InkWell(
                  onTap: () async {
                    var conf = await UniversalHelpers.showConfirmBox(
                      context,
                      title: 'Delete Ticket',
                      subtitle:
                          'Are you sure you want to delete this ticket? This action cannot be undone.',
                    );

                    if (conf != null && conf) {
                      if (widget.outlet_shop) {
                        Provider.of<AppData>(context, listen: false)
                            .delete_outlet_shop(shop);
                      } else {
                        Provider.of<AppData>(context, listen: false)
                            .delete_terminal_shop(shop);
                      }
                    }
                  },
                  child: Icon(
                    Icons.close,
                    color: AppColors.secondaryWhiteIconColor,
                    size: 22,
                  ),
                ),

                Expanded(child: Container()),

                // shop type
                if (shop.isExpanded && !shop.done && widget.outlet_shop)
                  TextButton(
                    onPressed: () {
                      shop.is_online = !shop.is_online;
                      if (widget.outlet_shop) {
                        Provider.of<AppData>(context, listen: false)
                            .update_outlet_shop(shop);
                      } else {
                        Provider.of<AppData>(context, listen: false)
                            .update_terminal_shop(shop);
                      }
                    },
                    child: Text(
                      shop.is_online ? 'Online' : 'Store',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),

                SizedBox(width: 4),

                // minimize
                InkWell(
                  onTap: () {
                    shop.isExpanded = !shop.isExpanded;
                    if (widget.outlet_shop) {
                      Provider.of<AppData>(context, listen: false)
                          .update_outlet_shop(shop);
                    } else {
                      Provider.of<AppData>(context, listen: false)
                          .update_terminal_shop(shop);
                    }
                  },
                  child: Icon(
                    shop.isExpanded
                        ? Icons.remove
                        : Icons.fullscreen_exit_sharp,
                    color: AppColors.secondaryWhiteIconColor,
                    size: 22,
                  ),
                ),
              ],
            ),

            // title
            if (shop.isExpanded)
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 22),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // ticket Id
                      Row(
                        children: [
                          //  label
                          Text(
                            'Ticket:',
                            style: TextStyle(
                              // color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(width: 6),

                          //  title
                          Text(
                            title,
                            style: TextStyle(
                              // color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      // total price
                      if (!shop.done)
                        Column(
                          children: [
                            Text(
                              'Amount',
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(height: 1),
                            Text(
                              UniversalHelpers.format_number(total_price,
                                  currency: true),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                          ],
                        )

                      // completed
                      else
                        Text(
                          'Completed',
                          style: TextStyle(fontSize: 12),
                        ),

                      // customer
                      if (shop.customer != null && !shop.done)
                        Column(
                          children: [
                            Text(
                              'Customer',
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(height: 1),
                            Text(
                              shop.customer!.nickName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                            ),
                          ],
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

  // main area
  Widget main_area() {
    return Column(
      children: [
        Expanded(child: product_list()),
        bottom_area(),
      ],
    );
  }

  // main area
  Widget done_area() {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    int total_qty = shop.products.fold(0, (int previousValue, element) {
      return previousValue + element.quantity;
    });

    int total_price = shop.products.fold(0, (int previousValue, element) {
      int price = (shop.is_online)
          ? element.product.onlinePrice
          : element.product.storePrice;
      return previousValue + (element.quantity * price);
    });

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 55, color: Colors.green),
                    SizedBox(height: 8),

                    // message
                    Text(
                      'Order Completed Successfully',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),

                    SizedBox(height: 20),

                    // ticket
                    Container(
                      // width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border(
                          top: BorderSide(
                            color: isDarkTheme
                                ? AppColors.dark_dimTextColor
                                : AppColors.light_dimTextColor,
                          ),
                          bottom: BorderSide(
                            color: isDarkTheme
                                ? AppColors.dark_dimTextColor
                                : AppColors.light_dimTextColor,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Ticket ID:',
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(width: 8),
                            Text(
                              shop.key,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // totals
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // total quantity
                        Column(
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(fontSize: 12),
                            ),
                            // SizedBox(height: 2),
                            Text(
                              UniversalHelpers.format_number(total_qty),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        // SizedBox(width: 20),

                        // total price
                        Column(
                          children: [
                            Text(
                              'Amount',
                              style: TextStyle(fontSize: 12),
                            ),
                            // SizedBox(height: 4),
                            Text(
                              UniversalHelpers.format_number(total_price,
                                  currency: true),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // info
                    Container(
                        width: 300,
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: isDarkTheme
                                ? AppColors.dark_dimTextColor
                                : AppColors.light_dimTextColor,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info,
                              color: isDarkTheme
                                  ? AppColors.dark_secondaryTextColor
                                  : AppColors.light_secondaryTextColor,
                              size: 22,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'You can print the reciept or re-order the items in this ticket',
                                // textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isDarkTheme
                                      ? AppColors.dark_secondaryTextColor
                                      : AppColors.light_secondaryTextColor,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        )),

                    SizedBox(height: 30),

                    // print
                    InkWell(
                      onTap: () async {
                        if (shop.printModel == null) {
                          return UniversalHelpers.showToast(
                            context: context,
                            color: Colors.red,
                            toastText: 'Receipt not found',
                            icon: Icons.error,
                          );
                        }

                        return showDialog(
                            context: context,
                            builder: (context) =>
                                PrintPage(print: shop.printModel!));
                      },
                      child: Container(
                        height: 37,
                        width: 180,
                        decoration: BoxDecoration(
                          color: AppColors.orange_1,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.receipt,
                                  color: Colors.white, size: 20),
                              SizedBox(width: 6),
                              Text(
                                'Print Receipt',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    // re order
                    InkWell(
                      onTap: () {
                        shop.key = UniqueKey().toString();
                        shop.done = false;
                        if (widget.outlet_shop) {
                          Provider.of<AppData>(context, listen: false)
                              .update_outlet_shop(shop);
                        } else {
                          Provider.of<AppData>(context, listen: false)
                              .update_terminal_shop(shop);
                        }
                      },
                      child: Container(
                        height: 37,
                        width: 180,
                        decoration: BoxDecoration(
                          // color: Colors.transparent,
                          border: Border.all(
                            color: AppColors.orange_2.withOpacity(.3),
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.receipt, size: 20),
                              SizedBox(width: 6),
                              Text(
                                'Re-order',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    //
                  ],
                ),
              ),
            ),
          ],
        ),

        // clear ticket
        Positioned(
          child: TextButton(
            onPressed: () {
              shop.key = UniqueKey().toString();
              shop.customer = null;
              shop.products = [];
              shop.done = false;
              if (widget.outlet_shop) {
                Provider.of<AppData>(context, listen: false)
                    .update_outlet_shop(shop);
              } else {
                Provider.of<AppData>(context, listen: false)
                    .update_terminal_shop(shop);
              }
            },
            child: Text('Clear ticket'),
          ),
        ),
      ],
    );
  }

  // product list
  Widget product_list() {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

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
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'Product',
                      style: header_style,
                    ),
                  ),
                ),

                // price
                Container(
                  width: 60,
                  alignment: Alignment.center,
                  child: Text(
                    'Price',
                    style: header_style,
                  ),
                ),

                // quantity
                Container(
                  width: 50,
                  child: Center(
                    child: Text(
                      'Qty',
                      style: header_style,
                    ),
                  ),
                ),

                // total price
                Container(
                  width: 72,
                  alignment: Alignment.center,
                  child: Text(
                    'Total',
                    style: header_style,
                  ),
                ),

                // delete all
                Container(
                  width: 40,
                  child: shop.products.isNotEmpty
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

                                if (conf != null && conf) {
                                  shop.products.clear();
                                  if (widget.outlet_shop) {
                                    Provider.of<AppData>(context, listen: false)
                                        .update_outlet_shop(shop);
                                  } else {
                                    Provider.of<AppData>(context, listen: false)
                                        .update_terminal_shop(shop);
                                  }
                                }
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
            child: shop.products.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      children: shop.products.map(
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

    TextStyle qty_style = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );

    int sn = shop.products.indexOf(product) + 1;

    int price = (shop.is_online)
        ? product.product.onlinePrice
        : product.product.storePrice;
    int total_price = price * product.quantity;

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
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                product.product.name,
                style: product_style,
              ),
            ),
          ),

          // price
          Container(
            alignment: Alignment.center,
            width: 60,
            child: Text(
              UniversalHelpers.format_number(price, currency: true),
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // quantity
          Container(
            width: 50,
            child: Center(
              child: InkWell(
                onTap: () async {
                  var res = await showDialog(
                    context: context,
                    builder: (context) =>
                        SearchQtyDialog(name: product.product.name),
                  );

                  if (res != null) {
                    int qty = Provider.of<AppData>(context, listen: false)
                        .product_list
                        .where((element) => element.key == product.product.key)
                        .first
                        .quantity;

                    if (res > qty) {
                      UniversalHelpers.showToast(
                        context: context,
                        color: Colors.redAccent,
                        toastText: 'Insufficient quantity',
                        icon: Icons.error,
                      );
                      return;
                    }

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
                  width: 35,
                  height: 25,
                  child: Center(
                    child: Text(
                      UniversalHelpers.format_number(product.quantity),
                      style: qty_style,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // total price
          Container(
            width: 72,
            alignment: Alignment.center,
            child: Text(
              UniversalHelpers.format_number(total_price, currency: true),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // delete
          InkWell(
            onTap: () {
              shop.products.remove(product);
              if (widget.outlet_shop) {
                Provider.of<AppData>(context, listen: false)
                    .update_outlet_shop(shop);
              } else {
                Provider.of<AppData>(context, listen: false)
                    .update_terminal_shop(shop);
              }
              setState(() {});
            },
            child: Container(
              width: 40,
              height: 40,
              child: Center(
                child: Icon(
                  Icons.cancel,
                  color: Colors.redAccent,
                  size: 16,
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

    int total_qty = shop.products.fold(0, (int previousValue, element) {
      return previousValue + element.quantity;
    });

    int total_price = shop.products.fold(0, (int previousValue, element) {
      int price = (shop.is_online)
          ? element.product.onlinePrice
          : element.product.storePrice;
      return previousValue + (element.quantity * price);
    });

    return Container(
      width: double.infinity,
      padding: (width > 800)
          ? EdgeInsets.symmetric(horizontal: 20, vertical: 8)
          : null,
      child: Column(
        children: [
          // details row
          Container(
            padding:
                (width < 800) ? EdgeInsets.symmetric(horizontal: 12) : null,
            child: Row(
              children: [
                if (!(width < 800)) SizedBox(width: 10),
                // total quantity
                Row(
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(width: 6),
                    Text(
                      UniversalHelpers.format_number(total_qty),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                SizedBox(width: (width < 800) ? 10 : 20),

                // total price
                Row(
                  children: [
                    Text(
                      'Amount:',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(width: 6),
                    Text(
                      UniversalHelpers.format_number(total_price,
                          currency: true),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                Expanded(child: Container()),

                SizedBox(width: (width < 800) ? 10 : 20),

                customer_box(),
              ],
            ),
          ),

          SizedBox(height: 10),

          // submit area
          Row(
            children: [
              // submit button
              Expanded(
                child: InkWell(
                  onTap: () async {
                    if (shop.products.isEmpty) {
                      UniversalHelpers.showToast(
                        context: context,
                        color: Colors.red,
                        toastText: 'No Products',
                        icon: Icons.error,
                      );
                      return;
                    }

                    bool product_chk = await check_products_qty();

                    if (!product_chk) {
                      return;
                    }

                    var response = await showDialog(
                      context: context,
                      builder: (context) => CompleteSaleDialog(
                        total: total_qty,
                        amount: total_price,
                        is_online: shop.is_online,
                      ),
                    );

                    if (response != null) {
                      List<PaymentMethodModel> split_payment =
                          (response['split_payment'] as List)
                              .map(
                                (e) => PaymentMethodModel(
                                  paymentMethod: e['paymentMethod'],
                                  amount: e['amount'],
                                ),
                              )
                              .toList();

                      List<ProductItemModel> final_products =
                          shop.products.map((prod) {
                        return ProductItemModel(
                          product: prod.product,
                          quantity: prod.quantity,
                          price: (shop.is_online)
                              ? prod.product.onlinePrice
                              : prod.product.storePrice,
                        );
                      }).toList();

                      SalesModel sale = SalesModel(
                        products: final_products,
                        orderPrice: total_price,
                        paymentMethod: response['payment_method'],
                        customer: shop.customer,
                        shortNote: response['note'],
                        splitPaymentMethod: split_payment,
                        discountPrice: response['final_amount'],
                        saleType: shop.is_online ? 'online' : 'store',
                        recordDate: response['date'] != null
                            ? response['date']
                            : DateTime.now(),
                      );

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

                      Map data = sale.toJson(soldBy: auth_staff.key ?? '');

                      if (widget.outlet_shop) {
                        var shop_data =
                            await SaleHelpers.enter_new_sale(context, data);
                        shop.done = shop_data[0];
                        shop.orderId = shop_data[1];
                      } else {
                        var shop_data =
                            await SaleHelpers.enter_new_terminal_sale(
                                context, data);

                        shop.done = shop_data[0];
                        shop.orderId = shop_data[1];
                      }

                      if (shop.done) {
                        bool is_discounted = (sale.discountPrice != null &&
                            sale.discountPrice != sale.orderPrice);

                        List<PrintItemModel> items = final_products
                            .map((e) => PrintItemModel(
                                name: e.product.name,
                                qty: e.quantity,
                                price: e.price,
                                total_price: (e.price * e.quantity)))
                            .toList();

                        List<PaymentMethodModel> pmts =
                            (sale.splitPaymentMethod != null &&
                                    sale.splitPaymentMethod!.isNotEmpty)
                                ? sale.splitPaymentMethod ?? []
                                : [
                                    PaymentMethodModel(
                                      paymentMethod: sale.paymentMethod,
                                      amount: (is_discounted
                                          ? sale.discountPrice ?? 0
                                          : sale.orderPrice),
                                    ),
                                  ];

                        shop.printModel = PrintModel(
                          date: DateFormat('dd/MM/yyyy')
                              .format(sale.recordDate ?? DateTime.now()),
                          time: DateFormat.jm()
                              .format(sale.recordDate ?? DateTime.now()),
                          receipt_id: shop.orderId ?? 'null',
                          store: (widget.outlet_shop)
                              ? shop.is_online
                                  ? 'Online'
                                  : 'Outlet'
                              : 'Terminal',
                          seller: auth_staff.nickName,
                          customer: shop.customer?.nickName ?? 'Walk-in',
                          items: items,
                          sub_total: sale.orderPrice,
                          discount: (is_discounted
                              ? sale.orderPrice - (sale.discountPrice ?? 0)
                              : 0),
                          total: (is_discounted
                              ? sale.discountPrice ?? 0
                              : sale.orderPrice),
                          pmts: pmts,
                        );
                      } else {
                        shop.printModel = null;
                      }

                      if (widget.outlet_shop) {
                        Provider.of<AppData>(context, listen: false)
                            .update_outlet_shop(shop);
                      } else {
                        Provider.of<AppData>(context, listen: false)
                            .update_terminal_shop(shop);
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

          if (!(width < 800)) SizedBox(height: 5),
        ],
      ),
    );
  }

  // customer
  Widget customer_box() {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;
    double width = MediaQuery.of(context).size.width;

    customer_controller.text = shop.customer?.nickName ?? '';

    return Container(
      width: (width < 800) ? 150 : 180,
      padding: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: isDarkTheme
              ? AppColors.dark_secondaryTextColor
              : AppColors.light_secondaryTextColor,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      height: 30,
      child: Center(
        child: Row(
          children: [
            InkWell(
              onTap: () {
                select_customer();
              },
              child: Icon(
                Icons.person,
                color: isDarkTheme
                    ? AppColors.dark_secondaryTextColor
                    : AppColors.light_secondaryTextColor,
                size: 22,
              ),
            ),

            SizedBox(width: 2),

            // search field
            Expanded(
              child: TextField(
                controller: customer_controller,
                style: TextStyle(
                  color: isDarkTheme
                      ? AppColors.dark_primaryTextColor
                      : AppColors.light_primaryTextColor,
                  fontSize: 15,
                ),
                readOnly: true,
                onTap: () {
                  select_customer();
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(2, 0, 2, 1),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  isDense: true,
                  hintText: 'Customer',
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

            if (customer_controller.text.isNotEmpty)
              InkWell(
                onTap: () {
                  shop.customer = null;
                  customer_controller.clear();
                  setState(() {});
                  if (widget.outlet_shop) {
                    Provider.of<AppData>(context, listen: false)
                        .update_outlet_shop(shop);
                  } else {
                    Provider.of<AppData>(context, listen: false)
                        .update_terminal_shop(shop);
                  }
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

  //
  // FUNCTIONS

  // select customer
  void select_customer() async {
    var cus = await showDialog(
      context: context,
      builder: (context) => CustomerListPage(
          selector: true,
          initial_index: widget.outlet_shop
              ? shop.is_online
                  ? 1
                  : 0
              : 2),
    );

    if (cus != null) {
      shop.customer = cus;
      if (widget.outlet_shop) {
        Provider.of<AppData>(context, listen: false).update_outlet_shop(shop);
      } else {
        Provider.of<AppData>(context, listen: false).update_terminal_shop(shop);
      }
    }
  }

  bool check_products_qty() {
    List<ProductModel> prods = [];

    if (widget.outlet_shop) {
      prods = Provider.of<AppData>(context, listen: false).product_list;
    } else {
      prods =
          Provider.of<AppData>(context, listen: false).terminal_product_list;
    }

    for (var i = 0; i < shop.products.length; i++) {
      ProductItemModel p = shop.products[i];

      var chk = prods.where((prod) => prod.key == p.product.key);

      if (chk.isNotEmpty) {
        ProductModel a_p = chk.first;

        if (a_p.quantity < p.quantity) {
          UniversalHelpers.showToast(
            context: context,
            color: Colors.red,
            toastText: 'Insufficient ${p.product.name}',
            icon: Icons.error,
          );
          return false;
        }
      } else {
        UniversalHelpers.showToast(
          context: context,
          color: Colors.red,
          toastText: 'Invalid Products fround',
          icon: Icons.error,
        );
        return false;
      }
    }

    return true;
  }
  
  //
}
