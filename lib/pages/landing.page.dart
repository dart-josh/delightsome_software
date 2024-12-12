import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/category.model.dart';
import 'package:delightsome_software/dataModels/productStoreModels/product.model.dart';
import 'package:delightsome_software/dataModels/userModels/staff.model.dart';
import 'package:delightsome_software/globalvariables.dart';
import 'package:delightsome_software/helpers/dataGetters.dart';
import 'package:delightsome_software/helpers/serverHelpers.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/pages/login.page.dart';
import 'package:delightsome_software/pages/materialStorePages/add_update_product_material.page.dart';
import 'package:delightsome_software/pages/materialStorePages/add_update_raw_material.page.dart';
import 'package:delightsome_software/pages/materialStorePages/enter_product_material_request.page.dart';
import 'package:delightsome_software/pages/materialStorePages/enter_raw_material_request.page.dart';
import 'package:delightsome_software/pages/materialStorePages/enter_restock_product_material.page.dart';
import 'package:delightsome_software/pages/materialStorePages/enter_restock_raw_material.page.dart';
import 'package:delightsome_software/pages/materialStorePages/product_material_list.page.dart';
import 'package:delightsome_software/pages/materialStorePages/product_material_request_record.page.dart';
import 'package:delightsome_software/pages/materialStorePages/raw_material_list.page.dart';
import 'package:delightsome_software/pages/materialStorePages/raw_material_request_record.page.dart';
import 'package:delightsome_software/pages/materialStorePages/restock_product_material_record.page.dart';
import 'package:delightsome_software/pages/materialStorePages/restock_raw_material_record.page.dart';
import 'package:delightsome_software/pages/productStorePages/bad_product_record.page.dart';
import 'package:delightsome_software/pages/productStorePages/enter_bad_product.page.dart';
import 'package:delightsome_software/pages/productStorePages/enter_product_received.page.dart';
import 'package:delightsome_software/pages/productStorePages/enter_product_request.page.dart';
import 'package:delightsome_software/pages/productStorePages/enter_production.page.dart';
import 'package:delightsome_software/pages/productStorePages/enter_terminalCollection.page.dart';
import 'package:delightsome_software/pages/productStorePages/product_list.page.dart';
import 'package:delightsome_software/pages/productStorePages/product_received_record.page.dart';
import 'package:delightsome_software/pages/productStorePages/product_request_record.page.dart';
import 'package:delightsome_software/pages/productStorePages/production_record.page.dart';
import 'package:delightsome_software/pages/productStorePages/production_summary.page.dart';
import 'package:delightsome_software/pages/productStorePages/terminal_collection_record.page.dart';
import 'package:delightsome_software/pages/salePages/daily_sales_record.page.dart';
import 'package:delightsome_software/pages/salePages/enter_new_sale.page.dart';
import 'package:delightsome_software/pages/salePages/enter_new_terminal_sale.page.dart';
import 'package:delightsome_software/pages/salePages/sales_record.page.dart';
import 'package:delightsome_software/pages/salePages/sales_report.page.dart';
import 'package:delightsome_software/pages/salePages/terminal_daily_sales_record.page.dart';
import 'package:delightsome_software/pages/salePages/terminal_sales_record.page.dart';
import 'package:delightsome_software/pages/universalPages/category_list.page.dart';
import 'package:delightsome_software/pages/salePages/print.page.dart';
import 'package:delightsome_software/pages/userPages/customer_list.page.dart';
import 'package:delightsome_software/pages/userPages/staff_list.page.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List<ProductModel> productList = [];
  List<ProductModel> terminal_productList = [];

  StaffModel? auth_staff;

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    auth_staff = Provider.of<AppData>(context).active_staff;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            AppColors.primaryForegroundColor, //Colors.green.shade900,
        title: Text('HomePage'),
        actions: [
          IconButton(
            onPressed: () async {
              ServerHelpers.get_all_data(context);
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () async {
              ServerHelpers.disconnect_socket();
              
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
              );
              
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      backgroundColor: isDarkTheme
          ? AppColors.dark_primaryBackgroundColor
          : AppColors.light_primaryBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // staff
            auth_staff == null
                ? Container()
                : Row(children: [
                    SizedBox(width: 10),
                    Text('Nickname: '),
                    Text(auth_staff!.nickName),
                    SizedBox(width: 10),
                    Text('Role: '),
                    Text(auth_staff!.role),
                    SizedBox(width: 10),
                  ]),

            Wrap(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => StaffListPage(),
                      );
                    },
                    child: Text('Staff List')),
                SizedBox(width: 20),
                ElevatedButton(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => CustomerListPage(),
                      );
                    },
                    child: Text('Customer List')),
              ],
            ),

            SizedBox(height: 10),

            Text('Sales'),
            ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SalesReportPage()));
                },
                child: Text('Sales Report')),

            SizedBox(height: 20),

            Wrap(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SalesPage()));
                    },
                    child: Text('Outlet Shop')),
                SizedBox(width: 20),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SalesRecordPage()));
                    },
                    child: Text('Outlet Sales Record')),
                SizedBox(width: 20),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DailySalesRecordPage()));
                    },
                    child: Text('Outlet Daily Product Record')),
              ],
            ),

            SizedBox(height: 20),

            Wrap(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TerminalSalesPage()));
                    },
                    child: Text('Terminal Shop')),
                SizedBox(width: 20),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TerminalSalesRecordPage()));
                    },
                    child: Text('Terminal Sales Record')),
                SizedBox(width: 20),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TerminalDailySalesRecordPage()));
                    },
                    child: Text('Terminal Daily Product Record')),
              ],
            ),

            SizedBox(height: 50),

            Text('Product Store Form'),

            Wrap(
              children: [
                // EnterBadProduct
                ElevatedButton(
                    onPressed: () async {
                      double width = MediaQuery.of(context).size.width;

                      if (width > 600) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => EnterBadProductPage(
                                  editModel: saved_bad_product_model,
                                ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EnterBadProductPage(
                                      editModel: saved_bad_product_model,
                                    )));
                      }
                    },
                    child: Text('Enter Bad Product')),

                SizedBox(width: 20),

                ElevatedButton(
                    onPressed: () async {
                      double width = MediaQuery.of(context).size.width;

                      if (width > 600) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => EnterProductReceivedPage(
                                  editModel: saved_product_received_model,
                                ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EnterProductReceivedPage(
                                      editModel: saved_product_received_model,
                                    )));
                      }
                    },
                    child: Text('Enter Product Received')),

                SizedBox(width: 20),

                ElevatedButton(
                    onPressed: () async {
                      double width = MediaQuery.of(context).size.width;

                      if (width > 600) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => EnterProductRequestPage(
                                  editModel: saved_product_request_model,
                                ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EnterProductRequestPage(
                                      editModel: saved_product_request_model,
                                    )));
                      }
                    },
                    child: Text('Enter Product Request')),

                SizedBox(width: 20),

                ElevatedButton(
                    onPressed: () async {
                      double width = MediaQuery.of(context).size.width;

                      if (width > 600) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => EnterProductionPage(
                                  editModel: saved_production_model,
                                ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EnterProductionPage(
                                      editModel: saved_production_model,
                                    )));
                      }
                    },
                    child: Text('Enter Production Record')),

                SizedBox(width: 20),

                ElevatedButton(
                    onPressed: () async {
                      double width = MediaQuery.of(context).size.width;

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
                              ));

                      if (collectionType != null) {
                        if (width > 600) {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => EnterTerminalcollectionPage(
                                    editModel: (collectionType == 'Collected')
                                        ? saved_terminal_collected_model
                                        : saved_terminal_returned_model,
                                    collectionType: collectionType,
                                  ));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EnterTerminalcollectionPage(
                                        editModel:
                                            (collectionType == 'Collected')
                                                ? saved_terminal_collected_model
                                                : saved_terminal_returned_model,
                                        collectionType: collectionType,
                                      )));
                        }
                      }
                    },
                    child: Text('Enter Terminal Collection')),

                SizedBox(width: 20),
              ],
            ),

            SizedBox(height: 20),

            Text('Product Store Record'),

            Wrap(
              children: [
                // EnterBadProduct
                ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BadProductRecordPage()));
                    },
                    child: Text('Bad Product Record')),

                SizedBox(width: 20),

                // ProductReceivedRecordPage
                ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProductReceivedRecordPage()));
                    },
                    child: Text('Product Received Record')),

                SizedBox(width: 20),

                // ProductRequestRecordPage
                ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProductRequestRecordPage()));
                    },
                    child: Text('Product Request Record')),

                SizedBox(width: 20),

                // ProductionRecordPage
                ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductionRecordPage()));
                    },
                    child: Text('Production Record')),

                SizedBox(width: 20),

                // TerminalCollectionRecordPage
                ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TerminalCollectionRecordPage()));
                    },
                    child: Text('Terminal Collection Record')),
              ],
            ),

            SizedBox(height: 20),

            // ProductionSummaryPage
            ElevatedButton(
                onPressed: () async {
                  double width = MediaQuery.of(context).size.width;

                  if (width > 600) {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => ProductionSummaryPage());
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductionSummaryPage()));
                  }
                },
                child: Text('Production Summary')),

            SizedBox(height: 50),

            Text('Items'),

            // new  material item
            Wrap(
              children: [
                // category
                ElevatedButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) => CategoryListPage());
                    },
                    child: Text('Categories')),

                SizedBox(width: 20),

                // terminal product
                ElevatedButton(
                    onPressed: () async {
                      double width = MediaQuery.of(context).size.width;

                      if (width > 600) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => ProductListPage(
                                  page: 'terminal_product',
                                ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductListPage(
                                      page: 'terminal_product',
                                    )));
                      }
                    },
                    child: Text('Terminal Product List')),

                SizedBox(width: 20),

                // product
                ElevatedButton(
                    onPressed: () async {
                      double width = MediaQuery.of(context).size.width;

                      if (width > 600) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => ProductListPage(
                                  page: 'product',
                                ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductListPage(
                                      page: 'product',
                                    )));
                      }
                    },
                    child: Text('Product List')),

                SizedBox(width: 20),

                // product material
                ElevatedButton(
                    onPressed: () async {
                      double width = MediaQuery.of(context).size.width;

                      if (width > 600) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => ProductMaterialListPage());
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProductMaterialListPage()));
                      }
                    },
                    child: Text('Product Material List')),

                SizedBox(width: 20),

                // raw material
                ElevatedButton(
                    onPressed: () async {
                      double width = MediaQuery.of(context).size.width;

                      if (width > 600) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => RawMaterialListPage(
                                // item: pro,
                                ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RawMaterialListPage(
                                    // item: pro,
                                    )));
                      }
                    },
                    child: Text('Raw Material List')),
              ],
            ),

            SizedBox(height: 20),

            Text('Material Store Form'),

            // form
            Wrap(
              children: [
                // EnterRestockProductMaterial
                ElevatedButton(
                    onPressed: () async {
                      double width = MediaQuery.of(context).size.width;

                      if (width > 600) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => EnterRestockProductMaterial(
                                  editModel:
                                      saved_restock_product_material_model,
                                ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EnterRestockProductMaterial(
                                      editModel:
                                          saved_restock_product_material_model,
                                    )));
                      }
                    },
                    child: Text('Restock Product Material')),

                SizedBox(width: 20),

                // EnterRestockRawMaterial
                ElevatedButton(
                    onPressed: () async {
                      double width = MediaQuery.of(context).size.width;

                      if (width > 600) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => EnterRestockRawMaterial(
                                  editModel: saved_restock_raw_material_model,
                                ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EnterRestockRawMaterial(
                                      editModel:
                                          saved_restock_raw_material_model,
                                    )));
                      }
                    },
                    child: Text('Restock Raw Material')),

                SizedBox(width: 20),

                // EnterProductMaterialRequest
                ElevatedButton(
                    onPressed: () async {
                      double width = MediaQuery.of(context).size.width;

                      if (width > 600) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => EnterProductMaterialRequest(
                                  editModel:
                                      saved_product_material_request_model,
                                ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EnterProductMaterialRequest(
                                      editModel:
                                          saved_product_material_request_model,
                                    )));
                      }
                    },
                    child: Text('Product Material Request')),

                SizedBox(width: 20),

                // EnterRawMaterialRequest
                ElevatedButton(
                    onPressed: () async {
                      double width = MediaQuery.of(context).size.width;

                      if (width > 600) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => EnterRawMaterialRequest(
                                  editModel: saved_raw_material_request_model,
                                ));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EnterRawMaterialRequest(
                                      editModel:
                                          saved_raw_material_request_model,
                                    )));
                      }
                    },
                    child: Text('Raw Material Request')),
              ],
            ),

            SizedBox(height: 20),

            Text('Material Store Record'),

            // record
            Wrap(
              children: [
                // RestockProductMaterialRecordPage
                ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RestockProductMaterialRecordPage()));
                    },
                    child: Text('Restock Product Material Record')),

                SizedBox(width: 20),

                // RestockRawMaterialRecordPage
                ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RestockRawMaterialRecordPage()));
                    },
                    child: Text('Restock Raw Material Record')),

                SizedBox(width: 20),

                // ProductMaterialRequestRecordPage
                ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProductMaterialRequestRecordPage()));
                    },
                    child: Text('Product Material Request Record')),

                SizedBox(width: 20),

                // RawMaterialRequestRecordPage
                ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  RawMaterialRequestRecordPage()));
                    },
                    child: Text('Raw Material Request Record')),
              ],
            ),

            SizedBox(height: 40),

            // change theme
            ElevatedButton(
              onPressed: () async {
                ThemeMode themeMode =
                    Provider.of<AppData>(context, listen: false).themeMode;
                if (themeMode == ThemeMode.dark) {
                  Provider.of<AppData>(context, listen: false)
                      .update_themeMode(ThemeMode.light);
                } else {
                  Provider.of<AppData>(context, listen: false)
                      .update_themeMode(ThemeMode.dark);
                }
              },
              child: Text(isDarkTheme ? 'Switch to Light' : 'Switch to Dark'),
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
