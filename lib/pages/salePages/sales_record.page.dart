import 'package:collection/collection.dart';
import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/saleModels/sales.model.dart';
import 'package:delightsome_software/globalvariables.dart';
import 'package:delightsome_software/helpers/saleHelpers.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/pages/salePages/widgets/sale_info_dialog.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker2/month_year_picker2.dart';
import 'package:provider/provider.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

class SalesRecordPage extends StatefulWidget {
  const SalesRecordPage({super.key});

  @override
  State<SalesRecordPage> createState() => _SalesRecordPageState();
}

class _SalesRecordPageState extends State<SalesRecordPage> {
  List<GroupedSalesModel> store_record = [];
  List<GroupedSalesModel> online_record = [];

  List<SalesModel> today_record = [];
  List<SalesModel> main_store_record = [];
  List<SalesModel> main_online_record = [];

  List<SalesModel> store_selected_record = [];
  List<SalesModel> online_selected_record = [];

  DateTime? store_selected_date;
  DateTime? online_selected_date;

  int index = 0;

  bool is_set = false;

  DateTimeRange? store_dateR;
  DateTime? store_dateD;
  DateTime? store_dateM;

  DateTimeRange? online_dateR;
  DateTime? online_dateD;
  DateTime? online_dateM;

  get_record() {
    List<SalesModel> all_record = Provider.of<AppData>(context).sales_record;

    today_record = all_record
        .where(
          (element) =>
              UniversalHelpers.get_date(element.recordDate!) ==
                  UniversalHelpers.get_date(DateTime.now()) &&
              element.saleType.toLowerCase() != 'online',
        )
        .toList();

    main_store_record = all_record
        .where(
          (element) =>
              UniversalHelpers.get_date(element.recordDate!) !=
                  UniversalHelpers.get_date(DateTime.now()) &&
              element.saleType.toLowerCase() != 'online',
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

    if (store_record.isNotEmpty) {
      online_record.sort((a, b) => b.date.compareTo(a.date));
      var online_list = online_record.first;

      online_selected_record = online_list.record;
      online_selected_date = online_list.date;
    }

    if (today_record.isEmpty) index = 1;
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
                Tab(text: 'Today Sales'),
                Tab(text: 'General Sales'),
                Tab(text: 'Online Sales'),
              ],
            ),

            // date selector
            if (index == 1)
              date_selector_area(sale_type: 'store')
            else if (index == 2)
              date_selector_area(sale_type: 'online'),

