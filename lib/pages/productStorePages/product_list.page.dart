import 'package:collection/collection.dart';
import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/productStoreModels/product.model.dart';
import 'package:delightsome_software/helpers/productStoreHelpers.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/pages/productStorePages/add_update_product.page.dart';
import 'package:delightsome_software/pages/productStorePages/widgets/product_selector.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:expandable_group/expandable_group_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListPage extends StatefulWidget {
  final String page;
  const ProductListPage({super.key, required this.page});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  TextEditingController search_controller = TextEditingController();
  FocusNode searchNode = FocusNode();

  List<ProductModel> all_product = [];

  List<GroupedProductModel> grouped_list = [];
  List<GroupedProductModel> search_list = [];

  bool search_on = false;
  bool search_open = false;

  bool restock_page = false;

  get_products() {
    if (widget.page == 'terminal_product') {
      all_product = (restock_page)
          ? Provider.of<AppData>(context)
              .terminal_product_list
              .where((e) => e.quantity <= e.restockLimit)
              .toList()
          : Provider.of<AppData>(context).terminal_product_list;
    } else if (widget.page == 'dangote_product') {
      all_product = (restock_page)
          ? Provider.of<AppData>(context)
              .dangote_product_list
              .where((e) => e.quantity <= e.restockLimit)
              .toList()
          : Provider.of<AppData>(context).dangote_product_list;
    } else {
      all_product = (restock_page)
          ? Provider.of<AppData>(context)
              .product_list
              .where((e) => e.quantity <= e.restockLimit)
              .toList()
          : Provider.of<AppData>(context).product_list;
    }

    final groups = groupBy(
      all_product,
      (e) => (e.category.isNotEmpty) ? e.category : 'unkwown',
    );

    grouped_list.clear();
    groups.forEach((key, value) {
      GroupedProductModel val = GroupedProductModel(
        category: key,
        productMaterials: value,
      );
      grouped_list.add(val);
      setState(() {});
    });

    if (search_on) search(search_controller.text);
  }

  @override
  void dispose() {
    search_controller.dispose();
    searchNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    get_products();

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
                          child: (search_on && search_list.isEmpty)
                              ? Center(
                                  child: Text('Product Not Found'),
                                )
                              : search_on
                                  ? product_list(search_list, true, 'search')
                                  : grouped_list.isNotEmpty
                                      ? product_list(
                                          grouped_list, false, 'main')
                                      : Center(
                                          child: Text('No Products'),
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

    // scaffold
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
                      child: (search_on && search_list.isEmpty)
                          ? Center(
                              child: Text('Product Not Found'),
                            )
                          : search_on
                              ? product_list(search_list, true, 'search')
                              : grouped_list.isNotEmpty
                                  ? product_list(grouped_list, false, 'main')
                                  : Center(
                                      child: Text('No Products'),
                                    ),
                    ),
                  ],
                ),
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

              if (!restock_page &&
                  (widget.page != 'terminal_product') &&
                  (widget.page != 'dangote_product'))
                if (auth_staff!.fullaccess)
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: add_product_button(),
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
              (widget.page == 'terminal_product')
                  ? 'Terminal Products'
                  : (widget.page == 'dangote_product')
                      ? 'Dangote Products'
                      : restock_page
                          ? 'Products to Restock'
                          : 'Product List',
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

  // product selection
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
            Text(UniversalHelpers.format_number(all_product.length),
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
                onChanged: search,
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

  // product list
  Widget product_list(
      List<GroupedProductModel> g_list, bool isExpanded, String key) {
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
              items: category_list(e.productMaterials),
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

  List<ListTile> category_list(List<ProductModel> _list) {
    _list.sort((a, b) => a.name.compareTo(b.name));
    return _list
        .map((e) => ListTile(
              minVerticalPadding: 0,
              minTileHeight: 0,
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              title: product_tile(e),
            ))
        .toList();
  }

  // product tile
  Widget product_tile(ProductModel product) {
    double width = MediaQuery.of(context).size.width;
    bool limit = product.quantity <= product.restockLimit;

    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    var auth_staff = Provider.of<AppData>(context).active_staff;

    Color text_color = isDarkTheme
        ? product.isAvailable
            ? Colors.white
            : AppColors.dark_dimTextColor
        : product.isAvailable
            ? Colors.black
            : AppColors.light_dimTextColor;

    return Container(
      decoration: BoxDecoration(
        color: !restock_page
            ? limit && product.isAvailable
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
              product.name,
              style: TextStyle(
                fontSize: 16,
                color: text_color,
              ),
            ),
          ),

          // store price
          Container(
            width: 90,
            child: Center(
              child: Text(
                UniversalHelpers.format_number(
                  product.storePrice,
                  currency: true,
                ),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: text_color,
                ),
              ),
            ),
          ),

          // qunatity
          if (width > 600)
            Container(
              width: 70,
              child: Center(
                child: Text(
                  UniversalHelpers.format_number(
                    product.quantity,
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: text_color,
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
                        builder: (context) => AddUpdateProduct(
                          product: product,
                          page: widget.page,
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddUpdateProduct(
                            product: product,
                            page: widget.page,
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
                if (!restock_page && (widget.page != 'terminal_product') && (widget.page != 'dangote_product'))
                  if (auth_staff.fullaccess)
                    InkWell(
                      onTap: () async {
                        bool? response = await UniversalHelpers.showConfirmBox(
                          context,
                          title: 'Delete Product',
                          subtitle:
                              'This would permanently remove this product from the database!\nWould you like to proceed?',
                        );

                        if (response != null && response == true) {
                          await ProductStoreHelpers.delete_product(
                              context, product.key!);
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

  // new product
  Widget add_product_button() {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        if (width > 600) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AddUpdateProduct(
              page: widget.page,
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUpdateProduct(
                page: widget.page,
              ),
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
  // search products
  void search(String value) {
    if (value.trim().isNotEmpty) {
      search_on = true;
      var _search = all_product
          .where((product) =>
              product.name.toLowerCase().contains(value.toLowerCase()) ||
              product.category.toLowerCase().contains(value.toLowerCase()) ||
              product.code.toLowerCase().contains(value.toLowerCase()))
          .toList();

      search_list.clear();

      if (_search.isNotEmpty) {
        final groups = groupBy(
          _search,
          (e) => (e.category.isNotEmpty) ? e.category : 'unkwown',
        );

        groups.forEach((key, value) {
          GroupedProductModel val = GroupedProductModel(
            category: key,
            productMaterials: value,
          );
          search_list.add(val);
          setState(() {});
        });
      }
    } else {
      search_on = false;
      search_list.clear();
    }

    setState(() {});
  }

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
