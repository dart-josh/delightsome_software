import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/materialStoreModels/rawMaterialItem.model.dart';
import 'package:delightsome_software/dataModels/materialStoreModels/rawMaterials.model.dart';
import 'package:delightsome_software/dataModels/materialStoreModels/rawMaterialsRequest.model.dart';
import 'package:delightsome_software/dataModels/userModels/staff.model.dart';
import 'package:delightsome_software/globalvariables.dart';
import 'package:delightsome_software/helpers/materialStoreHelpers.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/pages/materialStorePages/widgets/raw_material_selector.dart';
import 'package:delightsome_software/pages/universalPages/select_staff_dialog.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:delightsome_software/widgets/enter_qty_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnterRawMaterialRequest extends StatefulWidget {
  final RawMaterialsRequestModel? editModel;
  const EnterRawMaterialRequest({super.key, this.editModel});

  @override
  State<EnterRawMaterialRequest> createState() =>
      _EnterRawMaterialRequestState();
}

class _EnterRawMaterialRequestState extends State<EnterRawMaterialRequest> {
  TextEditingController search_controller = TextEditingController();
  FocusNode searchNode = FocusNode();

  int total_qty = 0;

  bool small_screen = false;

  List<RawMaterialsModel> raw_materials = [];

  List<RawMaterialItemModel> selected_items = [];

  List<RawMaterialsModel> search_items = [];
  bool search_on = false;

  bool search_open = false;

  StaffModel? staff;
  String? purpose;

  get_items() {
    raw_materials = Provider.of<AppData>(context).raw_material_list;
  }