            // content
            Expanded(
              child: TabBarView(
                children: [
                  record_view(today_record),
                  record_view(store_selected_record),
                  record_view(online_selected_record),
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
              title ?? 'Sales Record',
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
    List<GroupedSalesModel> g_sales =
        (sale_type == 'online') ? online_record : store_record;

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
                initialDate:
                    (sale_type == 'online') ? online_dateD : store_dateD,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );

              if (res != null) {
                if (sale_type == 'online')
                  online_dateD = res;
                else
                  store_dateD = res;

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
              final res = await showMonthYearPicker(
                context: context,
                initialDate: (sale_type == 'online')
                    ? online_dateM ?? DateTime.now()
                    : store_dateM ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );

              if (res != null) {
                if (sale_type == 'online')
                  online_dateM = res;
                else
                  store_dateM = res;

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
                initialDateRange:
                    (sale_type == 'online') ? online_dateR : store_dateR,
              );

              if (res != null) {
                if (sale_type == 'online')
                  online_dateR = res;
                else
                  store_dateR = res;

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

    bool active = (sale_type == 'online')
        ? (online_selected_date == record.date)
        : (store_selected_date == record.date);

    String title = (UniversalHelpers.get_month(record.date) !=
            UniversalHelpers.get_month(DateTime.now()))
        ? UniversalHelpers.format_month_to_string(record.date, full: true)
        : UniversalHelpers.format_date_to_string(
            record.date,
          );

    return InkWell(
      key: Key('${sale_type}-${record.date.toString()}'),
      onTap: () {
        if (sale_type == 'online') {
          online_selected_record = record.record;
          online_selected_date = record.date;
        } else {
          store_selected_record = record.record;
          store_selected_date = record.date;
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

    // int total_qty = _record.fold(0, (int previousValue, element) {
    //   return previousValue + element.totalQuantity!;
    // });

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

    bool is_online = index == 2;
    return Container(
      child: _record.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: StickyGroupedListView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    elements: _record,
                    groupBy: (SalesModel element) =>
                        UniversalHelpers.get_date(element.recordDate!),
                    groupComparator: (DateTime value1, DateTime value2) =>
                        value2.compareTo(value1),
                    groupSeparatorBuilder: (SalesModel element) =>
                        group_separator(element.recordDate!),
                    itemBuilder: (context, SalesModel element) =>
                        record_tile(element),
                    itemComparator: (e1, e2) =>
                        e2.recordDate!.compareTo(e1.recordDate!),
                    elementIdentifier: (element) => element.key,
                    order: StickyGroupedListOrder.ASC,
                    stickyHeaderBackgroundColor: Colors.transparent,
                  ),
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

  // record tile
  Widget record_tile(SalesModel record) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    TextStyle label_style = TextStyle(
      color: isDarkTheme
          ? AppColors.dark_secondaryTextColor
          : AppColors.light_secondaryTextColor,
      fontSize: 13,
    );

    TextStyle date_style = TextStyle(
      color: isDarkTheme
          ? AppColors.dark_secondaryTextColor
          : AppColors.light_secondaryTextColor,
      fontStyle: FontStyle.italic,
      fontSize: 13,
    );

    TextStyle main_style = TextStyle(
      color: isDarkTheme
          ? AppColors.dark_primaryTextColor
          : AppColors.light_primaryTextColor,
      fontWeight: FontWeight.w700,
      fontSize: 14,
    );

    TextStyle note_style = TextStyle(
      color: isDarkTheme
          ? AppColors.dark_secondaryTextColor
          : AppColors.light_secondaryTextColor,
      fontWeight: FontWeight.w600,
      fontSize: 14,
    );

    bool is_dicounted = (record.discountPrice != null &&
        (record.discountPrice != record.orderPrice));

    return Container(
      decoration: BoxDecoration(
        color: isDarkTheme
            ? AppColors.dark_primaryBackgroundColor
            : AppColors.light_dialogBackground_1,
        border: Border.all(
          color: isDarkTheme
              ? AppColors.dark_dimTextColor
              : AppColors.light_dimTextColor,
        ),
        borderRadius: BorderRadius.circular(1),
      ),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // order Id
                Text(
                  record.orderId ?? 'No Id',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                    color: isDarkTheme
                        ? AppColors.dark_secondaryTextColor
                        : AppColors.light_secondaryTextColor,
                  ),
                ),

                SizedBox(height: 10),

                // recordDate
                Text(
                    UniversalHelpers.format_time_to_string(
                        record.recordDate ?? record.createdAt),
                    style: date_style),

                SizedBox(height: 1),

                // total & customer
                Row(
                  children: [
                    Text('Total : ', style: label_style),
                    SizedBox(width: 4),
                    Text(
                        UniversalHelpers.format_number(
                            record.totalQuantity ?? 0),
                        style: main_style),

                    Expanded(child: Container()),

                    // customer
                    if (record.customer != null &&
                        record.customer!.nickName.isNotEmpty)
                      Row(
                        children: [
                          Text('Customer : ', style: label_style),
                          SizedBox(width: 4),
                          Text(record.customer!.nickName, style: note_style),
                        ],
                      )
                    else
                      Text('Random customer', style: label_style),
                  ],
                ),

                // products
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  child: Wrap(
                    runSpacing: 5,
                    spacing: 5,
                    children: record.products.map(
                      (e) {
                        bool long = e.product.name.length > 20;
                        bool very_long = e.product.name.length > 30;
                        return ConstrainedBox(
                          constraints:
                              BoxConstraints(maxWidth: very_long ? 300 : 200),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDarkTheme
                                  ? AppColors.dark_dimTextColor
                                  : AppColors.light_dimTextColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (long)
                                  Expanded(
                                    child: Text(e.product.name,
                                        overflow: TextOverflow.ellipsis),
                                  )
                                else
                                  Text(e.product.name,
                                      overflow: TextOverflow.ellipsis),
                                Text(' - '),
                                Text(e.quantity.toString()),
                              ],
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),

                SizedBox(height: 2),

                // amount & payment method
                Row(
                  children: [
                    // amount
                    Text(
                      UniversalHelpers.format_number(record.orderPrice,
                          currency: true),
                      style: TextStyle(
                        color: isDarkTheme
                            ? is_dicounted
                                ? AppColors.dark_secondaryTextColor
                                : AppColors.dark_primaryTextColor
                            : is_dicounted
                                ? AppColors.light_secondaryTextColor
                                : AppColors.light_primaryTextColor,
                        fontWeight:
                            is_dicounted ? FontWeight.w400 : FontWeight.w700,
                        fontSize: is_dicounted ? 13 : 16,
                        decoration:
                            is_dicounted ? TextDecoration.lineThrough : null,
                      ),
                    ),

                    if (is_dicounted) SizedBox(width: 8),

                    // discount
                    if (is_dicounted)
                      Text(
                        UniversalHelpers.format_number(record.discountPrice!,
                            currency: true),
                        style: TextStyle(
                          color: isDarkTheme
                              ? AppColors.dark_primaryTextColor
                              : AppColors.light_primaryTextColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),

                    SizedBox(width: 5),

                    Expanded(child: Container()),

                    // payment method
                    Text(record.paymentMethod, style: main_style),
                  ],
                ),

                // split payment
                if (record.splitPaymentMethod != null &&
                    record.splitPaymentMethod!.isNotEmpty)
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: record.splitPaymentMethod!
                          .map(
                            (e) => Row(
                              children: [
                                if (record.splitPaymentMethod!.indexOf(e) != 0)
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4),
                                    child: Text('|', style: label_style),
                                  ),

                                // payment method
                                Text(e.paymentMethod ?? '', style: label_style),

                                SizedBox(width: 2),

                                Text(' - ', style: label_style),
                                SizedBox(width: 2),

                                // amount
                                Text(
                                    UniversalHelpers.format_number(e.amount,
                                        currency: true),
                                    style: main_style),
                              ],
                            ),
                          )
                          .toList()),

                SizedBox(height: 2),

                // shortNote
                if (record.shortNote != null && record.shortNote!.isNotEmpty)
                  Row(
                    children: [
                      Text('Short note : ', style: label_style),
                      SizedBox(width: 4),
                      Expanded(
                          child: Text(record.shortNote!, style: note_style)),
                    ],
                  ),
              ],
            ),
          ),

          // more button
          if (activeStaff!.fullaccess)
            Positioned(
              top: 2,
              right: 2,
              child: IconButton(
                  onPressed: () async {
                    var res = await showDialog(
                        context: context,
                        builder: (context) =>
                            SaleInfoDialog(order_id: record.orderId!));

                    if (res != null) {
                      if (res == 'delete') {
                        SaleHelpers.delete_sale_record(context, record.key!);
                      }

                      // change_pmt
                    }
                  },
                  icon: Icon(Icons.more_vert)),
            ),
        ],
      ),
    );
  }

  // group separator
  Widget group_separator(DateTime date) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDarkTheme
            ? AppColors.dark_primaryBackgroundColor
            : AppColors.light_dialogBackground_3,
        border: Border.all(
          color: isDarkTheme
              ? AppColors.dark_dimTextColor
              : AppColors.light_dimTextColor,
        ),
        borderRadius: BorderRadius.circular(1),
      ),
      // margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        UniversalHelpers.format_date_to_string(date, full: true),
        style: TextStyle(
          color: isDarkTheme
              ? AppColors.dark_secondaryTextColor
              : AppColors.light_secondaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
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

    List<SalesModel> s_record =
        (sale_type == 'online') ? main_online_record : main_store_record;

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
              ? SaleHelpers.get_selected_sales_record(
                  context, {'date': UniversalHelpers.get_raw_date(date)})
              : (month != null && isOffList)
                  ? SaleHelpers.get_selected_sales_record(context, {
                      'month': UniversalHelpers.get_raw_month(month),
                    })
                  : (dateRange != null && isOffList)
                      ? SaleHelpers.get_selected_sales_record(context, {
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
