import 'package:collection/collection.dart';
import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/productStoreModels/productReturnRecord.model.dart';
import 'package:delightsome_software/helpers/productStoreHelpers.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/pages/productStorePages/enter_product_return.page.dart';
import 'package:delightsome_software/pages/universalPages/record_info_dialog.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:flutter/material.dart';
import 'package:simple_month_year_picker/simple_month_year_picker.dart';
import 'package:provider/provider.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

class ProductReturnRecordPage extends StatefulWidget {
  const ProductReturnRecordPage({super.key});

  @override
  State<ProductReturnRecordPage> createState() =>
      _ProductReturnRecordPageState();
}

class _ProductReturnRecordPageState extends State<ProductReturnRecordPage> {
  List<ProductReturnRecordModel> auth_record = [];
  List<GroupedProductReturnRecordModel> grouped_record = [];
  List<ProductReturnRecordModel> selected_record = [];
  List<ProductReturnRecordModel> pending_record = [];

  DateTime? selected_date;

  int index = 0;

  bool is_set = false;

  DateTimeRange? dateR;
  DateTime? dateD;
  DateTime? dateM;

  get_record() {
    List<ProductReturnRecordModel> all_record =
        Provider.of<AppData>(context).product_return_record;

    pending_record = all_record.where((element) => !element.verified!).toList();
    auth_record = all_record.where((element) => element.verified!).toList();

    final groups = groupBy(
      auth_record,
      (e) => (UniversalHelpers.get_month(e.recordDate!)),
    );

    grouped_record.clear();
    groups.forEach((key, value) {
      GroupedProductReturnRecordModel val =
          GroupedProductReturnRecordModel(date: key, record: value);
      grouped_record.add(val);
    });

    if (selected_date != null) {
      var data = grouped_record.where((e) => e.date == selected_date);

      if (data.isNotEmpty)
        selected_record = data.first.record;
      else {
        selected_date = null;
        selected_record.clear();
      }
    }

    set_initial_record();
    setState(() {});
  }

  set_initial_record() {
    if (is_set) return;
    if (grouped_record.isEmpty) return;

    grouped_record.sort((a, b) => b.date.compareTo(a.date));
    var ch = grouped_record.first;

    selected_record = ch.record;
    selected_date = ch.date;

    if (pending_record.isEmpty) index = 1;
    is_set = true;
  }

  @override
  Widget build(BuildContext context) {
    get_record();
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    return DefaultTabController(
      length: 2,
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
                Tab(text: 'Pending Record'),
                Tab(text: 'Authorized Record'),
              ],
            ),

            // date selector
            if (index == 1) date_selector_area(),

