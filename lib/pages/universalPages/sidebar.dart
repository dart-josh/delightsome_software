import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/userModels/staff.model.dart';
import 'package:delightsome_software/helpers/authHelpers.dart';
import 'package:delightsome_software/helpers/serverHelpers.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/pages/login.page.dart';
import 'package:delightsome_software/pages/materialStorePages/product_material_request_record.page.dart';
import 'package:delightsome_software/pages/materialStorePages/product_material_return_record.page.dart';
import 'package:delightsome_software/pages/materialStorePages/raw_material_request_record.page.dart';
import 'package:delightsome_software/pages/materialStorePages/restock_product_material_record.page.dart';
import 'package:delightsome_software/pages/materialStorePages/restock_raw_material_record.page.dart';
import 'package:delightsome_software/pages/productStorePages/bad_product_record.page.dart';
import 'package:delightsome_software/pages/productStorePages/product_received_record.page.dart';
import 'package:delightsome_software/pages/productStorePages/product_request_record.page.dart';
import 'package:delightsome_software/pages/productStorePages/product_return_record.page.dart';
import 'package:delightsome_software/pages/productStorePages/product_takeOut_record.page.dart';
import 'package:delightsome_software/pages/productStorePages/production_record.page.dart';
import 'package:delightsome_software/pages/productStorePages/terminal_collection_record.page.dart';
import 'package:delightsome_software/pages/productStorePages/dangote_collection_record.page.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SideBar extends StatefulWidget {
  final bool show_header;
  const SideBar({super.key, this.show_header = true});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int production_rec = 0;
  int productReceived_rec = 0;
  int productRequest_rec = 0;
  int productTakeOut_rec = 0;
  int productReturn_rec = 0;
  int terminalCollection_rec = 0;
  int dangoteCollection_rec = 0;
  int badProduct_rec = 0;

  int restockProductMaterial_rec = 0;
  int restockRawMaterial_rec = 0;
  int productMaterialRequest_rec = 0;
  int rawMaterialRequest_rec = 0;
  int productMaterialReturn_rec = 0;

  List<SidebarItemModel> product_store_items = [];

  List<SidebarItemModel> material_store_items = [];

  assign_records() {
    product_store_items.clear();
    material_store_items.clear();

    StaffModel? auth_staff = Provider.of<AppData>(context).active_staff;

    if (auth_staff!.role != 'Terminal')
      // production record
      product_store_items.add(
        SidebarItemModel(
          title: 'Production Record',
          icon: FontAwesomeIcons.blender,
          key: 0,
        ),
      );

    if (auth_staff.role != 'Terminal' && auth_staff.role != 'Production')
      // product received
      product_store_items.add(
        SidebarItemModel(
          title: 'Product Received',
          icon: FontAwesomeIcons.appleWhole,
          key: 1,
        ),
      );

    if (auth_staff.role != 'Terminal')
      // product request
      product_store_items.add(
        SidebarItemModel(
          title: 'Product Request',
          icon: FontAwesomeIcons.basketShopping,
          key: 2,
        ),
      );

    if (auth_staff.role != 'Production')
      // terminal collection
      product_store_items.add(
        SidebarItemModel(
          title: 'Terminal Collection',
          icon: FontAwesomeIcons.store,
          key: 3,
        ),
      );

    if (auth_staff.role != 'Production')
      // dangote collection
      product_store_items.add(
        SidebarItemModel(
          title: 'Dangote Collection',
          icon: FontAwesomeIcons.store,
          key: 12,
        ),
      );

    if (auth_staff.role != 'Terminal' && auth_staff.role != 'Production')
      // product takeOut
      product_store_items.add(
        SidebarItemModel(
          title: 'Product TakeOut',
          icon: FontAwesomeIcons.appleWhole,
          key: 10,
        ),
      );

    if (auth_staff.role != 'Terminal' && auth_staff.role != 'Production')
      // product return
      product_store_items.add(
        SidebarItemModel(
          title: 'Product Return',
          icon: FontAwesomeIcons.appleWhole,
          key: 11,
        ),
      );

    if (auth_staff.role != 'Terminal')
      // bad product
      product_store_items.add(
        SidebarItemModel(
          title: 'Bad Product Record',
          icon: FontAwesomeIcons.trashArrowUp,
          key: 4,
        ),
      );

    //?

    if (auth_staff.role != 'Terminal' && auth_staff.role != 'Sales')
      // restock product material
      material_store_items.add(
        SidebarItemModel(
          title: 'Restock Product Material',
          icon: FontAwesomeIcons.codeCompare,
          key: 5,
        ),
      );

    if (auth_staff.role != 'Terminal' && auth_staff.role != 'Sales')
      // restock raw material
      material_store_items.add(
        SidebarItemModel(
          title: 'Restock Raw Material',
          icon: FontAwesomeIcons.repeat,
          key: 6,
        ),
      );

    if (auth_staff.role != 'Terminal')
      // product material request
      material_store_items.add(
        SidebarItemModel(
          title: 'Product Material Request',
          icon: FontAwesomeIcons.toolbox,
          key: 7,
        ),
      );

    if (auth_staff.role != 'Terminal')
      // raw material request
      material_store_items.add(
        SidebarItemModel(
          title: 'Raw Material Request',
          icon: FontAwesomeIcons.leaf,
          key: 8,
        ),
      );

    if (auth_staff.role != 'Terminal')
      // product material return
      material_store_items.add(
        SidebarItemModel(
          title: 'Product Material Return',
          icon: FontAwesomeIcons.toolbox,
          key: 9,
        ),
      );

    fecth_pending_records();
  }

  fecth_pending_records() {
    production_rec = Provider.of<AppData>(context)
        .production_record
        .where((rec) => !rec.verified!)
        .length;

    productReceived_rec = Provider.of<AppData>(context)
        .product_received_record
        .where((rec) => !rec.verified!)
        .length;

    productRequest_rec = Provider.of<AppData>(context)
        .product_request_record
        .where((rec) => !rec.verified!)
        .length;

    terminalCollection_rec = Provider.of<AppData>(context)
        .terminal_collection_record
        .where((rec) => !rec.verified!)
        .length;

    dangoteCollection_rec = Provider.of<AppData>(context)
        .dangote_collection_record
        .where((rec) => !rec.verified!)
        .length;

    productTakeOut_rec = Provider.of<AppData>(context)
        .product_takeOut_record
        .where((rec) => !rec.verified!)
        .length;

    productReturn_rec = Provider.of<AppData>(context)
        .product_return_record
        .where((rec) => !rec.verified!)
        .length;

    badProduct_rec = Provider.of<AppData>(context)
        .bad_product_record
        .where((rec) => !rec.verified!)
        .length;

    //?

    restockProductMaterial_rec = Provider.of<AppData>(context)
        .restock_product_material_record
        .where((rec) => !rec.verified!)
        .length;

    restockRawMaterial_rec = Provider.of<AppData>(context)
        .restock_raw_material_record
        .where((rec) => !rec.verified!)
        .length;

    productMaterialRequest_rec = Provider.of<AppData>(context)
        .product_material_request_record
        .where((rec) => !rec.authorized!)
        .length;

    rawMaterialRequest_rec = Provider.of<AppData>(context)
        .raw_material_request_record
        .where((rec) => !rec.authorized!)
        .length;

    productMaterialReturn_rec = Provider.of<AppData>(context)
        .product_material_return_record
        .where((rec) => !rec.authorized!)
        .length;
  }

  int get_not_byIndex(int index) {
    switch (index) {
      case 0:
        return production_rec;
      case 1:
        return productReceived_rec;
      case 2:
        return productRequest_rec;
      case 3:
        return terminalCollection_rec;
      case 4:
        return badProduct_rec;
      case 5:
        return restockProductMaterial_rec;
      case 6:
        return restockRawMaterial_rec;
      case 7:
        return productMaterialRequest_rec;
      case 8:
        return rawMaterialRequest_rec;
      case 9:
        return productMaterialReturn_rec;
      case 10:
        return productTakeOut_rec;
      case 11:
        return productReturn_rec;
      case 12:
        return dangoteCollection_rec;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    bool isCollapsed = !Provider.of<AppData>(context).drawer_expanded;

    assign_records();

    return Container(
      width: isCollapsed
          ? 60
          : width > 800
              ? 300
              : 280,
      // padding: EdgeInsets.only(top: 60),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Column(
          children: [
            // header
            if (widget.show_header) buildHeader(isCollapsed),

            Expanded(
              child: sidebar_content(),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGETS

  // sidebar content
  Widget sidebar_content() {
    bool isCollapsed = !Provider.of<AppData>(context).drawer_expanded;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.3, 0.7, 1.0],
          colors: [
            Color.fromRGBO(23, 93, 151, 1),
            Color.fromRGBO(237, 110, 55, .8),
            Color.fromRGBO(43, 123, 60, .8),
            Color.fromRGBO(23, 93, 151, 1),
          ],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),

          Expanded(
            child:
                buildList(items: product_store_items, isCollapsed: isCollapsed),
          ),

          const SizedBox(height: 10),
          Divider(color: Colors.white70),
          const SizedBox(height: 10),

          Expanded(
            child: buildList(
              indexOffset: product_store_items.length,
              items: material_store_items,
              isCollapsed: isCollapsed,
            ),
          ),

          SizedBox(height: 10),

          if (!isCollapsed) bottom_bar(),

          // bottom
          if (isCollapsed)
            buildCollapseIcon(context, isCollapsed: isCollapsed)
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // change theme
                buildThemeButton(),

                // toggle button
                buildCollapseIcon(context, isCollapsed: isCollapsed),
              ],
            ),
        ],
      ),
    );
  }

  // list
  Widget buildList({
    required bool isCollapsed,
    required List<SidebarItemModel> items,
    int indexOffset = 0,
  }) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      primary: false,
      itemCount: items.length,
      separatorBuilder: (context, index) => SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = items[index];

        return buildMenuItem(
          isCollapsed: isCollapsed,
          text: item.title,
          icon: item.icon,
          onClicked: () => selectItem(context, item.key),
          not_count: get_not_byIndex(item.key),
        );
      },
    );
  }

  // tile
  Widget buildMenuItem({
    required bool isCollapsed,
    required IconData icon,
    required String text,
    required VoidCallback? onClicked,
    required int not_count,
  }) {
    Widget not = not_count == 0
        ? Container(
            height: 17,
            width: 17,
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            height: 17,
            width: 17,
            child: Center(
              child: Text(
                not_count.toString(),
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          );

    return Material(
      color: Colors.transparent,
      child: isCollapsed
          ? Stack(
              children: [
                ListTile(
                  leading: null,
                  title: Container(
                    padding: EdgeInsets.only(right: 7, top: 4),
                    child: FaIcon(icon, size: 20, color: Colors.white),
                  ),
                  onTap: onClicked,
                ),
                Positioned(
                  right: 10,
                  top: 5,
                  child: not,
                ),
              ],
            )
          : ListTile(
              leading: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 13, top: 8),
                    child: FaIcon(icon, size: 20, color: Colors.white),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: not,
                  ),
                ],
              ),
              title: Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onTap: onClicked,
            ),
    );
  }

  // collapse icon
  Widget buildCollapseIcon(
    BuildContext context, {
    required bool isCollapsed,
  }) {
    final double size = 52;
    final icon = isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios;
    final alignment = isCollapsed ? Alignment.center : Alignment.centerRight;
    final margin = isCollapsed ? null : EdgeInsets.only(right: 16);
    final width = isCollapsed ? double.infinity : size;

    return Container(
      alignment: alignment,
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: Container(
            width: width,
            height: size,
            child: Icon(icon, size: 22, color: Colors.white),
          ),
          onTap: () {
            Provider.of<AppData>(context, listen: false)
                .toggle_drawer_expanded();
          },
        ),
      ),
    );
  }

  // theme button
  Widget buildThemeButton() {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: IconButton(
        onPressed: () {
          if (isDarkTheme) {
            Provider.of<AppData>(context, listen: false)
                .update_themeMode(ThemeMode.light);
          } else {
            Provider.of<AppData>(context, listen: false)
                .update_themeMode(ThemeMode.dark);
          }
        },
        icon: Icon(isDarkTheme ? Icons.light_mode : Icons.dark_mode, size: 25),
      ),
    );
  }

  // header
  Widget buildHeader(bool isCollapsed) {
    var auth_staff = Provider.of<AppData>(context).active_staff;

    return Container(
      height: 90,
      width: double.infinity,
      child: Stack(
        children: [
          if (!isCollapsed) Image.asset('assets/drawer-header-1-540x160.jpg'),

          Positioned.fill(
              child: Container(
            color: Colors.black38,
          )),

          // content
          Positioned.fill(
              child: Container(
            child: isCollapsed
                ? Center(
                    child: GestureDetector(
                      onTap: () {
                        Provider.of<AppData>(context, listen: false)
                            .toggle_drawer_expanded();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white38,
                          shape: BoxShape.circle,
                        ),
                        width: 40,
                        height: 40,
                        child: Center(
                          child: Icon(
                            Icons.person_2_rounded,
                            size: 30,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // user icon
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white38,
                                shape: BoxShape.circle,
                              ),
                              width: 55,
                              height: 55,
                              child: Center(
                                child: Icon(
                                  Icons.person_2_rounded,
                                  size: 40,
                                  color: Colors.white70,
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            // details
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // full name
                                Text(
                                  auth_staff!.fullname,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),

                                // role
                                Text(
                                  auth_staff.role.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // staff id
                      Positioned(
                        top: 5,
                        right: 8,
                        child: Text(
                          auth_staff.staffId,
                          style: TextStyle(
                              letterSpacing: .8,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
          )),
        ],
      ),
    );
  }

  // todo bottom bar
  Widget bottom_bar() {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    bool canLogout = Provider.of<AppData>(context).can_logout;
    bool canRefresh = Provider.of<AppData>(context).can_refresh;

    return Container(
      decoration: BoxDecoration(
        color: isDarkTheme
            ? AppColors.dark_primaryBackgroundColor
            : AppColors.light_dialogBackground_3,
      ),
      width: double.infinity,
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // sign out menu
            if (canLogout) sign_out_menu() else Container(width: 100),

            // todo - settings (refresh)
            if (canRefresh)
              IconButton(
                onPressed: () async {
                  ServerHelpers.get_all_data(context, refresh: true);
                },
                icon: Icon(
                  Icons.settings,
                  color: isDarkTheme
                      ? AppColors.dark_primaryBackgroundColor
                      : AppColors.light_dialogBackground_3,
                ),
              )
            else
              Container(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  color: AppColors.orange_1,
                  strokeWidth: 3,
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<String> sign_out_options = [
    'Lock',
    'Switch account',
    'Sign out',
  ];

  // sign out options
  Widget sign_out_menu() {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    return Container(
      child: PopupMenuButton(
        offset: Offset(40, 40),
        onSelected: (value) async {
          // lock
          if (value == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginPage(
                        initial_page: 3,
                      )),
              (route) => false,
            );
          }

          // switch
          if (value == 1) {
            bool? conf = await UniversalHelpers.showConfirmBox(
              context,
              title: 'Switch account',
              subtitle:
                  'You are about to logout of this account. Would you like to proceed',
            );

            if (conf != null && conf) {
              AuthHelpers.logout(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage(
                          initial_page: 2,
                        )),
                (route) => false,
              );
            }
          }

          // sign out
          if (value == 2) {
            bool? conf = await UniversalHelpers.showConfirmBox(
              context,
              title: 'Log out',
              subtitle:
                  'You are about to logout of this device. Would you like to proceed',
            );

            if (conf != null && conf) {
              AuthHelpers.logout(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage(
                          initial_page: 0,
                        )),
                (route) => false,
              );
            }
          }
        },
        itemBuilder: (context) {
          return sign_out_options.map((e) {
            String title = e;
            int value = sign_out_options.indexOf(e);
            return PopupMenuItem(
                child: Container(
                    child: Row(
                  children: [
                    Icon(
                      value == 0
                          ? Icons.lock
                          : value == 1
                              ? Icons.switch_account
                              : Icons.logout,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                        child: Text(
                      title,
                      style: TextStyle(fontSize: 14),
                    )),
                  ],
                )),
                value: value);
          }).toList();
        },
        child: Container(
          decoration: BoxDecoration(
            color: isDarkTheme ? Colors.white38 : Colors.black38,
            shape: BoxShape.circle,
          ),
          width: 30,
          height: 30,
          child: Center(
            child: Icon(
              Icons.person_2_rounded,
              size: 18,
              color: isDarkTheme ? Colors.white70 : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  // FUNCTIONS
  void selectItem(BuildContext context, int index) {
    final navigateTo = (page) => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => page,
        ));

    switch (index) {
      case 0:
        navigateTo(ProductionRecordPage());
        break;
      case 1:
        navigateTo(ProductReceivedRecordPage());
        break;
      case 2:
        navigateTo(ProductRequestRecordPage());
        break;
      case 3:
        navigateTo(TerminalCollectionRecordPage());
        break;
      case 4:
        navigateTo(BadProductRecordPage());
        break;
      case 5:
        navigateTo(RestockProductMaterialRecordPage());
        break;
      case 6:
        navigateTo(RestockRawMaterialRecordPage());
        break;
      case 7:
        navigateTo(ProductMaterialRequestRecordPage());
        break;
      case 8:
        navigateTo(RawMaterialRequestRecordPage());
        break;
      case 9:
        navigateTo(ProductMaterialReturnRecordPage());
      case 10:
        navigateTo(ProductTakeOutRecordPage());
      case 11:
        navigateTo(ProductReturnRecordPage());
        break;
      case 12:
        navigateTo(DangoteCollectionRecordPage());
        break;
    }
  }

  //
}

class SidebarItemModel {
  String title;
  IconData icon;
  int key;

  SidebarItemModel({
    required this.title,
    required this.icon,
    required this.key,
  });
}
