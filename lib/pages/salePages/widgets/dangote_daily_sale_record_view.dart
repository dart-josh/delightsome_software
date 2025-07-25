import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/saleModels/dangoteDailysales.model.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:provider/provider.dart';

class DangoteDailySaleRecordView extends StatefulWidget {
  final List<DangoteDailySalesProductsModel> record;
  const DangoteDailySaleRecordView({super.key, required this.record});

  @override
  State<DangoteDailySaleRecordView> createState() =>
      _DangoteDailySaleRecordViewState();
}

class _DangoteDailySaleRecordViewState
    extends State<DangoteDailySaleRecordView> {
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
              element.sold);
    });

    int total_qunatity_sold =
        widget.record.fold(0, (int previousValue, element) {
      return previousValue + (element.sold);
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
                        // total sold
                        totals_tile(
                          label: 'Total Sold',
                          value: total_qunatity_sold,
                          currency: false,
                        ),

                        SizedBox(width: 100),

                        // total store amount
                        totals_tile(
                          label: 'Total Sales',
                          value: total_store_amount,
                        ),
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
  Widget selected_page(List<DangoteDailySalesProductsModel> _record) {
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
    double space_left = width - 600;
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
                  _head_tile(value: 'Collected'),

                  // total
                  _head_tile(value: 'Total'),

                  // total
                  _head_tile(value: 'Sold', width: 60),

                  // amount
                  _head_tile(value: 'Amount', width: 100),

                  // request
                  _head_tile(value: 'Returned'),

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
  Widget product_list(List<DangoteDailySalesProductsModel> _record) {
    double width = MediaQuery.of(context).size.width;
    double space_left = width - 610;
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
                  return product_detail_tile(product, index);
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
      DangoteDailySalesProductsModel product, int index) {
    int total = product.openingQuantity + product.collected;
    int amount = product.sold *
        (product.storePrice != 0
            ? product.storePrice
            : product.product.storePrice);

    int balance = total - (product.returned + product.sold);

    return Container(
      color: index.isEven
          ? Color.fromARGB(89, 123, 117, 117)
          : Color.fromARGB(90, 211, 202, 202),
      child: Row(
        children: [
          // opening quantity
          _tile_detail(value: product.openingQuantity.toString()),

          // collected
          _tile_detail(value: product.collected.toString()),

          // total
          _tile_detail(value: total.toString()),

          // sold
          _tile_detail(value: product.sold.toString(), width: 60),

          // amount
          _tile_detail(
            value: amount.toString(),
            width: 100,
            currency: (amount != 0),
          ),

          // returned
          _tile_detail(value: product.returned.toString()),

          // balance
          _tile_detail(value: balance.toString()),
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
  Widget totals_tile(
      {required String label, required int value, bool currency = true}) {
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
          UniversalHelpers.format_number(value, currency: currency),
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
