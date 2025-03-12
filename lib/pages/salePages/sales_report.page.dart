import 'package:collection/collection.dart';
import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/productStoreModels/productItem.model.dart';
import 'package:delightsome_software/dataModels/saleModels/sales.model.dart';
import 'package:delightsome_software/helpers/saleHelpers.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:flutter/material.dart';
import 'package:simple_month_year_picker/simple_month_year_picker.dart';
import 'package:provider/provider.dart';

class SalesReportPage extends StatefulWidget {
  const SalesReportPage({super.key});

  @override
  State<SalesReportPage> createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage> {
  List<GroupedSalesModel> store_record = [];
  List<GroupedSalesModel> online_record = [];
  List<GroupedSalesModel> terminal_record = [];

  List<SalesModel> main_store_record = [];
  List<SalesModel> main_online_record = [];
  List<SalesModel> main_terminal_record = [];

  List<SalesModel> store_selected_record = [];
  List<SalesModel> online_selected_record = [];
  List<SalesModel> terminal_selected_record = [];

  DateTime? store_selected_date;
  DateTime? online_selected_date;
  DateTime? terminal_selected_date;

  int index = 0;

  bool is_set = false;

  DateTimeRange? store_dateR;
  DateTime? store_dateD;
  DateTime? store_dateM;

  DateTimeRange? online_dateR;
  DateTime? online_dateD;
  DateTime? online_dateM;

  DateTimeRange? terminal_dateR;
  DateTime? terminal_dateD;
  DateTime? terminal_dateM;

  get_record() {
    List<SalesModel> all_record = Provider.of<AppData>(context).sales_record;
    main_terminal_record = Provider.of<AppData>(context).terminal_sales_record;

    main_store_record = all_record
        .where(
          (element) => element.saleType.toLowerCase() != 'online',
        )
        .toList();

    main_online_record = all_record
        .where((element) => element.saleType.toLowerCase() == 'online')
        .toList();

    // group store by month/day
    final store_groups = groupBy(
      main_store_record,
      (e) {
        if (UniversalHelpers.get_month(e.recordDate!) !=
            UniversalHelpers.get_month(DateTime.now()))
          return UniversalHelpers.get_month(e.recordDate!);
        else
          return UniversalHelpers.get_date(e.recordDate!);
      },
    );

    // group online by month/day
    final online_groups = groupBy(
      main_online_record,
      (e) {
        if (UniversalHelpers.get_month(e.recordDate!) !=
            UniversalHelpers.get_month(DateTime.now()))
          return UniversalHelpers.get_month(e.recordDate!);
        else
          return UniversalHelpers.get_date(e.recordDate!);
      },
    );

    // group terminal by month/day
    final terminal_groups = groupBy(
      main_terminal_record,
      (e) {
        if (UniversalHelpers.get_month(e.recordDate!) !=
            UniversalHelpers.get_month(DateTime.now()))
          return UniversalHelpers.get_month(e.recordDate!);
        else
          return UniversalHelpers.get_date(e.recordDate!);
      },
    );

    store_record.clear();
    store_groups.forEach((key, value) {
      GroupedSalesModel val = GroupedSalesModel(date: key, record: value);
      store_record.add(val);
    });

    online_record.clear();
    online_groups.forEach((key, value) {
      GroupedSalesModel val = GroupedSalesModel(date: key, record: value);
      online_record.add(val);
    });

    terminal_record.clear();
    terminal_groups.forEach((key, value) {
      GroupedSalesModel val = GroupedSalesModel(date: key, record: value);
      terminal_record.add(val);
    });

    if (store_selected_date != null) {
      var data = store_record.where((e) => e.date == store_selected_date);

      if (data.isNotEmpty)
        store_selected_record = data.first.record;
      else {
        store_selected_date = null;
        store_selected_record.clear();
      }
    }

    if (online_selected_date != null) {
      var data = online_record.where((e) => e.date == online_selected_date);

      if (data.isNotEmpty)
        online_selected_record = data.first.record;
      else {
        online_selected_date = null;
        online_selected_record.clear();
      }
    }

    if (terminal_selected_date != null) {
      var data = terminal_record.where((e) => e.date == terminal_selected_date);

      if (data.isNotEmpty)
        terminal_selected_record = data.first.record;
      else {
        terminal_selected_date = null;
        terminal_selected_record.clear();
      }
    }

    set_initial_record();
    setState(() {});
  }

  set_initial_record() {
    if (is_set) return;

    if (store_record.isNotEmpty) {
      store_record.sort((a, b) => b.date.compareTo(a.date));
      var store_list = store_record.first;

      store_selected_record = store_list.record;
      store_selected_date = store_list.date;
    }

    if (online_record.isNotEmpty) {
      online_record.sort((a, b) => b.date.compareTo(a.date));
      var online_list = online_record.first;

      online_selected_record = online_list.record;
      online_selected_date = online_list.date;
    }

    if (terminal_record.isNotEmpty) {
      terminal_record.sort((a, b) => b.date.compareTo(a.date));
      var terminal_list = terminal_record.first;

      terminal_selected_record = terminal_list.record;
      terminal_selected_date = terminal_list.date;
    }

    is_set = true;
  }

  @override
  Widget build(BuildContext context) {
    get_record();
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    return DefaultTabController(
      length: 3,
      initialIndex: index,
      child: Scaffold(
        backgroundColor: isDarkTheme
            ? AppColors.dark_primaryBackgroundColor
            : AppColors.light_dialogBackground_3,
        body: Column(
          children: [
            // top bar
            top_bar(),

            // tabs
            TabBar(
              onTap: (val) {
                setState(() {
                  index = val;
                });
              },
              indicatorColor: AppColors.orange_1,
              labelColor: isDarkTheme
                  ? AppColors.dark_primaryTextColor
                  : AppColors.light_primaryTextColor,
              unselectedLabelColor: isDarkTheme
                  ? AppColors.dark_secondaryTextColor
                  : AppColors.light_secondaryTextColor,
              tabs: [
                Tab(text: 'Outlet Sales'),
                Tab(text: 'Online Sales'),
                Tab(text: 'Terminal Sales'),
              ],
            ),

            // date selector
            if (index == 0)
              date_selector_area(sale_type: 'store')
            else if (index == 1)
              date_selector_area(sale_type: 'online')
            else if (index == 2)
              date_selector_area(sale_type: 'terminal'),

            // content
            Expanded(
              child: TabBarView(
                children: [
                  record_view(store_selected_record),
                  record_view(online_selected_record),
                  record_view(terminal_selected_record),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGETS

  // top bar
  Widget top_bar({String? title}) {
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
              title ?? 'Sales Report',
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

  // date selector area
  Widget date_selector_area({required String sale_type}) {
    List<GroupedSalesModel> g_sales = (sale_type == 'store')
        ? store_record
        : (sale_type == 'online')
            ? online_record
            : terminal_record;

    g_sales.sort((a, b) => b.date.compareTo(a.date));
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    return Container(
      key: Key(sale_type),
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDarkTheme
                ? AppColors.dark_dimTextColor
                : AppColors.light_dimTextColor,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          // list
          Expanded(
            child: ListView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                children: g_sales
                    .map((e) => date_picker_tile(e, sale_type: sale_type))
                    .toList()),
          ),

          SizedBox(width: 10),

          // date picker
          IconButton(
            onPressed: () async {
              var res = await showDatePicker(
                context: context,
                initialDate: (sale_type == 'store')
                    ? store_dateD
                    : (sale_type == 'online')
                        ? online_dateD
                        : terminal_dateD,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );

              if (res != null) {
                if (sale_type == 'store')
                  store_dateD = res;
                else if (sale_type == 'online')
                  online_dateD = res;
                else
                  terminal_dateD = res;

                showDialog(
                    context: context,
                    builder: (context) =>
                        view_record_by_date(date: res, sale_type: sale_type));
              }
            },
            icon: Icon(Icons.calendar_today),
          ),

          // month picker
          IconButton(
            onPressed: () async {
              final res = await SimpleMonthYearPicker.showMonthYearPickerDialog(
                context: context,
                // initialDate: (sale_type == 'store')
                //     ? store_dateM ?? DateTime.now()
                //     : (sale_type == 'online')
                //         ? online_dateM ?? DateTime.now()
                //         : terminal_dateM ?? DateTime.now(),
                // firstDate: DateTime(2020),
                // lastDate: DateTime.now(),
              );

              if (res != null) {
                if (sale_type == 'store')
                  store_dateM = res;
                else if (sale_type == 'online')
                  online_dateM = res;
                else
                  terminal_dateM = res;

                showDialog(
                    context: context,
                    builder: (context) =>
                        view_record_by_date(month: res, sale_type: sale_type));
              }
            },
            icon: Icon(Icons.calendar_month_outlined),
          ),

          // date range
          IconButton(
            onPressed: () async {
              var res = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDateRange: (sale_type == 'store')
                    ? store_dateR
                    : (sale_type == 'online')
                        ? online_dateR
                        : terminal_dateR,
              );

              if (res != null) {
                if (sale_type == 'store')
                  store_dateR = res;
                else if (sale_type == 'online')
                  online_dateR = res;
                else
                  terminal_dateR = res;

                showDialog(
                    context: context,
                    builder: (context) => view_record_by_date(
                        dateRange: res, sale_type: sale_type));
              }
            },
            icon: Icon(Icons.date_range),
          ),
        ],
      ),
    );
  }

  // date picker tile
  Widget date_picker_tile(GroupedSalesModel record,
      {required String sale_type}) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    bool active = (sale_type == 'store')
        ? (store_selected_date == record.date)
        : (sale_type == 'online')
            ? (online_selected_date == record.date)
            : (terminal_selected_date == record.date);

    String title = (UniversalHelpers.get_month(record.date) !=
            UniversalHelpers.get_month(DateTime.now()))
        ? UniversalHelpers.format_month_to_string(record.date, full: true)
        : (UniversalHelpers.get_date(record.date) ==
                UniversalHelpers.get_date(DateTime.now()))
            ? 'Today'
            : UniversalHelpers.format_date_to_string(
                record.date,
              );

    return InkWell(
      key: Key('${sale_type}-${record.date.toString()}'),
      onTap: () {
        if (sale_type == 'store') {
          store_selected_record = record.record;
          store_selected_date = record.date;
        } else if (sale_type == 'online') {
          online_selected_record = record.record;
          online_selected_date = record.date;
        } else {
          terminal_selected_record = record.record;
          terminal_selected_date = record.date;
        }

        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          color: active
              ? AppColors.orange_1
              : isDarkTheme
                  ? AppColors.dark_dimTextColor
                  : AppColors.light_dimTextColor,
          borderRadius: BorderRadius.circular(3),
        ),
        width: 140,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        margin: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: active
                  ? Colors.white
                  : isDarkTheme
                      ? AppColors.dark_secondaryTextColor
                      : AppColors.light_secondaryTextColor,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  // record view
  Widget record_view(List<SalesModel> _record) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;
    double width = MediaQuery.of(context).size.width;

    _record.sort((a, b) => b.recordDate!.compareTo(a.recordDate!));

    int total_qty = _record.fold(0, (int previousValue, element) {
      return previousValue + element.totalQuantity!;
    });

    int total_amount = _record.fold(0, (int previousValue, element) {
      return previousValue + element.discountPrice!;
    });

    int total_discount = _record.fold(0, (int previousValue, element) {
      return previousValue + (element.orderPrice - element.discountPrice!);
    });

    int total_amount_b4_discount =
        _record.fold(0, (int previousValue, element) {
      return previousValue + element.orderPrice;
    });

    int total_cash = _record.fold(0, (int previousValue, element) {
      if (element.splitPaymentMethod != null &&
          element.splitPaymentMethod!.isNotEmpty) {
        int amt = element.splitPaymentMethod!.fold(0, (int p, e) {
          if (e.paymentMethod == 'Cash')
            return p + e.amount;
          else
            return p + 0;
        });

        return previousValue + amt;
      } else if (element.paymentMethod == 'Cash')
        return previousValue + element.discountPrice!;
      else
        return previousValue + 0;
    });

    int total_transfer = _record.fold(0, (int previousValue, element) {
      if (element.splitPaymentMethod != null &&
          element.splitPaymentMethod!.isNotEmpty) {
        int amt = element.splitPaymentMethod!.fold(0, (int p, e) {
          if (e.paymentMethod == 'Transfer')
            return p + e.amount;
          else
            return p + 0;
        });

        return previousValue + amt;
      } else if (element.paymentMethod == 'Transfer')
        return previousValue + element.discountPrice!;
      else
        return previousValue + 0;
    });

    int total_pos = _record.fold(0, (int previousValue, element) {
      if (element.splitPaymentMethod != null &&
          element.splitPaymentMethod!.isNotEmpty) {
        int amt = element.splitPaymentMethod!.fold(0, (int p, e) {
          if (e.paymentMethod == 'POS')
            return p + e.amount;
          else
            return p + 0;
        });

        return previousValue + amt;
      } else if (element.paymentMethod == 'POS')
        return previousValue + element.discountPrice!;
      else
        return previousValue + 0;
    });

    bool is_online = index == 1;
    return Container(
      child: _record.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: record_list(_record),
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // total quantity
                        if (is_online)
                          totals_tile(label: 'Quantity', value: total_qty),

                        // total amount
                        totals_tile(label: 'Total Amount', value: total_amount),

                        // total cash
                        if (!is_online)
                          totals_tile(label: 'Cash', value: total_cash),

                        // total transfer
                        if (!is_online)
                          totals_tile(label: 'Transfer', value: total_transfer),

                        // total pos
                        if (!is_online)
                          totals_tile(label: 'POS', value: total_pos),

                        // total discount
                        if (width > 600)
                          totals_tile(label: 'Discount', value: total_discount),

                        // total amount_b4_discount
                        if (width > 600)
                          totals_tile(
                              label: 'Initial Amount',
                              value: total_amount_b4_discount),
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

  // record list
  Widget record_list(List<SalesModel> _record) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    List<ProductItemModel> products = [];

    for (var _r in _record) {
      SalesModel rec = SalesModel.copy(_r);
      for (var product in rec.products) {
        final chk = products.indexWhere(
            (element) => element.product.key == product.product.key);
        if (chk != -1) {
          products[chk].quantity += product.quantity;
        } else
          products.add(ProductItemModel.copy(product));
      }
    }

    products.sort((a, b) =>
        ((b.price != 0 ? b.price : b.product.storePrice) * b.quantity)
            .compareTo(
                (a.price != 0 ? a.price : a.product.storePrice) * a.quantity));

    TextStyle head_style = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

    return Column(
      children: [
        // head
        Container(
          height: 40,
          child: Center(
            child: Row(
              children: [
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
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Center(
                    child: Text('S/N', style: head_style),
                  ),
                ),

                // name
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Product',
                      style: head_style,
                    ),
                  ),
                ),

                // quantity
                Container(
                  width: 120,
                  child: Center(
                    child: Text('Quantity', style: head_style),
                  ),
                ),

                // amount
                Container(
                  width: 120,
                  child: Center(
                    child: Text('Amount', style: head_style),
                  ),
                ),
              ],
            ),
          ),
        ),

        // list
        Expanded(
          child: ListView.builder(
            itemCount: products.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              ProductItemModel product = products[index];
              return product_tile(product, index);
            },
          ),
        ),
      ],
    );
  }

  // record tile
  Widget product_tile(ProductItemModel product, int index) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    int amount =
        (product.price != 0 ? product.price : product.product.storePrice) *
            product.quantity;

    return Container(
      decoration: BoxDecoration(
        color: index.isEven
            ? Color.fromARGB(89, 123, 117, 117)
            : Color.fromARGB(90, 211, 202, 202),
      ),
      // height: 40,

      child: Row(
        children: [
          // s/n
          Container(
            width: 40,
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: isDarkTheme
                      ? AppColors.dark_dimTextColor
                      : AppColors.light_dimTextColor,
                ),
              ),
            ),
            child: Center(
              child: Text((index + 1).toString(),
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
            ),
          ),

          // name
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                product.product.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
          ),

          // quantity
          Container(
            width: 120,
            child: Center(
              child: Text(
                UniversalHelpers.format_number(product.quantity),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          ),

          // amount
          Container(
            width: 120,
            child: Center(
              child: Text(
                UniversalHelpers.format_number(amount, currency: amount != 0),
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // view date dailog
  Widget view_record_by_date(
      {DateTime? date,
      DateTimeRange? dateRange,
      DateTime? month,
      required String sale_type}) {
    var size = MediaQuery.of(context).size;
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    List<SalesModel> records = [];

    DateTime last_back =
        DateTime(DateTime.now().year, DateTime.now().month - 3, 1);

    bool isOffList = true;

    List<SalesModel> s_record = (sale_type == 'store')
        ? main_store_record
        : (sale_type == 'online')
            ? main_online_record
            : main_terminal_record;

    if (date != null) {
      if (date.isAfter(last_back) || date == last_back) {
        isOffList = false;
        records = s_record
            .where((element) =>
                UniversalHelpers.get_date(element.recordDate!) ==
                UniversalHelpers.get_date(date))
            .toList();
      }
    } else if (month != null) {
      if (month.isAfter(last_back) || month == last_back) {
        isOffList = false;
        records = s_record
            .where((element) =>
                UniversalHelpers.get_month(element.recordDate!) ==
                UniversalHelpers.get_month(month))
            .toList();
      }
    } else if (dateRange != null) {
      if (dateRange.start.isAfter(last_back) || dateRange.start == last_back) {
        isOffList = false;
        records = s_record
            .where(
              (element) =>
                  ((UniversalHelpers.get_date(element.recordDate!) ==
                          UniversalHelpers.get_date(dateRange.start)) ||
                      UniversalHelpers.get_date(element.recordDate!).isAfter(
                          UniversalHelpers.get_date(dateRange.start))) &&
                  ((UniversalHelpers.get_date(element.recordDate!) ==
                          UniversalHelpers.get_date(dateRange.end)) ||
                      UniversalHelpers.get_date(element.recordDate!)
                          .isBefore(UniversalHelpers.get_date(dateRange.end))),
            )
            .toList();
      }
    } else {
      return Container();
    }

    return FutureBuilder<List<SalesModel>>(
      initialData: records,
      future: records.isNotEmpty
          ? null
          : (date != null && isOffList)
              ? (sale_type != 'terminal')
                  ? SaleHelpers.get_selected_sales_record(
                      context, {'date': UniversalHelpers.get_raw_date(date)})
                  : SaleHelpers.get_selected_terminal_sales_record(
                      context, {'date': UniversalHelpers.get_raw_date(date)})
              : (month != null && isOffList)
                  ? (sale_type != 'terminal')
                      ? SaleHelpers.get_selected_sales_record(context, {
                          'month': UniversalHelpers.get_raw_month(month),
                        })
                      : SaleHelpers.get_selected_terminal_sales_record(
                          context, {
                          'month': UniversalHelpers.get_raw_month(month),
                        })
                  : (dateRange != null && isOffList)
                      ? (sale_type != 'terminal')
                          ? SaleHelpers.get_selected_sales_record(context, {
                              'timeFrame': [
                                UniversalHelpers.get_raw_date(dateRange.start),
                                UniversalHelpers.get_raw_date(dateRange.end)
                              ]
                            })
                          : SaleHelpers.get_selected_terminal_sales_record(
                              context, {
                              'timeFrame': [
                                UniversalHelpers.get_raw_date(dateRange.start),
                                UniversalHelpers.get_raw_date(dateRange.end)
                              ]
                            })
                      : null,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Container();
        }

        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }

        var rec = records.isNotEmpty ? records : snapshot.data!;

        var _store_record = rec
            .where((element) => element.saleType.toLowerCase() != 'online')
            .toList();

        var _online_record = rec
            .where((element) => element.saleType.toLowerCase() == 'online')
            .toList();

        List<SalesModel> s_rec =
            (sale_type == 'online') ? _online_record : _store_record;

        return Dialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          child: Container(
            width: size.width > 600 ? size.width / 1.3 : size.width / 0.9,
            height: size.height / 0.9,
            child: Column(
              children: [
                // top bar
                top_bar(
                  title:
                      '${sale_type.toUpperCase()} - ${date != null ? UniversalHelpers.format_date_to_string(date) : month != null ? UniversalHelpers.format_month_to_string(month, full: true) : '${UniversalHelpers.format_date_to_string(dateRange!.start)} - ${UniversalHelpers.format_date_to_string(dateRange.end)}'}',
                ),

                // content
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 5, bottom: 2),
                    padding: EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDarkTheme
                          ? AppColors.dark_dialogBackground_1
                          : AppColors.light_dialogBackground_1,
                    ),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: record_view(s_rec),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
}

class GroupedSalesModel {
  List<SalesModel> record;
  DateTime date;

  GroupedSalesModel({
    required this.record,
    required this.date,
  });
}
