import 'package:collection/collection.dart';
import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/materialStoreModels/rawMaterials.model.dart';
import 'package:delightsome_software/helpers/materialStoreHelpers.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/pages/materialStorePages/add_update_raw_material.page.dart';
import 'package:delightsome_software/pages/materialStorePages/widgets/raw_material_selector.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:expandable_group/expandable_group_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RawMaterialListPage extends StatefulWidget {
  const RawMaterialListPage({super.key});

  @override
  State<RawMaterialListPage> createState() => _RawMaterialListPageState();
}

class _RawMaterialListPageState extends State<RawMaterialListPage> {
  TextEditingController search_controller = TextEditingController();
  FocusNode searchNode = FocusNode();

  List<RawMaterialsModel> all_raw_materials = [];

  List<GroupedRawMaterialsModel> grouped_list = [];
  List<GroupedRawMaterialsModel> search_list = [];

  bool search_on = false;
  bool search_open = false;

  int index = 0;

  bool restock_page = false;

  get_items() {
    all_raw_materials = (restock_page)
        ? Provider.of<AppData>(context)
            .raw_material_list
            .where((e) => e.quantity <= e.restockLimit)
            .toList()
        : Provider.of<AppData>(context).raw_material_list;

    final groups = groupBy(
      all_raw_materials,
      (e) => e.storeType,
    );

    grouped_list.clear();
    groups.forEach((key, value) {
      GroupedRawMaterialsModel val = GroupedRawMaterialsModel(
        category: key,
        rawMaterials: value,
      );
      grouped_list.add(val);
      setState(() {});
    });
  }

