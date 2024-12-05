import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/saleModels/dailysales.model.dart';
import 'package:delightsome_software/helpers/saleHelpers.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/pages/salePages/widgets/daily_sale_record_view.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker2/month_year_picker2.dart';
import 'package:provider/provider.dart';

class DailySalesRecordPage extends StatefulWidget {
  const DailySalesRecordPage({super.key});

  @override
  State<DailySalesRecordPage> createState() => _DailySalesRecordPageState();
}

class _DailySalesRecordPageState extends State<DailySalesRecordPage> {
  TextEditingController search_controller = TextEditingController();
  FocusNode searchNode = FocusNode();
  List<DailySalesModel> all_record = [];

  List<DailySalesModel> record = [];

  List<DailySalesProductsModel> selected_record = [];
  List<DailySalesProductsModel> search_list = [];

  String? selected_date;

  bool is_set = false;

  DateTimeRange? dateR;
  DateTime? dateD;
  DateTime? dateM;

  bool search_on = false;
  bool search_open = false;

  get_record() {
    all_record = Provider.of<AppData>(context).daily_sales_record;

    record.clear();

    for (var r in all_record) {
      // Clone the model to avoid modifying the original `all_record`
      DailySalesModel clonedRecord = DailySalesModel.copy(r);
      if (UniversalHelpers.get_month(DateTime.parse(clonedRecord.date)) !=
          UniversalHelpers.get_month(DateTime.now())) {
        final chk = record
            .where((rec) =>
                rec.date ==
                UniversalHelpers.get_raw_month(
                    DateTime.parse(clonedRecord.date)))
            .toList();

        if (chk.isNotEmpty) {
          final DailySalesModel _rec = chk.first;
          final List<DailySalesProductsModel> _prods = _rec.products;

          var rec_int = record.indexWhere((rec) =>
              rec.date ==
              UniversalHelpers.get_raw_month(
                  DateTime.parse(clonedRecord.date)));

          for (var element in clonedRecord.products) {
            var check = _prods
                .where((p) => p.product.key == element.product.key)
                .toList();

            if (check.isNotEmpty) {
              int prod = _prods
                  .indexWhere((p) => p.product.key == element.product.key);

              var new_p = DailySalesProductsModel(
                key: element.product.key ?? '',
                product: element.product,
                openingQuantity:
                    element.openingQuantity + _prods[prod].openingQuantity,
                storePrice: element.storePrice,
                onlinePrice: element.onlinePrice,
                added: element.added + _prods[prod].added,
                request: element.request + _prods[prod].request,
                terminalCollected:
                    element.terminalCollected + _prods[prod].terminalCollected,
                terminalReturn:
                    element.terminalReturn + _prods[prod].terminalReturn,
                badProduct: element.badProduct + _prods[prod].badProduct,
                online: element.online + _prods[prod].online,
                quantitySold: element.quantitySold + _prods[prod].quantitySold,
              );

              _prods[prod] = new_p;
            } else {
              _prods.add(element);
            }

            record[rec_int].products = _prods;
          }
        } else {
          DailySalesModel new_rec = DailySalesModel(
            key: clonedRecord.key,
            date: UniversalHelpers.get_raw_month(
                DateTime.parse(clonedRecord.date)),
            products: clonedRecord.products,
          );
          record.add(new_rec);
        }
      } else {
        record.add(clonedRecord);
      }
    }

    if (selected_date != null) {
      var data = record.where((e) => e.date == selected_date);

      if (data.isNotEmpty)
        selected_record = data.first.products;
      else {
        selected_date = null;
        selected_record.clear();
      }
    }

    set_initial_record();
    setState(() {});
  }

  List<DailySalesProductsModel> map_record(
      {required List<DailySalesModel> recs}) {
    List<DailySalesProductsModel> products = [];

    for (var r in recs) {
      DailySalesModel clonedRecord = DailySalesModel.copy(r);
      for (var element in clonedRecord.products) {
        final check =
            products.where((p) => p.product.key == element.product.key);

        if (check.isNotEmpty) {
          int prod =
              products.indexWhere((p) => p.product.key == element.product.key);

          var new_p = DailySalesProductsModel(
            key: element.product.key ?? '',
            product: element.product,
            openingQuantity:
                element.openingQuantity + products[prod].openingQuantity,
            storePrice: element.storePrice,
            onlinePrice: element.onlinePrice,
            added: element.added + products[prod].added,
            request: element.request + products[prod].request,
            terminalCollected:
                element.terminalCollected + products[prod].terminalCollected,
            terminalReturn:
                element.terminalReturn + products[prod].terminalReturn,
            badProduct: element.badProduct + products[prod].badProduct,
            online: element.online + products[prod].online,
            quantitySold: element.quantitySold + products[prod].quantitySold,
          );

          products[prod] = new_p;
        } else {
          products.add(element);
        }
      }
    }

    return products;
  }

