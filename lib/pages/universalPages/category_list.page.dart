import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/category.model.dart';
import 'package:delightsome_software/globalvariables.dart';
import 'package:delightsome_software/helpers/materialStoreHelpers.dart';
import 'package:delightsome_software/helpers/productStoreHelpers.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/pages/universalPages/manage_category.page.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  TextEditingController search_controller = TextEditingController();
  FocusNode search_node = FocusNode();

  List<CategoryModel> product_material_category = [];
  List<CategoryModel> raw_material_category = [];
  List<CategoryModel> product_category = [];

  bool search_on = false;
  bool search_open = false;

  int index = 0;

  get_categories() {
    product_material_category =
        Provider.of<AppData>(context).product_material_categories;
    raw_material_category =
        Provider.of<AppData>(context).raw_material_categories;
    product_category = Provider.of<AppData>(context).product_categories;
  }

  @override
  void dispose() {
    search_controller.dispose();
    search_node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    get_categories();

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
            length: 3,
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

                          // tabs
                          tabs(),

                          // list
                          Expanded(
                            child: TabBarView(
                              children: [
                                item_list(product_material_category),
                                item_list(raw_material_category),
                                item_list(product_category),
                              ],
                            ),
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
      length: 3,
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

                      // tabs
                      tabs(),

                      // list
                      Expanded(
                        child: TabBarView(
                          children: [
                            item_list(product_material_category),
                            item_list(raw_material_category),
                            item_list(product_category),
                          ],
                        ),
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

              if (activeStaff!.fullaccess)
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
                    } else {
                      Future.delayed(Duration(milliseconds: 300), () {
                        FocusScope.of(context).requestFocus(search_node);
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
              'Category List',
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
      tabs: [
        Tab(text: 'Product Material Store'),
        Tab(text: 'Raw Material Store'),
        Tab(text: 'Product Store'),
      ],
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
                focusNode: search_node,
                style: TextStyle(
                  color: isDarkTheme
                      ? AppColors.dark_primaryTextColor
                      : AppColors.light_primaryTextColor,
                ),
                onChanged: (_) {
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

  // item list
  Widget item_list(List<CategoryModel> _list) {
    _list.sort((a, b) => a.sort.compareTo(b.sort));

    var search_list = search(search_controller.text, _list);

    // search
    if (search_list.isNotEmpty) {
      return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: search_list.map((e) {
              return item_tile(e);
            }).toList(),
          ),
        ),
      );
    }

    if (search_on && search_list.isEmpty) {
      return Center(
        child: Text('Category Not Found !!'),
      );
    }

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _list.map((e) {
            return item_tile(e);
          }).toList(),
        ),
      ),
    );
  }

  // item tile
  Widget item_tile(CategoryModel category) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          // name
          Expanded(
            child: Text(
              category.category,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),

          // qunatity
          Container(
            width: 80,
            child: Center(
              child: Text(
                UniversalHelpers.format_number(category.sort),
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),

          // actions
          Container(
            width: (width > 600) ? 150 : 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // view/edit
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => ManageCategory(
                        category: category,
                        category_type: category_type_list[index],
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Center(
                      child: Icon(Icons.info, size: 18),
                    ),
                  ),
                ),

                // delete
                if (activeStaff!.fullaccess)
                  InkWell(
                    onTap: () async {
                      bool? response = await UniversalHelpers.showConfirmBox(
                        context,
                        title: 'Delete Category',
                        subtitle:
                            'This would permanently remove this category from the database!\nWould you like to proceed?',
                      );

                      if (response != null && response == true) {
                        // product material store
                        if (index == 0) {
                          await MaterialStoreHelpers
                              .delete_product_materials_category(
                                  context, category.key!);
                        }

                        // raw material store
                        if (index == 1) {
                          await MaterialStoreHelpers
                              .delete_raw_materials_category(
                                  context, category.key!);
                        }

                        // product store
                        if (index == 2) {
                          await ProductStoreHelpers.delete_product_category(
                              context, category.key!);
                        }
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
          ),
        ],
      ),
    );
  }

  // new item
  Widget add_item_button() {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => ManageCategory(),
        );
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
  List<CategoryModel> search(String value, List<CategoryModel> _list) {
    if (value.isNotEmpty) {
      search_on = true;
      return _list
          .where((item) =>
              item.category.toLowerCase().contains(value.toLowerCase()))
          .toList();
    } else {
      search_on = false;
      return [];
    }
  }
  //
}