  void get_edit_values() {
    if (widget.editModel != null) {
      selected_items = widget.editModel!.items;
      staff = widget.editModel!.receiver;
      purpose = widget.editModel!.purpose;
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
    get_items();

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
                      // item selection
                      selection(),

                      Expanded(
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                // list
                                Expanded(child: item_list()),

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
                                        child: search_items.isNotEmpty
                                            ? SingleChildScrollView(
                                                child: Column(
                                                  children: search_items
                                                      .map(
                                                          (e) => search_tile(e))
                                                      .toList(),
                                                ),
                                              )
                                            : Center(
                                                child: Text('No Item Found !!'),
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
                  // item selection
                  selection(),

                  Expanded(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            // list
                            Expanded(child: item_list()),

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
                                    child: search_items.isNotEmpty
                                        ? SingleChildScrollView(
                                            child: Column(
                                              children: search_items
                                                  .map((e) => search_tile(e))
                                                  .toList(),
                                            ),
                                          )
                                        : Center(
                                            child: Text('No Item Found !!'),
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
                  if (selected_items.isNotEmpty) {
                    var rmrm = RawMaterialsRequestModel(
                      items: selected_items,
                      purpose: purpose,
                      receiver: staff,
                    );

                    if (widget.editModel?.key == null) {
                      saved_raw_material_request_model = rmrm;
                    }
                  } else {
                    saved_raw_material_request_model = null;
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
                      search_items.clear();
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
              'Request Raw Material',
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

  // item selection
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
                RawMaterialsModel? item = await showDialog(
                  context: context,
                  builder: (context) =>
                      RawMaterialSelector(raw_materials: raw_materials),
                );

                if (item != null) {
                  add_item(item);
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
                    Text('Select Item', style: TextStyle(color: Colors.white)),
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
                  if (search_items.isNotEmpty) {
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
                  search_items.clear();
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
  Widget search_tile(RawMaterialsModel item) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;
    double width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () async {
        add_item(item);
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
              item.itemName,
              style: TextStyle(
                fontSize: 16,
                color: isDarkTheme
                    ? AppColors.dark_primaryTextColor
                    : AppColors.light_primaryTextColor,
              ),
            )),
            SizedBox(width: 10),
            Text(
              UniversalHelpers.format_number(item.quantity),
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: isDarkTheme
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

  // item list
  Widget item_list() {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    total_qty = 0;

    TextStyle header_style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );

    TextStyle item_style = TextStyle(
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
                      style: item_style,
                    ),
                  ),
                ),

                // name
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Item',
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
                  child: selected_items.isNotEmpty
                      ? Center(
                          child: InkWell(
                              onTap: () async {
                                var conf =
                                    await UniversalHelpers.showConfirmBox(
                                  context,
                                  title: 'Remove all',
                                  subtitle:
                                      'You are about to remove all items from this list.',
                                );

                                if (conf != null && conf)
                                  setState(() {
                                    selected_items.clear();
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
            child: selected_items.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      children: selected_items.map(
                        (e) {
                          return selected_items_tile(e);
                        },
                      ).toList(),
                    ),
                  )
                : Center(
                    child: Text('No Items Selected !!', style: header_style),
                  ),
          ),
        ],
      ),
    );
  }

  // selected Items tile
  Widget selected_items_tile(RawMaterialItemModel item) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    TextStyle item_style = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 15,
    );

    int sn = selected_items.indexOf(item) + 1;
    total_qty += item.quantity;

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
                style: item_style,
              ),
            ),
          ),

          // name
          Expanded(
            flex: 6,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                item.item.itemName,
                style: item_style,
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
                        SearchQtyDialog(name: item.item.itemName),
                  );

                  if (res != null) {
                    int qty = raw_materials
                        .where((element) => element.key == item.item.key)
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

                    item.quantity = res;
                    // int whr = order_item.indexOf(e);
                    // order_item[whr] = e;

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
                      UniversalHelpers.format_number(item.quantity),
                      style: item_style,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // delete
          InkWell(
            onTap: () {
              selected_items.remove(item);
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
      child: Row(
        children: [
          // submit button
          Expanded(
            child: InkWell(
              onTap: () async {
                if (selected_items.isEmpty) {
                  UniversalHelpers.showToast(
                    context: context,
                    color: Colors.red,
                    toastText: 'No Items Selected',
                    icon: Icons.error,
                  );
                  return;
                }

                var res = await showDialog(
                  context: context,
                  builder: (context) => SelectStaffDialog(
                    staff_label: 'Select a receiver',
                    note_label: 'Purpose',
                    staff: staff,
                    note: purpose,
                    date: widget.editModel?.recordDate,
                    staff_list_type: 'Production, Sales',
                  ),
                );

                if (res != null) {
                  staff = res[0];
                  purpose = res[1];
                  DateTime dt = res[2] ?? DateTime.now();

                  var rmrm = RawMaterialsRequestModel(
                    key: widget.editModel?.key,
                    items: selected_items,
                    purpose: purpose,
                    receiver: staff,
                    recordDate: dt,
                  );

                  if (widget.editModel?.key == null) {
                    var rmrm_s = RawMaterialsRequestModel(
                      items: selected_items,
                      purpose: purpose,
                      receiver: staff,
                    );
                    saved_raw_material_request_model = rmrm_s;
                  }

                  var auth_staff =
                      Provider.of<AppData>(context, listen: false).active_staff;

                  if (auth_staff == null) {
                    return UniversalHelpers.showToast(
                      context: context,
                      color: Colors.red,
                      toastText: 'Invalid Authentication',
                      icon: Icons.error,
                    );
                  }

                  Map map = rmrm.enter_toJson(
                      receiver: staff!.key!, editedBy: auth_staff.key ?? '');

                  bool done = await MaterialStoreHelpers
                      .enter_raw_materials_request_record(context, map);

                  if (widget.editModel?.key != null) {
                    Navigator.pop(context);
                  } else if (done) {
                    saved_raw_material_request_model = null;
                    selected_items.clear();
                    purpose = null;
                    staff = null;
                    setState(() {});
                  }
                }
              },
              child: Container(
                height: 40,
                margin: (width > 600)
                    ? EdgeInsets.symmetric(horizontal: 20, vertical: 15)
                    : null,
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
    );
  }

// FUNCTIONS
// search items
  void search(String value) {
    if (value.isNotEmpty) {
      search_on = true;
      search_items = raw_materials
          .where((item) =>
              item.itemName.toLowerCase().contains(value.toLowerCase()))
          .toList();
    } else {
      search_on = false;
      search_items.clear();
    }

    setState(() {});
  }

  // add item to selected item
  Future<void> add_item(RawMaterialsModel item) async {
    var chk = selected_items.where((e) => e.item.key == item.key);

    if (chk.isEmpty) {
      var res = await showDialog(
        context: context,
        builder: (context) => SearchQtyDialog(name: item.itemName),
      );

      if (res != null) {
        if (res > item.quantity) {
          UniversalHelpers.showToast(
            context: context,
            color: Colors.redAccent,
            toastText: 'Insufficient quantity',
            icon: Icons.error,
          );
          return;
        }

        selected_items.add(
          RawMaterialItemModel(item: item, quantity: res),
        );
        search_on = false;
        setState(() {});
      }
    } else {
      UniversalHelpers.showToast(
        context: context,
        color: Colors.red,
        toastText: 'Item added already',
        icon: Icons.error,
      );
    }
  }

//
}