  List<GroupedRawMaterialsModel> group_list(List<RawMaterialsModel> _list) {
    List<GroupedRawMaterialsModel> group = [];
    final groups = groupBy(
      _list,
      (e) => e.category,
    );

    groups.forEach((key, value) {
      GroupedRawMaterialsModel val = GroupedRawMaterialsModel(
        category: key,
        rawMaterials: value,
      );
      group.add(val);
    });

    return group;
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

    // dialog
    if (width > 600) {
      return Dialog(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        child: Container(
          width: 600,
          height: 520,
          child: DefaultTabController(
            length: grouped_list.length,
            initialIndex: index,
            child: Column(
              children: [
                // top bar
                top_bar(),

                // content
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.only(bottom: 10, top: 8),
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
                    child: Container(
                      // padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          // search area
                          search_area(),

                          // list
                          Expanded(
                            child: grouped_list.isEmpty
                                ? Center(
                                    child: Text('No Raw Materials'),
                                  )
                                : page_view(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // scaffold
    return DefaultTabController(
      length: grouped_list.length,
      child: Scaffold(
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
                margin: EdgeInsets.only(top: 5),
                padding: EdgeInsets.only(bottom: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Container(
                  // padding: EdgeInsets.symmetric(vertical: 0),
                  child: Column(
                    children: [
                      // search area
                      search_area(),

                      // list
                      Expanded(
                        child: grouped_list.isEmpty
                            ? Center(
                                child: Text('No Raw Materials'),
                              )
                            : page_view(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGETS

  // top bar
  Widget top_bar() {
    double width = MediaQuery.of(context).size.width;
    var auth_staff = Provider.of<AppData>(context).active_staff;

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

              if (!restock_page)
                if (auth_staff!.fullaccess)
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: add_item_button(),
                  ),

              // search button
              if (!(width > 600))
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

              if (!(width > 600)) SizedBox(width: 10),
            ],
          ),

          // title
          Center(
            child: Text(
              restock_page ? 'Raw Material to Restock' : 'Raw Material List',
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
  Widget search_area() {
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
                setState(() {
                  restock_page = !restock_page;
                });
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
                    Icon(Icons.filter_list, color: Colors.white),
                    SizedBox(width: 5),
                    Text(restock_page ? 'Main List' : 'Restcok List',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),

          if (!search_open) SizedBox(width: 10),

          if (!search_open || (width > 600))
            Text(UniversalHelpers.format_number(all_raw_materials.length),
                style: TextStyle(fontSize: 12)),

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

  // page view
  Widget page_view() {
    return Container(
      child: Column(
        children: [
          // tabs
          tabs(),

          // tab view
          Expanded(
            child: TabBarView(
                children: grouped_list
                    .map((e) => tab_view(e.rawMaterials, e.category))
                    .toList()),
          ),
        ],
      ),
    );
  }

  // tabs
  Widget tabs() {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    return TabBar(
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
      tabs: grouped_list
          .map((e) => Tab(
              text:
                  '${e.category} - ${UniversalHelpers.format_number(e.rawMaterials.length)}'))
          .toList(),
    );
  }

  // tab view
  Widget tab_view(List<RawMaterialsModel> tab_list, String key) {
    var search_list = search(search_controller.text, tab_list);

    // search
    if (search_list.isNotEmpty) {
      var list = group_list(search_list);

      String kk = '${key}_search';
      return item_list(list, true, kk);
    }

    if (search_on && search_list.isEmpty) {
      return Center(
        child: Text('Item Not Found !!'),
      );
    }

    var list = group_list(tab_list);

    String kk = '${key}_main';
    return item_list(list, false, kk);
  }

  // item list
  Widget item_list(
      List<GroupedRawMaterialsModel> g_list, bool isExpanded, String key) {
    g_list.sort((a, b) => get_sort(a.category).compareTo(get_sort(b.category)));
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: g_list.map((e) {
            return ExpandableGroup(
              key: Key('${key}_${e.category}_${restock_page}'),
              isExpanded: isExpanded || restock_page,
              header: category_header(e.category),
              items: category_list(e.rawMaterials),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget category_header(String categoryName) {
    return Text(
      categoryName,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
    );
  }

  List<ListTile> category_list(List<RawMaterialsModel> _list) {
    _list.sort((a, b) => a.itemName.compareTo(b.itemName));
    return _list
        .map((e) => ListTile(
              minVerticalPadding: 0,
              minTileHeight: 0,
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              title: item_tile(e),
            ))
        .toList();
  }

  // item tile
  Widget item_tile(RawMaterialsModel item) {
    double width = MediaQuery.of(context).size.width;
    bool limit = item.quantity <= item.restockLimit;

    var auth_staff = Provider.of<AppData>(context).active_staff;

    return Container(
      decoration: BoxDecoration(
        color: !restock_page
            ? limit
                ? Colors.redAccent.withOpacity(.2)
                : null
            : null,
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          // name
          Expanded(
            child: Text(
              item.itemName,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),

          // qunatity
          Container(
            width: 70,
            child: Center(
              child: Text(
                UniversalHelpers.format_number(item.quantity),
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),

          // actions
          Container(
            width: (auth_staff!.fullaccess) ? 60 : 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // view/edit
                InkWell(
                  onTap: () {
                    if (width > 600) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AddUpdateRawMaterial(
                          item: item,
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddUpdateRawMaterial(
                            item: item,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Center(
                      child: Icon(Icons.info, size: 18),
                    ),
                  ),
                ),

                // delete
                if (!restock_page)
                  if (auth_staff.fullaccess)
                    InkWell(
                      onTap: () async {
                        bool? response = await UniversalHelpers.showConfirmBox(
                          context,
                          title: 'Delete Item',
                          subtitle:
                              'This would permanently remove this item from the database!\nWould you like to proceed?',
                        );

                        if (response != null && response == true) {
                          await MaterialStoreHelpers.delete_raw_materials(
                              context, item.key!);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: Center(
                          child: Icon(
                            Icons.delete,
                            size: 20,
                            color: Colors.red.shade400,
                          ),
                        ),
                      ),
                    ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // new item
  Widget add_item_button() {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        if (width > 600) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AddUpdateRawMaterial(),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUpdateRawMaterial(),
            ),
          );
        }
      },
      child: Icon(
        Icons.add,
        size: 22,
        color: Colors.white,
      ),
    );
  }

  // FUNCTIONS
// search items
  List<RawMaterialsModel> search(String value, List<RawMaterialsModel> _list) {
    if (value.trim().isNotEmpty) {
      search_on = true;
      return _list
          .where((item) =>
              item.itemName.toLowerCase().contains(value.toLowerCase()) ||
              item.category.toLowerCase().contains(value.toLowerCase()))
          .toList();
    } else {
      search_on = false;
      return [];
    }
  }

  // get sort
  int get_sort(
    String category,
  ) {
    var category_list = Provider.of<AppData>(context, listen: false)
        .raw_material_categories
        .where((e) => e.category == category);

    if (category_list.isNotEmpty)
      return category_list.first.sort;
    else
      return 1000;
  }

  //
}
