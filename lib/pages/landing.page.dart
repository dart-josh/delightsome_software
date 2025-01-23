import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/userModels/staff.model.dart';
import 'package:delightsome_software/globalvariables.dart';
import 'package:delightsome_software/pages/materialStorePages/enter_product_material_request.page.dart';
import 'package:delightsome_software/pages/materialStorePages/enter_raw_material_request.page.dart';
import 'package:delightsome_software/pages/materialStorePages/enter_restock_product_material.page.dart';
import 'package:delightsome_software/pages/materialStorePages/enter_restock_raw_material.page.dart';
import 'package:delightsome_software/pages/materialStorePages/product_material_list.page.dart';
import 'package:delightsome_software/pages/materialStorePages/raw_material_list.page.dart';
import 'package:delightsome_software/pages/productStorePages/enter_bad_product.page.dart';
import 'package:delightsome_software/pages/productStorePages/enter_product_received.page.dart';
import 'package:delightsome_software/pages/productStorePages/enter_product_request.page.dart';
import 'package:delightsome_software/pages/productStorePages/enter_production.page.dart';
import 'package:delightsome_software/pages/productStorePages/enter_terminalCollection.page.dart';
import 'package:delightsome_software/pages/productStorePages/product_list.page.dart';
import 'package:delightsome_software/pages/productStorePages/production_summary.page.dart';
import 'package:delightsome_software/pages/salePages/daily_sales_record.page.dart';
import 'package:delightsome_software/pages/salePages/enter_new_sale.page.dart';
import 'package:delightsome_software/pages/salePages/enter_new_terminal_sale.page.dart';
import 'package:delightsome_software/pages/salePages/sales_record.page.dart';
import 'package:delightsome_software/pages/salePages/sales_report.page.dart';
import 'package:delightsome_software/pages/salePages/terminal_daily_sales_record.page.dart';
import 'package:delightsome_software/pages/salePages/terminal_sales_record.page.dart';
import 'package:delightsome_software/pages/universalPages/category_list.page.dart';
import 'package:delightsome_software/pages/universalPages/sidebar.dart';
import 'package:delightsome_software/pages/userPages/customer_list.page.dart';
import 'package:delightsome_software/pages/userPages/staff_list.page.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  StaffModel? auth_staff;

  bool default_set = false;

  set_default_values() {
    if (default_set) return;

    Future.delayed(Duration(milliseconds: 400), () {
      double width = MediaQuery.of(context).size.width;
      Provider.of<AppData>(context, listen: false)
          .set_drawer_expanded((width > 800));
    });

    default_set = true;
  }

  @override
  Widget build(BuildContext context) {
    set_default_values();
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    auth_staff = Provider.of<AppData>(context).active_staff;

    return Scaffold(
      backgroundColor: isDarkTheme
          ? AppColors.dark_primaryBackgroundColor
          : AppColors.light_dialogBackground_3,
      body: SafeArea(
        child: Row(
          children: [
            // side bar
            SideBar(),

            // main page
            Expanded(
              child: Column(
                children: [
                  // top bar
                  top_bar(),

                  SizedBox(height: 20),

                  // menu items
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          // inventories
                          inventories(),

                          // shops
                          shops(),

                          // product_store_forms
                          product_store_forms(),

                          // material_store_forms
                          material_store_forms(),

                          // summaries
                          summaries(),

                          // utilities
                          utilities(),
                        ],
                      ),
                    ),
                  ),
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
  Widget top_bar() {
    bool isCollapsed = !Provider.of<AppData>(context).drawer_expanded;

    return Container(
      height: 90,
      width: double.infinity,
      color: Colors.blue,
      child: Stack(
        children: [
          Positioned.fill(
              child: Container(
            color: Colors.black38,
          )),

          // nickname
          Container(
            padding: EdgeInsets.only(left: !isCollapsed ? 10 : 0),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  auth_staff?.nickName ?? '',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                if (isCollapsed) // role
                  Text(
                    auth_staff!.role.toUpperCase(),
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //?

  // inventories
  Widget inventories() {
    Color product_store_color = Color.fromARGB(57, 151, 227, 157);
    Color p_material_store_color = Color.fromARGB(57, 227, 222, 151);
    Color r_material_store_color = Color.fromARGB(57, 148, 126, 69);
    Color terminal_color = Color.fromARGB(57, 151, 186, 227);

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // head
          section_head(
            title: 'Inventory',
            isExpanded: inventories_expanded,
            onClicked: () {
              setState(() {
                inventories_expanded = !inventories_expanded;
              });
            },
          ),

          // list
          if (inventories_expanded)
            Container(
              height: 110,
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: ListView(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  // product list
                  if (auth_staff!.role != 'Terminal')
                  menu_tile(
                    icon: FontAwesomeIcons.productHunt,
                    title: 'Products',
                    color: product_store_color,
                    onClicked: () {
                      goto_page(
                        dialog: null,
                        page: ProductListPage(
                          page: 'product',
                        ),
                      );
                    },
                  ),

                  // terminal product list
                  if (auth_staff!.role != 'Production')
                  menu_tile(
                    icon: FontAwesomeIcons.productHunt,
                    title: 'Terminal Products',
                    color: terminal_color,
                    onClicked: () {
                      goto_page(
                        dialog: null,
                        page: ProductListPage(
                          page: 'terminal_product',
                        ),
                      );
                    },
                  ),

                  // product material list
                  if (auth_staff!.role != 'Terminal')
                  menu_tile(
                    icon: FontAwesomeIcons.toolbox,
                    title: 'Product Materials',
                    color: p_material_store_color,
                    onClicked: () {
                      goto_page(dialog: null, page: ProductMaterialListPage());
                    },
                  ),

                  // raw material list
                  if (auth_staff!.role != 'Terminal')
                  menu_tile(
                    icon: FontAwesomeIcons.leaf,
                    title: 'Raw Materials',
                    color: r_material_store_color,
                    onClicked: () {
                      goto_page(
                        dialog: null,
                        page: RawMaterialListPage(),
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // shops
  Widget shops() {
    Color outlet_color = Color.fromARGB(57, 217, 151, 227);
    Color terminal_color = Color.fromARGB(57, 151, 186, 227);

    if (auth_staff!.role == 'Production') return Container();

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // head
          section_head(
            title: 'Shop',
            isExpanded: shops_expanded,
            onClicked: () {
              setState(() {
                shops_expanded = !shops_expanded;
              });
            },
          ),

          // list
          if (shops_expanded)
            Container(
              height: 110,
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: ListView(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  // outlet shop
                  if (auth_staff!.role != 'Production' && auth_staff!.role != 'Terminal')
                  menu_tile(
                    icon: FontAwesomeIcons.shop,
                    title: 'Outlet Store',
                    color: outlet_color,
                    show_not: Provider.of<AppData>(context).outlet_shops.isNotEmpty,
                    onClicked: () {
                      goto_page(dialog: false, page: SalesPage());
                    },
                  ),

                  // outlet sales record
                  if (auth_staff!.role != 'Production' && auth_staff!.role != 'Terminal')
                  menu_tile(
                    icon: FontAwesomeIcons.solidRectangleList,
                    title: 'Outlet Store Record',
                    color: outlet_color,
                    onClicked: () {
                      goto_page(dialog: false, page: SalesRecordPage());
                    },
                  ),

                  // terminal shop
                  if (auth_staff!.role != 'Production' && auth_staff!.role != 'Sales')
                  menu_tile(
                    icon: FontAwesomeIcons.store,
                    title: 'Terminal Store',
                    color: terminal_color,
                    show_not: Provider.of<AppData>(context).terminal_shops.isNotEmpty,
                    onClicked: () {
                      goto_page(dialog: false, page: TerminalSalesPage());
                    },
                  ),

                  // terminal sales record
                  if (auth_staff!.role != 'Production' && auth_staff!.role != 'Sales')
                  menu_tile(
                    icon: FontAwesomeIcons.rectangleList,
                    title: 'Terminal Store Record',
                    color: terminal_color,
                    onClicked: () {
                      goto_page(dialog: false, page: TerminalSalesRecordPage());
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // product_store_forms
  Widget product_store_forms() {
    Color product_store_color = Color.fromARGB(57, 151, 227, 157);
    Color terminal_color = Color.fromARGB(57, 151, 186, 227);
    Color bad_product_color = Color.fromARGB(77, 234, 132, 132);

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // head
          section_head(
            title: 'Product Store',
            isExpanded: product_store_forms_expanded,
            onClicked: () {
              setState(() {
                product_store_forms_expanded = !product_store_forms_expanded;
              });
            },
          ),

          // list
          if (product_store_forms_expanded)
            Container(
              height: 110,
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: ListView(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  // production form
                  if (auth_staff!.role != 'Terminal')
                  menu_tile(
                    icon: FontAwesomeIcons.blender,
                    title: 'Enter Production',
                    color: product_store_color,
                    show_not: saved_production_model != null,
                    onClicked: () {
                      goto_page(
                        dialog: null,
                        page: EnterProductionPage(
                          editModel: saved_production_model,
                        ),
                      );
                    },
                  ),

                  // product received form
                  if (auth_staff!.role != 'Terminal' && auth_staff!.role != 'Production')
                  menu_tile(
                    icon: FontAwesomeIcons.appleWhole,
                    title: 'Enter Product Received',
                    color: product_store_color,
                    show_not: saved_product_received_model != null,
                    onClicked: () {
                      goto_page(
                        dialog: null,
                        page: EnterProductReceivedPage(
                          editModel: saved_product_received_model,
                        ),
                      );
                    },
                  ),

                  // product request form
                  if (auth_staff!.role != 'Terminal')
                  menu_tile(
                    icon: FontAwesomeIcons.basketShopping,
                    title: 'Enter Product Request',
                    color: product_store_color,
                    show_not: saved_product_request_model != null,
                    onClicked: () {
                      goto_page(
                        dialog: null,
                        page: EnterProductRequestPage(
                          editModel: saved_product_request_model,
                        ),
                      );
                    },
                  ),

                  // terminal collection form
                  if (auth_staff!.role != 'Production')
                  menu_tile(
                    icon: FontAwesomeIcons.store,
                    title: 'Enter Terminal Collection',
                    color: terminal_color,
                    show_not: (saved_terminal_collected_model != null ||
                        saved_terminal_returned_model != null),
                    onClicked: () async {
                      var collectionType = await showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: Container(
                            width: 300,
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Select Collection Type'),
                                SizedBox(height: 20),
                                Row(
                                  children: ['Collected', 'Returned']
                                      .map(
                                        (e) => TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, e);
                                            },
                                            child: Text(e)),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );

                      if (collectionType != null) {
                        goto_page(
                          dialog: null,
                          page: EnterTerminalcollectionPage(
                            editModel: (collectionType == 'Collected')
                                ? saved_terminal_collected_model
                                : saved_terminal_returned_model,
                            collectionType: collectionType,
                          ),
                        );
                      }
                    },
                  ),

                  // bad product form
                  if (auth_staff!.role != 'Terminal')
                  menu_tile(
                    icon: FontAwesomeIcons.trashArrowUp,
                    title: 'Enter Bad Product',
                    color: bad_product_color,
                    show_not: saved_bad_product_model != null,
                    onClicked: () {
                      goto_page(
                        dialog: null,
                        page: EnterBadProductPage(
                          editModel: saved_bad_product_model,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // material_store_forms
  Widget material_store_forms() {
    Color p_material_store_color = Color.fromARGB(57, 227, 222, 151);
    Color r_material_store_color = Color.fromARGB(57, 148, 126, 69);

    if (auth_staff!.role == 'Terminal') return Container();

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // head
          section_head(
            title: 'Material Store',
            isExpanded: material_store_expanded,
            onClicked: () {
              setState(() {
                material_store_expanded = !material_store_expanded;
              });
            },
          ),

          // list
          if (material_store_expanded)
            Container(
              height: 110,
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: ListView(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  // restock product material
                  if (auth_staff!.role != 'Sales' && auth_staff!.role != 'Terminal')
                  menu_tile(
                    icon: FontAwesomeIcons.codeCompare,
                    title: 'Restock Product Material',
                    color: p_material_store_color,
                    show_not: saved_restock_product_material_model != null,
                    onClicked: () {
                      goto_page(
                        dialog: null,
                        page: EnterRestockProductMaterial(
                          editModel: saved_restock_product_material_model,
                        ),
                      );
                    },
                  ),

                  // restock raw material
                  if (auth_staff!.role != 'Sales' && auth_staff!.role != 'Terminal')
                  menu_tile(
                    icon: FontAwesomeIcons.repeat,
                    title: 'Restock Raw Material',
                    color: r_material_store_color,
                    show_not: saved_restock_raw_material_model != null,
                    onClicked: () {
                      goto_page(
                        dialog: null,
                        page: EnterRestockRawMaterial(
                          editModel: saved_restock_raw_material_model,
                        ),
                      );
                    },
                  ),

                  // product material request
                  if (auth_staff!.role != 'Terminal')
                  menu_tile(
                    icon: FontAwesomeIcons.toolbox,
                    title: 'Product Material Request',
                    color: p_material_store_color,
                    show_not: saved_product_material_request_model != null,
                    onClicked: () {
                      goto_page(
                        dialog: null,
                        page: EnterProductMaterialRequest(
                          editModel: saved_product_material_request_model,
                        ),
                      );
                    },
                  ),

                  // raw material request
                  if (auth_staff!.role != 'Terminal')
                  menu_tile(
                    icon: FontAwesomeIcons.leaf,
                    title: 'Raw Material Request',
                    color: r_material_store_color,
                    show_not: saved_raw_material_request_model != null,
                    onClicked: () {
                      goto_page(
                        dialog: null,
                        page: EnterRawMaterialRequest(
                          editModel: saved_raw_material_request_model,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // summaries
  Widget summaries() {
    Color outlet_color = Color.fromARGB(57, 217, 151, 227);
    Color product_store_color = Color.fromARGB(57, 151, 227, 157);
    Color terminal_color = Color.fromARGB(57, 151, 186, 227);

    if (auth_staff!.role == 'Production') return Container();

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // head
          section_head(
            title: 'Summary',
            isExpanded: summaries_expanded,
            onClicked: () {
              setState(() {
                summaries_expanded = !summaries_expanded;
              });
            },
          ),

          // list
          if (summaries_expanded)
            Container(
              height: 110,
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: ListView(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  // sales report
                  if (auth_staff!.role != 'Production' && auth_staff!.role != 'Terminal')
                  menu_tile(
                    icon: FontAwesomeIcons.cashRegister,
                    title: 'Sales Report',
                    color: outlet_color,
                    onClicked: () {
                      goto_page(
                        dialog: false,
                        page: SalesReportPage(),
                      );
                    },
                  ),

                  // production summary
                  if (auth_staff!.role != 'Production' && auth_staff!.role != 'Terminal')
                  menu_tile(
                    icon: FontAwesomeIcons.microchip,
                    title: 'Production Report',
                    color: product_store_color,
                    onClicked: () {
                      goto_page(
                        dialog: null,
                        page: ProductionSummaryPage(),
                      );
                    },
                  ),

                  // outlet product record
                  if (auth_staff!.role != 'Production' && auth_staff!.role != 'Terminal')
                  menu_tile(
                    icon: FontAwesomeIcons.book,
                    title: 'Outlet Daily Record',
                    color: outlet_color,
                    onClicked: () {
                      goto_page(dialog: false, page: DailySalesRecordPage());
                    },
                  ),

                  // terminal product record
                  if (auth_staff!.role != 'Production' && auth_staff!.role != 'Sales')
                  menu_tile(
                    icon: FontAwesomeIcons.book,
                    title: 'Terminal Daily Record',
                    color: terminal_color,
                    onClicked: () {
                      goto_page(
                        dialog: false,
                        page: TerminalDailySalesRecordPage(),
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // utilities
  Widget utilities() {
    Color staff_color = Color.fromARGB(57, 151, 184, 227);
    Color customer_color = Color.fromARGB(57, 151, 227, 222);
    Color category_color = Color.fromARGB(57, 145, 188, 223);

    if (auth_staff!.role == 'Production') return Container();

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // head
          section_head(
            title: 'Utility',
            isExpanded: utilities_expanded,
            onClicked: () {
              setState(() {
                utilities_expanded = !utilities_expanded;
              });
            },
          ),

          // list
          if (utilities_expanded)
            Container(
              height: 110,
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: ListView(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  // staff list
                  if (auth_staff!.role != 'Production' && auth_staff!.role != 'Sales' && auth_staff!.role != 'Terminal')
                  menu_tile(
                    icon: FontAwesomeIcons.userTie,
                    title: 'Staffs',
                    color: staff_color,
                    onClicked: () {
                      goto_page(
                        dialog: true,
                        page: StaffListPage(),
                      );
                    },
                  ),

                  // customer list
                  if (auth_staff!.role != 'Production')
                  menu_tile(
                    icon: FontAwesomeIcons.usersLine,
                    title: 'Customers',
                    color: customer_color,
                    onClicked: () {
                      goto_page(
                        dialog: true,
                        page: CustomerListPage(),
                      );
                    },
                  ),

                  // categories
                  if (auth_staff!.role != 'Production' && auth_staff!.role != 'Sales' && auth_staff!.role != 'Terminal')
                  menu_tile(
                    icon: FontAwesomeIcons.layerGroup,
                    title: 'Store Categories',
                    color: category_color,
                    onClicked: () {
                      goto_page(dialog: true, page: CategoryListPage());
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  //?

  // section head
  Widget section_head({
    required String title,
    required bool isExpanded,
    required VoidCallback? onClicked,
  }) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    double width = MediaQuery.of(context).size.width;

    bool isCollapsed = !Provider.of<AppData>(context).drawer_expanded;

    bool hide_title = width < 500 && !isCollapsed;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.symmetric(
        horizontal: BorderSide(
          color: isDarkTheme
              ? AppColors.dark_borderColor
              : AppColors.light_borderColor,
        ),
      )),
      height: 35,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // title
          if (!hide_title)
            InkWell(
              onTap: onClicked,
              child: Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 16, letterSpacing: .7),
              ),
            ),

          // expand icon
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onClicked,
              child: Container(
                height: 30,
                width: 30,
                child: Center(
                  child: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: isDarkTheme
                        ? AppColors.dark_secondaryTextColor
                        : AppColors.light_secondaryTextColor,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // menu tile
  Widget menu_tile({
    required IconData icon,
    required String title,
    double height = 80,
    double width = 140,
    required Color color,
    required VoidCallback? onClicked,
    bool show_not = false,
  }) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onClicked,
          child: Stack(
            children: [
              // item
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                        color: isDarkTheme
                            ? AppColors.dark_dimTextColor
                            : AppColors.light_dimTextColor),
                    color: color,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(1, 1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        color: isDarkTheme ? Colors.white24 : Colors.black26,
                      ),
                    ]),
                margin: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                padding: EdgeInsets.fromLTRB(2, 5, 2, 5),
                width: width,
                height: height,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FaIcon(icon, size: 20),
                      SizedBox(height: 12),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          height: .9,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // notification
              if (show_not)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // FUNCTIONS
  goto_page(
      {required bool? dialog,
      required Widget page,
      bool dismiss_dialog = false}) async {
    double width = MediaQuery.of(context).size.width;

    if (dialog == null) {
      if (width > 600) {
        await showDialog(
          context: context,
          barrierDismissible: dismiss_dialog,
          builder: (context) => page,
        );
      } else {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
      }
    } else if (dialog) {
      await showDialog(
        context: context,
        barrierDismissible: dismiss_dialog,
        builder: (context) => page,
      );
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );
    }

    setState(() {});
  }

  //
}