  set_initial_record() {
    if (is_set) return;
    if (record.isEmpty) return;

    record.sort((a, b) => b.date.compareTo(a.date));
    var _list = record.first;

    selected_record = _list.products;
    selected_date = _list.date;

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

    search_list.clear();
    if (search_on) {
      search_list = search(search_controller.text, selected_record);
    }

    return Scaffold(
      backgroundColor: isDarkTheme
          ? AppColors.dark_primaryBackgroundColor
          : AppColors.light_dialogBackground_3,
      body: Column(
        children: [
          // top bar
          top_bar(),

          // date selector
          date_selector_area(),

          // content
          Expanded(
            child: DailySaleRecordView(
                record: (search_on) ? search_list : selected_record),
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
              if (width > 800 && title == null)
                if (search_open)
                  search_bar()
                else
                  InkWell(
                    onTap: () {
                      search_open = true;

                      Future.delayed(Duration(milliseconds: 300), () {
                        FocusScope.of(context).requestFocus(searchNode);
                      });

                      setState(() {});
                    },
                    child: Container(
                      child: Center(
                        child: Icon(
                          size: 22,
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

              SizedBox(width: 15),
            ],
          ),

          // title
          Center(
            child: Text(
              title ?? 'Daily Product Record',
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

  // search bar
  Widget search_bar() {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: (width > 600) ? 250 : double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: AppColors.dark_secondaryTextColor,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      height: 32,
      child: Center(
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: AppColors.dark_secondaryTextColor,
              size: 22,
            ),

            SizedBox(width: 5),

            // search field
            Expanded(
              child: TextField(
                controller: search_controller,
                focusNode: searchNode,
                style: TextStyle(
                  color: AppColors.dark_primaryTextColor,
                ),
                onChanged: (value) {
                  if (value.trim().isNotEmpty) {
                    search_on = true;
                  } else {
                    search_on = false;
                  }
                  setState(() {});
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
                    color: AppColors.dark_secondaryTextColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),

            InkWell(
              onTap: () {
                if (search_controller.text.isNotEmpty) {
                  search_controller.clear();
                  search_on = false;
                } else {
                  search_open = false;
                }

                setState(() {});
              },
              child: Icon(
                Icons.clear,
                color: AppColors.dark_secondaryTextColor,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // date selector area
  Widget date_selector_area() {
    record.sort((a, b) => b.date.compareTo(a.date));
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    return Container(
      key: Key('selector'),
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
                children: record.map((e) => date_picker_tile(e)).toList()),
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
              final res = await showMonthYearPicker(
                context: context,
                initialDate: dateM ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
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
  Widget date_picker_tile(DailySalesModel _record) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    bool active = selected_date == _record.date;

    String title = (_record.date.split('-').length <= 2)
        ? UniversalHelpers.format_month_to_string(
            DateTime.parse('${_record.date}-01'),
            full: true,
          )
        : (UniversalHelpers.get_date(DateTime.parse(_record.date)) ==
                UniversalHelpers.get_date(DateTime.now()))
            ? 'Today'
            : UniversalHelpers.format_date_to_string(
                DateTime.parse(_record.date),
              );

    return InkWell(
      key: Key('${_record.date.toString()}'),
      onTap: () {
        selected_record = _record.products;
        selected_date = _record.date;

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

  // view date dailog
  Widget view_record_by_date(
      {DateTime? date, DateTimeRange? dateRange, DateTime? month}) {
    var size = MediaQuery.of(context).size;
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    List<DailySalesModel> records = [];

    DateTime last_back =
        DateTime(DateTime.now().year, DateTime.now().month - 3, 1);

    bool isOffList = true;

    List<DailySalesModel> s_record = all_record;

    if (date != null) {
      if (date.isAfter(last_back) || date == last_back) {
        isOffList = false;
        records = s_record
            .where((element) =>
                element.date == UniversalHelpers.get_raw_date(date))
            .toList();
      }
    } else if (month != null) {
      if (month.isAfter(last_back) || month == last_back) {
        isOffList = false;
        records = s_record
            .where((element) =>
                UniversalHelpers.get_month(DateTime.parse(element.date)) ==
                UniversalHelpers.get_month(month))
            .toList();
      }
    } else if (dateRange != null) {
      if (dateRange.start.isAfter(last_back) || dateRange.start == last_back) {
        isOffList = false;
        records = s_record
            .where(
              (element) =>
                  ((UniversalHelpers.get_date(DateTime.parse(element.date)) ==
                          UniversalHelpers.get_date(dateRange.start)) ||
                      UniversalHelpers.get_date(DateTime.parse(element.date))
                          .isAfter(
                              UniversalHelpers.get_date(dateRange.start))) &&
                  ((UniversalHelpers.get_date(DateTime.parse(element.date)) ==
                          UniversalHelpers.get_date(dateRange.end)) ||
                      UniversalHelpers.get_date(DateTime.parse(element.date))
                          .isBefore(UniversalHelpers.get_date(dateRange.end))),
            )
            .toList();
      }
    } else {
      return Container();
    }

    return FutureBuilder<List<DailySalesModel>>(
      initialData: records,
      future: records.isNotEmpty
          ? null
          : (date != null && isOffList)
              ? SaleHelpers.get_selected_daily_sales_record(
                  context, {'date': UniversalHelpers.get_raw_date(date)})
              : (month != null && isOffList)
                  ? SaleHelpers.get_selected_daily_sales_record(context, {
                      'month': UniversalHelpers.get_raw_month(month),
                    })
                  : (dateRange != null && isOffList)
                      ? SaleHelpers.get_selected_daily_sales_record(context, {
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

        var rec = records.isNotEmpty ? records : snapshot.data ?? [];

        List<DailySalesProductsModel> s_rec = map_record(recs: rec);

        return Dialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          child: Container(
            width: size.width / 0.9,
            height: size.height / 0.9,
            child: Column(
              children: [
                // top bar
                top_bar(
                  title:
                      '${date != null ? UniversalHelpers.format_date_to_string(date) : month != null ? UniversalHelpers.format_month_to_string(month, full: true) : '${UniversalHelpers.format_date_to_string(dateRange!.start)} - ${UniversalHelpers.format_date_to_string(dateRange.end)}'}',
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
                      child: DailySaleRecordView(record: s_rec),
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

  // FUNCTIONS
  // search products
  List<DailySalesProductsModel> search(
      String value, List<DailySalesProductsModel> record) {
    return record
        .where((product) =>
            product.product.name.toLowerCase().contains(value.toLowerCase()) ||
            product.product.category
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            product.product.code.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }

//
}