            // content
            Expanded(
              child: TabBarView(
                children: [
                  record_view(pending_record),
                  record_view(selected_record),
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
              title ?? 'Product Return Record',
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
  Widget date_selector_area() {
    grouped_record.sort((a, b) => b.date.compareTo(a.date));
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    return Container(
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
                children:
                    grouped_record.map((e) => date_picker_tile(e)).toList()),
          ),

          SizedBox(width: 10),

          // date picker
          IconButton(
            onPressed: () async {
              var res = await showDatePicker(
                context: context,
                initialDate: dateD,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );

              if (res != null) {
                dateD = res;

                showDialog(
                    context: context,
                    builder: (context) => view_record_by_date(date: res));
              }
            },
            icon: Icon(Icons.calendar_today),
          ),

          // month picker
          IconButton(
            onPressed: () async {
              final res = await SimpleMonthYearPicker.showMonthYearPickerDialog(
                context: context,
                // initialDate: dateM ?? DateTime.now(),
                // firstDate: DateTime(2020),
                // lastDate: DateTime.now(),
              );

              if (res != null) {
                dateM = res;
                showDialog(
                    context: context,
                    builder: (context) => view_record_by_date(month: res));
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
                initialDateRange: dateR,
              );

              if (res != null) {
                dateR = res;

                showDialog(
                    context: context,
                    builder: (context) => view_record_by_date(dateRange: res));
              }
            },
            icon: Icon(Icons.date_range),
          ),
        ],
      ),
    );
  }

  // date picker tile
  Widget date_picker_tile(GroupedProductReturnRecordModel record) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    bool active = selected_date == record.date;

    return InkWell(
      onTap: () {
        selected_record = record.record;
        selected_date = record.date;
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
        width: 125,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        margin: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        child: Center(
          child: Text(
            UniversalHelpers.format_month_to_string(record.date, full: true),
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
  Widget record_view(List<ProductReturnRecordModel> _record) {
    _record.sort((a, b) => b.recordDate!.compareTo(a.recordDate!));

    return Container(
      child: _record.isNotEmpty
          ? StickyGroupedListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              elements: _record,
              groupBy: (ProductReturnRecordModel element) =>
                  UniversalHelpers.get_date(element.recordDate!),
              groupComparator: (DateTime value1, DateTime value2) =>
                  value2.compareTo(value1),
              groupSeparatorBuilder: (ProductReturnRecordModel element) =>
                  group_separator(element.recordDate!),
              itemBuilder: (context, ProductReturnRecordModel element) =>
                  record_tile(element),
              itemComparator: (e1, e2) =>
                  e2.recordDate!.compareTo(e1.recordDate!),
              elementIdentifier: (element) => element.key,
              order: StickyGroupedListOrder.ASC,
              stickyHeaderBackgroundColor: Colors.transparent,
            )
          : Center(
              child: Text('No Record to Display !!'),
            ),
    );
  }

  // record tile
  Widget record_tile(ProductReturnRecordModel record) {
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

    TextStyle edit_style = TextStyle(
      color: Colors.green,
      fontWeight: FontWeight.w500,
      fontSize: 12,
    );

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
                // record Id
                Text(
                  record.recordId ?? 'No Id',
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

                // returnedBy
                Row(
                  children: [
                    Text('Returned By : ', style: label_style),
                    SizedBox(width: 4),
                    Text(record.returnedBy?.nickName ?? 'No Staff',
                        style: main_style),
                    Expanded(child: Container()),
                    Text('Total : ', style: label_style),
                    SizedBox(width: 4),
                    Text(
                        UniversalHelpers.format_number(
                            record.totalQuantity ?? 0),
                        style: main_style),
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

                SizedBox(height: 4),

                // verified/edited
                Row(
                  children: [
                    // edited
                    if (record.isEdited ?? false)
                      Text('Edited', style: edit_style),
                    Expanded(child: Container()),

                    // verified/verifiedBy
                    if (record.verified ?? false)
                      Row(
                        children: [
                          Icon(Icons.verified, size: 16),
                          SizedBox(width: 4),
                          Text(record.verifiedBy?.nickName ?? 'Admin')
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),

          // more button
          Positioned(
            top: 2,
            right: 2,
            child: IconButton(
                onPressed: () async {
                  var res = await showDialog(
                    context: context,
                    builder: (context) => RecordInfoDialog(
                      approved: record.verified ?? false,
                      approvedBy: record.verifiedBy?.nickName,
                      approvedDate: record.verifiedDate,
                      editedBy: record.editedBy ?? [],
                      approve_label: 'Authorize',
                      staff: record.returnedBy!,
                      recordId: record.recordId ?? 'No ID',
                      auth_approve_staff: 'Admin',
                    ),
                  );

                  if (res != null) {
                    // authorize
                    if (res == 'Authorize') {
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

                      ProductStoreHelpers.verify_product_return_record(
                          context,
                          record.verify_toJson(
                              verifiedBy: auth_staff.key ?? ''));
                    }

                    // edit
                    if (res == 'edit') {
                      double width = MediaQuery.of(context).size.width;

                      if (width > 600) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => EnterProductReturnPage(
                                  editModel: record,
                                ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EnterProductReturnPage(
                                      editModel: record,
                                    )));
                      }
                    }

                    if (res == 'delete') {
                      ProductStoreHelpers.delete_product_return_record(
                          context, record.key!);
                    }
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
      {DateTime? date, DateTimeRange? dateRange, DateTime? month}) {
    var size = MediaQuery.of(context).size;
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    List<ProductReturnRecordModel> records = [];

    DateTime last_back =
        DateTime(DateTime.now().year, DateTime.now().month - 3, 1);

    bool isOffList = true;

    if (date != null) {
      if (date.isAfter(last_back) || date == last_back) {
        isOffList = false;
        records = auth_record
            .where((element) =>
                UniversalHelpers.get_date(element.recordDate!) ==
                UniversalHelpers.get_date(date))
            .toList();
      }
    } else if (month != null) {
      if (month.isAfter(last_back) || month == last_back) {
        isOffList = false;
        records = auth_record
            .where((element) =>
                UniversalHelpers.get_month(element.recordDate!) ==
                UniversalHelpers.get_month(month))
            .toList();
      }
    } else if (dateRange != null) {
      if (dateRange.start.isAfter(last_back) || dateRange.start == last_back) {
        isOffList = false;
        records = auth_record
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

    return FutureBuilder<List<ProductReturnRecordModel>>(
      initialData: records,
      future: records.isNotEmpty
          ? null
          : (date != null && isOffList)
              ? ProductStoreHelpers.get_selected_product_return_record(
                  context, {'date': UniversalHelpers.get_raw_date(date)})
              : (month != null && isOffList)
                  ? ProductStoreHelpers.get_selected_product_return_record(
                      context, {
                      'month': UniversalHelpers.get_raw_month(month),
                    })
                  : (dateRange != null && isOffList)
                      ? ProductStoreHelpers.get_selected_product_return_record(
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
                  title: date != null
                      ? UniversalHelpers.format_date_to_string(date)
                      : month != null
                          ? UniversalHelpers.format_month_to_string(month,
                              full: true)
                          : '${UniversalHelpers.format_date_to_string(dateRange!.start)} - ${UniversalHelpers.format_date_to_string(dateRange.end)}',
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
                      child: record_view(rec),
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

  //
}

class GroupedProductReturnRecordModel {
  List<ProductReturnRecordModel> record;
  DateTime date;

  GroupedProductReturnRecordModel({
    required this.record,
    required this.date,
  });
}
