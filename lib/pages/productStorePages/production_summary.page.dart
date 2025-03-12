import 'package:collection/collection.dart';
import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/productStoreModels/productionRecord.model.dart';
import 'package:delightsome_software/helpers/productStoreHelpers.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:flutter/material.dart';
import 'package:simple_month_year_picker/simple_month_year_picker.dart';
import 'package:provider/provider.dart';

class ProductionSummaryPage extends StatefulWidget {
  const ProductionSummaryPage({super.key});

  @override
  State<ProductionSummaryPage> createState() => _ProductionSummaryPageState();
}

class _ProductionSummaryPageState extends State<ProductionSummaryPage> {
  TextEditingController search_controller = TextEditingController();
  FocusNode searchNode = FocusNode();

  List<ProductionRecordModel> auth_record = [];
  List<GroupedProductionRecordModel> grouped_record = [];
  List<ProductionRecordModel> selected_record = [];

  DateTime? selected_date;

  bool is_set = false;

  DateTimeRange? dateR;
  DateTime? dateD;
  DateTime? dateM;

  List<ProductionSummaryModel> search_list = [];

  bool search_on = false;
  bool search_open = false;

  get_record() {
    List<ProductionRecordModel> all_record =
        Provider.of<AppData>(context).production_record;

    auth_record = all_record.where((element) => element.verified!).toList();

    final groups = groupBy(
      auth_record,
      (e) => (UniversalHelpers.get_date(e.recordDate!)),
    );

    grouped_record.clear();
    groups.forEach((key, value) {
      GroupedProductionRecordModel val =
          GroupedProductionRecordModel(date: key, record: value);
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

    is_set = true;
  }

  @override
  void dispose() {
    search_controller.dispose();
    searchNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    get_record();
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;
    double width = MediaQuery.of(context).size.width;

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
                      // date selector
                      date_selector_area(),

                      SizedBox(height: 5),

                      // search area
                      search_area(),

                      // content
                      Expanded(
                        child: record_view(selected_record),
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
                  // date selector
                  date_selector_area(),

                  SizedBox(height: 5),

                  // search area
                  search_area(),

                  // content
                  Expanded(
                    child: record_view(selected_record),
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
              if (!(width > 600) && title == null)
                InkWell(
                  onTap: () {
                    search_open = !search_open;

                    if (!search_open) {
                      search_controller.clear();
                      search_on = false;
                      search_list.clear();
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
                        size: 22,
                        search_open ? Icons.search_off : Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

              if (!(width > 600)  && title == null) SizedBox(width: 10),
            ],
          ),

          // title
          Center(
            child: Text(
              title ?? 'Production Summary',
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
              search_list.clear();
              search_on = false;
              search_controller.clear();
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

              setState(() {});
            },
            icon: Icon(Icons.calendar_today),
          ),

          // month picker
          IconButton(
            onPressed: () async {
              search_list.clear();
              search_on = false;
              search_controller.clear();
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

              setState(() {});
            },
            icon: Icon(Icons.calendar_month_outlined),
          ),

          // date range
          IconButton(
            onPressed: () async {
              search_list.clear();
              search_on = false;
              search_controller.clear();
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

              setState(() {});
            },
            icon: Icon(Icons.date_range),
          ),
        ],
      ),
    );
  }

  // date picker tile
  Widget date_picker_tile(GroupedProductionRecordModel record) {
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
        width: 135,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        margin: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        child: Center(
          child: Text(
            UniversalHelpers.format_date_to_string(record.date),
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
  Widget record_view(List<ProductionRecordModel> _record) {
    List<ProductionSummaryModel> summary = [];
    int total_qty = 0;

    for (int i = 0; i < _record.length; i++) {
      var record = _record[i];
      for (var product in record.products) {
        ProductionSummaryModel sum = ProductionSummaryModel(
          name: product.product.name,
          quantity: product.quantity,
        );

        var chk = summary.indexWhere((e) => e.name == sum.name);
        if (chk == -1) {
          summary.add(sum);
        } else {
          summary[chk].quantity += product.quantity;
        }

        total_qty += product.quantity;
      }
    }

    search(summary, search_controller.text);

    summary.sort((a, b) => b.quantity.compareTo(a.quantity));
    search_list.sort((a, b) => b.quantity.compareTo(a.quantity));

    return Container(
      child: search_on && search_list.isEmpty
          ? Center(
              child: Text('Product Not Found !!'),
            )
          : _record.isNotEmpty
              ? Column(
                  children: [
                    SizedBox(height: 6),
                    // total quantity
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            'Total Quantity :',
                            style: TextStyle(fontSize: 13),
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
                    ),

                    search_on && search_list.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, index) =>
                                  record_tile(search_list[index]),
                              physics: BouncingScrollPhysics(),
                              itemCount: search_list.length,
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, index) =>
                                  record_tile(summary[index]),
                              physics: BouncingScrollPhysics(),
                              itemCount: summary.length,
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
  Widget record_tile(ProductionSummaryModel record) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    TextStyle label_style = TextStyle(
      color: isDarkTheme
          ? AppColors.dark_secondaryTextColor
          : AppColors.light_secondaryTextColor,
      fontSize: 13,
    );

    TextStyle main_style = TextStyle(
      color: isDarkTheme
          ? AppColors.dark_primaryTextColor
          : AppColors.light_primaryTextColor,
      fontWeight: FontWeight.w700,
      fontSize: 14,
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
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(record.name, style: label_style),
            Text(
              UniversalHelpers.format_number(record.quantity),
              style: main_style,
            ),
          ],
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

    List<ProductionRecordModel> records = [];

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

    return FutureBuilder<List<ProductionRecordModel>>(
      initialData: records,
      future: records.isNotEmpty
          ? null
          : (date != null && isOffList)
              ? ProductStoreHelpers.get_selected_production_record(
                  context, {'date': UniversalHelpers.get_raw_date(date)})
              : (month != null && isOffList)
                  ? ProductStoreHelpers.get_selected_production_record(
                      context, {
                      'month': UniversalHelpers.get_raw_month(month),
                    })
                  : (dateRange != null && isOffList)
                      ? ProductStoreHelpers.get_selected_production_record(
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

  // search area
  Widget search_area() {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          // if (!search_open) SizedBox(width: 10),

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
                onChanged: (_) {
                  setState(() {});
                },
                onTap: () {
                  if (search_list.isNotEmpty) {
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
                  search_list.clear();
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

  //

  // FUNCTIONS
  // search products
  void search(List<ProductionSummaryModel> record, String value) {
    if (value.trim().isNotEmpty) {
      search_on = true;
      search_list = record
          .where((product) =>
              product.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    } else {
      search_on = false;
      search_list.clear();
    }
  }

  //
}

class GroupedProductionRecordModel {
  List<ProductionRecordModel> record;
  DateTime date;

  GroupedProductionRecordModel({
    required this.record,
    required this.date,
  });
}

class ProductionSummaryModel {
  String name;
  int quantity;

  ProductionSummaryModel({
    required this.name,
    required this.quantity,
  });
}
