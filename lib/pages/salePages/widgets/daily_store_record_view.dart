import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/saleModels/dailystore.model.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:provider/provider.dart';

class DailyStoreRecordView extends StatefulWidget {
  final List<DailyStoreProductsModel> record;
  const DailyStoreRecordView({super.key, required this.record});

  @override
  State<DailyStoreRecordView> createState() => _DailyStoreRecordViewState();
}

class _DailyStoreRecordViewState extends State<DailyStoreRecordView> {
  late LinkedScrollControllerGroup _horizontalControllersGroup;
  late ScrollController _horizontalController1;
  late ScrollController _horizontalController2;

  late LinkedScrollControllerGroup _verticalControllersGroup;
  late ScrollController _verticalController1;
  late ScrollController _verticalController2;

  @override
  void initState() {
    super.initState();
    _horizontalControllersGroup = LinkedScrollControllerGroup();
    _horizontalController1 = _horizontalControllersGroup.addAndGet();
    _horizontalController2 = _horizontalControllersGroup.addAndGet();

    _verticalControllersGroup = LinkedScrollControllerGroup();
    _verticalController1 = _verticalControllersGroup.addAndGet();
    _verticalController2 = _verticalControllersGroup.addAndGet();
  }

  @override
  void dispose() {
    _horizontalController1.dispose();
    _horizontalController2.dispose();
    _verticalController1.dispose();
    _verticalController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    widget.record.sort((a, b) =>
        ("${get_sort(a.product.category)}${a.product.name.toLowerCase()}")
            .toString()
            .compareTo(
                ("${get_sort(b.product.category)}${b.product.name.toLowerCase()}")
                    .toString()));

    int total_store_amount =
        widget.record.fold(0, (int previousValue, element) {
      return previousValue +
          ((element.storePrice != 0
                  ? element.storePrice
                  : element.product.storePrice) *
              element.quantitySold);
    });

    int total_online_amount =
        widget.record.fold(0, (int previousValue, element) {
      return previousValue + (element.product.onlinePrice * element.online);
    });

    return Container(
      child: widget.record.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: selected_page(widget.record),
                ),

                // totals
                Container(
                  width: double.infinity,
                  height: 40,
                  margin: EdgeInsets.only(top: 10, bottom: 3),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: isDarkTheme
                          ? AppColors.dark_dimTextColor
                          : AppColors.light_dimTextColor,
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // total store amount
                        totals_tile(
                            label: 'Total Store Sales',
                            value: total_store_amount),

                        SizedBox(width: 100),

                        // total online amount
                        totals_tile(
                            label: 'Total Online Sales',
                            value: total_online_amount),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: Text('No Record to Display !!'),
            ),
    );
  }

  // WIDGETS
  // selected page
  Widget selected_page(List<DailyStoreProductsModel> _record) {
    return Column(
      children: [
        product_head(),
        Expanded(child: product_list(_record)),
      ],
    );
  }

  // product head
  Widget product_head() {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;
    double width = MediaQuery.of(context).size.width;
    double space_left = width - 1380;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDarkTheme
                ? AppColors.dark_dimTextColor
                : AppColors.light_dimTextColor,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // s/n
          _head_tile(
            value: 'S/N',
            width: 40,
          ),

          // product
          _head_tile(
            value: 'Product',
            width: space_left < 200 ? 200 : space_left,
            center: false,
          ),

          // product details
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _horizontalController2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // opening quantity
                  _head_tile(value: 'Opening'),

                  // added
                  _head_tile(value: 'Added'),

                  // total
                  _head_tile(value: 'Total'),

                  // request
                  _head_tile(value: 'Request'),

                  // product supply
                  Container(
                    width: 140,
                    decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                        color: isDarkTheme
                            ? AppColors.dark_dimTextColor
                            : AppColors.light_dimTextColor,
                      )),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 2),

                        // head
                        Text(
                          'Supply',
                          style: TextStyle(
                            height: 1,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 3),

                        // bottom
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // taken out
                            Container(
                              width: 70,
                              padding: EdgeInsets.only(bottom: 3),
                              decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                  color: isDarkTheme
                                      ? AppColors.dark_dimTextColor
                                      : AppColors.light_dimTextColor,
                                )),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Taken Out',
                                style: TextStyle(
                                  height: 1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            // return
                            Container(
                              width: 69,
                              padding: EdgeInsets.only(bottom: 3),
                              alignment: Alignment.center,
                              child: Text(
                                'Returned',
                                style: TextStyle(
                                  height: 1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // outlet collection
                  Container(
                    width: 160,
                    decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                        color: isDarkTheme
                            ? AppColors.dark_dimTextColor
                            : AppColors.light_dimTextColor,
                      )),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 2),

                        // head
                        Text(
                          'Outlet',
                          style: TextStyle(
                            height: 1,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 3),

                        // bottom
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // outlet collected
                            Container(
                              width: 80,
                              padding: EdgeInsets.only(bottom: 3),
                              decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                  color: isDarkTheme
                                      ? AppColors.dark_dimTextColor
                                      : AppColors.light_dimTextColor,
                                )),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Collected',
                                style: TextStyle(
                                  height: 1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            // outlet return
                            Container(
                              width: 79,
                              padding: EdgeInsets.only(bottom: 3),
                              alignment: Alignment.center,
                              child: Text(
                                'Return',
                                style: TextStyle(
                                  height: 1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // terminal collection
                  Container(
                    width: 160,
                    decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                        color: isDarkTheme
                            ? AppColors.dark_dimTextColor
                            : AppColors.light_dimTextColor,
                      )),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 2),

                        // head
                        Text(
                          'Terminal',
                          style: TextStyle(
                            height: 1,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 3),

                        // bottom
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // terminal collected
                            Container(
                              width: 80,
                              padding: EdgeInsets.only(bottom: 3),
                              decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                  color: isDarkTheme
                                      ? AppColors.dark_dimTextColor
                                      : AppColors.light_dimTextColor,
                                )),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Collected',
                                style: TextStyle(
                                  height: 1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            // terminal return
                            Container(
                              width: 79,
                              padding: EdgeInsets.only(bottom: 3),
                              alignment: Alignment.center,
                              child: Text(
                                'Return',
                                style: TextStyle(
                                  height: 1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // dangote collection
                  Container(
                    width: 160,
                    decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                        color: isDarkTheme
                            ? AppColors.dark_dimTextColor
                            : AppColors.light_dimTextColor,
                      )),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 2),

                        // head
                        Text(
                          'Dangote',
                          style: TextStyle(
                            height: 1,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 3),

                        // bottom
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // dangote collected
                            Container(
                              width: 80,
                              padding: EdgeInsets.only(bottom: 3),
                              decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                  color: isDarkTheme
                                      ? AppColors.dark_dimTextColor
                                      : AppColors.light_dimTextColor,
                                )),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Collected',
                                style: TextStyle(
                                  height: 1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            // dangote return
                            Container(
                              width: 79,
                              padding: EdgeInsets.only(bottom: 3),
                              alignment: Alignment.center,
                              child: Text(
                                'Return',
                                style: TextStyle(
                                  height: 1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // bad product
                  _head_tile(value: 'Bad'),

                  // online
                  _head_tile(value: 'Online'),

                  // quantity sold
                  _head_tile(value: 'Sold', width: 60),

                  // amount
                  _head_tile(value: 'Amount', width: 100),

                  // balance
                  _head_tile(value: 'Balance'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // product list
  Widget product_list(List<DailyStoreProductsModel> _record) {
    double width = MediaQuery.of(context).size.width;
    double space_left = width - 1390;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // s/n & product name
        Container(
          child: SingleChildScrollView(
            controller: _verticalController2,
            child: Column(
              children: _record.map((product) {
                int index = _record.indexOf(product);
                return Row(
                  children: [
                    // s/n
                    Container(
                      color: index.isEven
                          ? Color.fromARGB(89, 123, 117, 117)
                          : Color.fromARGB(90, 211, 202, 202),
                      child: _tile_detail(
                        value: (index + 1).toString(),
                        width: 40,
                        line: (product.product.name.length / 23).ceil(),
                      ),
                    ),

                    // product name
                    Container(
                      color: index.isEven
                          ? Color.fromARGB(89, 123, 117, 117)
                          : Color.fromARGB(90, 211, 202, 202),
                      padding: EdgeInsets.only(left: 10),
                      child: _tile_detail(
                        value: product.product.name,
                        width: space_left < 190 ? 190 : space_left,
                        center: false,
                        name: true,
                        storePrice: product.storePrice != 0
                            ? product.storePrice
                            : product.product.storePrice,
                        line: (product.product.name.length / 23).ceil(),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),

        // product details
        Expanded(
          child: SingleChildScrollView(
            controller: _verticalController1,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _horizontalController1,
              child: Column(
                children: _record.map((product) {
                  int index = _record.indexOf(product);
                  return product_detail_tile(product, index,
                      (product.product.name.length / 23).ceil());
                }).toList(),
              ),
            ),
          ),
        )
      ],
    );
  }

  // product tile
  Widget product_detail_tile(
      DailyStoreProductsModel product, int index, int line) {
    int total = product.openingQuantity + product.added;
    int amount = product.quantitySold *
        (product.storePrice != 0
            ? product.storePrice
            : product.product.storePrice);
    int balance = total -
        (product.request +
            (product.takeOut - product.returnn) +
            (product.outletCollected - product.outletReturn) +
            (product.terminalCollected - product.terminalReturn) +
            (product.dangoteCollected - product.dangoteReturn) +
            product.badProduct +
            product.online +
            product.quantitySold);
    return Container(
      color: index.isEven
          ? Color.fromARGB(89, 123, 117, 117)
          : Color.fromARGB(90, 211, 202, 202),
      child: Row(
        children: [
          // opening quantity
          _tile_detail(value: product.openingQuantity.toString(), line: line),

          // added
          _tile_detail(value: product.added.toString(), line: line),

          // total
          _tile_detail(value: total.toString(), line: line),

          // request
          _tile_detail(value: product.request.toString(), line: line),

          // takeout
          _tile_detail(
              value: product.takeOut.toString(), line: line, width: 70),

          // return
          _tile_detail(
              value: product.returnn.toString(), line: line, width: 70),

          // outlet collected
          _tile_detail(value: product.outletCollected.toString(), line: line),

          // outlet return
          _tile_detail(value: product.outletReturn.toString(), line: line),

          // terminal collected
          _tile_detail(value: product.terminalCollected.toString(), line: line),

          // terminal return
          _tile_detail(value: product.terminalReturn.toString(), line: line),

          // dangote collected
          _tile_detail(value: product.dangoteCollected.toString(), line: line),

          // dangote return
          _tile_detail(value: product.dangoteReturn.toString(), line: line),

          // bad product
          _tile_detail(value: product.badProduct.toString(), line: line),

          // online
          _tile_detail(value: product.online.toString(), line: line),

          // quantity sold
          _tile_detail(
              value: product.quantitySold.toString(), line: line, width: 60),

          // amount
          _tile_detail(
            value: amount.toString(),
            line: line,
            width: 100,
            currency: (amount != 0),
          ),

          // balance
          _tile_detail(value: balance.toString(), line: line),
        ],
      ),
    );
  }

  // head tile
  Widget _head_tile({
    required String value,
    double width = 80,
    bool center = true,
  }) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;
    return Container(
      width: width,
      padding: EdgeInsets.only(
        bottom: 5,
        top: 10,
        left: value == 'Product' ? 30 : 0,
      ),
      decoration: BoxDecoration(
        border: Border(
            right: BorderSide(
          color: isDarkTheme
              ? AppColors.dark_dimTextColor
              : AppColors.light_dimTextColor,
        )),
      ),
      alignment: center ? Alignment.center : Alignment.centerLeft,
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // tile detail
  Widget _tile_detail({
    required String value,
    required int line,
    double width = 80,
    bool center = true,
    bool currency = false,
    double vertical_padding = 5,
    bool name = false,
    int storePrice = 0,
    Color? custom_color = Colors.transparent,
  }) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;
    String val = value == '0'
        ? '-'
        : int.tryParse(value) != null
            ? UniversalHelpers.format_number(int.parse(value),
                currency: currency)
            : value;

    return Container(
      width: width,
      height: line > 1 ? (line * 25) : 30,
      padding: EdgeInsets.symmetric(vertical: vertical_padding),
      decoration: BoxDecoration(
        color: custom_color,
        border: Border(
            right: BorderSide(
          color: isDarkTheme
              ? AppColors.dark_dimTextColor
              : AppColors.light_dimTextColor,
        )),
      ),
      alignment: center ? Alignment.center : Alignment.centerLeft,
      child: name && storePrice != 0 && width > 200
          ? Row(
              children: [
                Expanded(
                  child: Text(
                    val,
                    style: TextStyle(
                        fontWeight: name || currency
                            ? FontWeight.w600
                            : FontWeight.w400),
                  ),
                ),

                SizedBox(width: 10),

                // price
                Text(
                  UniversalHelpers.format_number(storePrice, currency: true),
                  style: TextStyle(
                    color: isDarkTheme
                        ? AppColors.dark_secondaryTextColor
                        : AppColors.light_secondaryTextColor,
                    fontSize: 13,
                  ),
                ),

                SizedBox(width: 8),
              ],
            )
          : Text(
              val,
              style: TextStyle(
                  fontWeight:
                      name || currency ? FontWeight.w600 : FontWeight.w400),
            ),
    );
  }

  // total tiles
  Widget totals_tile({required String label, required int value}) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    TextStyle main_style = TextStyle(
      fontWeight: FontWeight.bold,
      height: 1,
      fontSize: 17,
    );

    TextStyle label_style = TextStyle(
      height: 1,
      fontSize: 13,
      color: isDarkTheme
          ? AppColors.dark_secondaryTextColor
          : AppColors.light_secondaryTextColor,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // label
        Text(label, style: label_style),
        SizedBox(height: 2),
        Text(
          UniversalHelpers.format_number(value, currency: true),
          style: main_style,
        ),
      ],
    );
  }

  //

  // FUNCTIONS
  // get sort
  int get_sort(
    String category,
  ) {
    var category_list = Provider.of<AppData>(context, listen: false)
        .product_categories
        .where((e) => e.category == category);

    if (category_list.isNotEmpty)
      return category_list.first.sort;
    else
      return 1000;
  }

  //
}
