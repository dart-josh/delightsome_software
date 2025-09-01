import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/productStoreModels/productItem.model.dart';
import 'package:delightsome_software/globalvariables.dart';
import 'package:delightsome_software/helpers/materialStoreHelpers.dart';
import 'package:delightsome_software/helpers/productStoreHelpers.dart';
import 'package:delightsome_software/helpers/saleHelpers.dart';
import 'package:delightsome_software/helpers/serverHelpers.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/pages/universalPages/product_display_dialog.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:delightsome_software/utils/localStorage.dart';
import 'package:delightsome_software/utils/offlineStore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OfflineDataDialog extends StatefulWidget {
  const OfflineDataDialog({super.key});

  @override
  State<OfflineDataDialog> createState() => _OfflineDataDialogState();
}

class _OfflineDataDialogState extends State<OfflineDataDialog> {
  ValueNotifier<bool> isUploading = ValueNotifier(false);

  void get_offline_data() async {
    await OfflineStore.get_offline_data(building: true);
  }

  @override
  void initState() {
    get_offline_data();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;
    var isConnected = Provider.of<AppData>(context).connection_status;

    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320,
        height: 500,
        child: Column(
          children: [
            // top bar
            top_bar(),

            // content
            ValueListenableBuilder<List<dynamic>>(
                valueListenable: offline_data,
                builder: (context, value, child) {
                  value.sort((a, b) => DateTime.parse(b['date'])
                      .compareTo(DateTime.parse(a['date'])));
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 5, bottom: 2),
                      padding: EdgeInsets.only(bottom: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDarkTheme
                            ? AppColors.dark_dialogBackground_1
                            : AppColors.light_dialogBackground_1,
                      ),
                      child: value.isEmpty
                          ? Center(
                              child: Text(
                                'No Offline Record',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            )
                          : ListView.builder(
                              itemCount: value.length,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) =>
                                  data_tile(value[index]),
                            ),
                    ),
                  );
                }),

            // reconnect button
            ValueListenableBuilder(
                valueListenable: offline_data,
                builder: (context, value, child) {
                  if (value.length == 0) return SizedBox();
                  return reconnect_button();
                }),

            SizedBox(height: 6),

            // refresh button
            if (isConnected) refresh_button(),
          ],
        ),
      ),
    );
  }

  // WIDGETS

  // top bar
  Widget top_bar() {
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

              // refresh button
              InkWell(
                onTap: () async {
                  get_offline_data();
                },
                child: Icon(
                  Icons.refresh_rounded,
                  color: AppColors.secondaryWhiteIconColor,
                  size: 24,
                ),
              ),

              SizedBox(width: 8),

              // delete button
              ValueListenableBuilder(
                  valueListenable: offline_data,
                  builder: (context, value, child) {
                    if (value.length == 0) return SizedBox();
                    return InkWell(
                      onTap: () async {
                        if (offline_data.value.isEmpty) return;

                        var conf = await UniversalHelpers.showConfirmBox(
                            context,
                            title: 'Clear Offline Record',
                            subtitle:
                                'You are about to delete all saved offline record \nThis cannot be undone!');
                        if (conf != null && conf) {
                          OfflineStore.clear_offline_data();
                          offline_data.value = [];
                        }
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 24,
                      ),
                    );
                  }),
            ],
          ),

          // title
          Center(
            child: ValueListenableBuilder(
                valueListenable: offline_data,
                builder: (context, value, child) {
                  return Text(
                    'Offline Record${value.length > 0 ? ' - (${value.length})' : ''}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  // data tile
  Widget data_tile(Map data) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    var details = get_endpoint(data);

    if (details == null) return Container();

    List<ProductItemModel> products = get_products(data['data']);

    String title = '${data['type']} ${details?['name'] ?? ''}';
    String recordId = data['recordId'] ?? '';

    int quantity = products.isNotEmpty
        ? products.map((e) => e.quantity).reduce((a, b) => a + b)
        : 0;
    int price = data['data']?['orderPrice'] ?? 0;

    String date = data['date'] != null
        ? UniversalHelpers.format_time_to_string(DateTime.parse(data['date']))
        : data['data']?['date'] != null
            ? UniversalHelpers.format_time_to_string(
                DateTime.parse(data['data']['date']))
            : '';

    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: isDarkTheme
                  ? AppColors.dark_borderColor
                  : AppColors.light_borderColor,
            ),
            borderRadius: BorderRadius.circular(6),
            color: Colors.transparent,
          ),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // recordId
                  if (recordId != '')
                    Text(
                      recordId,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkTheme
                            ? AppColors.dark_secondaryTextColor
                            : AppColors.light_secondaryTextColor,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  else
                    SizedBox(),

                  if (date != '')
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkTheme
                            ? AppColors.dark_secondaryTextColor
                            : AppColors.light_secondaryTextColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              if (products.isNotEmpty) SizedBox(height: 6),
              if (products.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        showCupertinoDialog(
                            context: context,
                            builder: (context) => ProductDisplayDialog(
                                  products: products,
                                  id: recordId,
                                  displayPrice: price != 0,
                                ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        child: Text(
                          'View products',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                    if (quantity != 0)
                      Text(
                        quantity.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkTheme
                              ? AppColors.dark_secondaryTextColor
                              : AppColors.light_secondaryTextColor,
                        ),
                      ),
                    if (price != 0)
                      Text(
                        UniversalHelpers.format_number(price, currency: true),
                        style: TextStyle(
                          fontSize: 14,
                          color: isDarkTheme
                              ? AppColors.dark_secondaryTextColor
                              : AppColors.light_secondaryTextColor,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),

        // delete
        Positioned(
            top: 0,
            right: 5,
            child: InkWell(
              onTap: () async {
                var conf = await UniversalHelpers.showConfirmBox(context,
                    title: 'Delete record',
                    subtitle:
                        'You are about to delete this record from the offline store. It will not be updated.');

                if (conf != null && conf) {
                  OfflineStore.delete_offline_data(data['key']);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white70,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0.5, 0.5),
                      color: Colors.black12,
                      blurRadius: 5,
                    )
                  ],
                ),
                width: 17,
                height: 17,
                child: Center(
                  child: Icon(
                    Icons.close,
                    size: 13,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ))
      ],
    );
  }

  // reconnect button
  Widget reconnect_button() {
    var isConnected = Provider.of<AppData>(context).connection_status;

    return ValueListenableBuilder<bool>(
        valueListenable: isUploading,
        builder: (context, value, child) {
          return InkWell(
            onTap: () {
              if (value) return;

              if (isConnected) {
                upload_record();
              } else {
                // Localstorage.update_offline_data({'new_data': {}});
              }
            },
            child: Container(
              width: double.infinity,
              height: 35,
              padding: EdgeInsets.symmetric(horizontal: 8),
              color: AppColors.orange_1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  value
                      ? Container(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : Icon(
                          isConnected
                              ? Icons.cloud_upload
                              : Icons.refresh_rounded,
                          size: 23,
                          color: Colors.white60,
                        ),
                  SizedBox(width: 10),
                  Text(
                    value
                        ? 'Uploading...'
                        : isConnected
                            ? 'Upload Record'
                            : 'Reconnect',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        });
  }

  // refresh
  Widget refresh_button() {
    bool refreshing = !Provider.of<AppData>(context).can_refresh;

    return InkWell(
      onTap: () {
        if (refreshing) return;

        ServerHelpers.get_all_data(context, refresh: true);
      },
      child: Container(
        width: double.infinity,
        height: 35,
        padding: EdgeInsets.symmetric(horizontal: 8),
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            refreshing
                ? Container(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.orange_1,
                      strokeWidth: 3,
                    ),
                  )
                : Icon(
                    Icons.cloud_download_rounded,
                    size: 23,
                    color: Colors.white60,
                  ),
            SizedBox(width: 10),
            Text(
              refreshing ? 'Refreshing...' : 'Refresh Store',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  //? UTILS

  get_endpoint(Map data) {
    // record, //

    if (data['helper'] == 'ProductStoreHelpers')
      return productStoreEndpoint[data['endpoint']];

    if (data['helper'] == 'SaleHelpers') return saleEndpoint[data['endpoint']];

    if (data['helper'] == 'MaterialStoreHelpers')
      return materialStoreEndpoint[data['endpoint']];

    return null;
  }

  upload_record() async {
    isUploading.value = true;
    final List list = offline_data.value;

    list.sort((a, b) =>
        DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));

    for (var i = 0; i < list.length; i++) {
      var data = list[i];

      if (data['helper'] == 'ProductStoreHelpers') {
        bool res = await ProductStoreHelpers.send_online(context, data);

        if (res) {
          await OfflineStore.delete_offline_data(data['key']);
        }
      }

      if (data['helper'] == 'SaleHelpers') {
        bool res = await SaleHelpers.send_online(context, data);

        if (res) {
          await OfflineStore.delete_offline_data(data['key']);
        }
      }

      if (data['helper'] == 'MaterialStoreHelpers') {
        bool res = await MaterialStoreHelpers.send_online(context, data);

        if (res) {
          await OfflineStore.delete_offline_data(data['key']);
        }
      }
    }

    isUploading.value = false;
  }

  final dynamic productStoreEndpoint = {
    // Production record
    'enter_production_record': {'name': 'Production record'},
    'verify_production_record': {'name': 'Production record'},
    'delete_production_record': {'name': 'Production record'},
    // Product received
    'enter_product_received_record': {'name': 'Product Received'},
    'verify_product_received_record': {'name': 'Product Received'},
    'delete_product_received_record': {'name': 'Product Received'},
    // Product request
    'enter_product_request_record': {'name': 'Product Request'},
    'verify_product_request_record': {'name': 'Product Request'},
    'delete_product_request_record': {'name': 'Product Request'},
    // Product Take out
    'enter_product_takeOut_record': {'name': 'Product Take out'},
    'verify_product_takeOut_record': {'name': 'Product Take out'},
    'delete_product_takeOut_record': {'name': 'Product Take out'},
    // Product Return
    'enter_product_return_record': {'name': 'Product Return'},
    'verify_product_return_record': {'name': 'Product Return'},
    'delete_product_return_record': {'name': 'Product Return'},
    // Bad Product
    'enter_bad_product_record': {'name': 'Bad Product'},
    'verify_bad_product_record': {'name': 'Bad Product'},
    'delete_bad_product_record': {'name': 'Bad Product'},
    // Outlet Collection
    'enter_outletCollection_record': {'name': 'Outlet Collection'},
    'verify_outletCollection_record': {'name': 'Outlet Collection'},
    'delete_outletCollection_record': {'name': 'Outlet Collection'},
    // Terminal Collection
    'enter_terminalCollection_record': {'name': 'Terminal Collection'},
    'verify_terminalCollection_record': {'name': 'Terminal Collection'},
    'delete_terminalCollection_record': {'name': 'Terminal Collection'},
    // Dangote Collection
    'enter_dangoteCollection_record': {'name': 'Dangote Collection'},
    'verify_dangoteCollection_record': {'name': 'Dangote Collection'},
    'delete_dangoteCollection_record': {'name': 'Dangote Collection'},
  };

  final dynamic saleEndpoint = {
    'enter_new_store_sale': {'name': 'Store sale'},
    'enter_new_outlet_sale': {'name': 'Outlet sale'},
    'enter_new_terminal_sale': {'name': 'Terminal sale'},
    'enter_new_dangote_sale': {'name': 'Dangote sale'},
  };

  final dynamic materialStoreEndpoint = {
    'enter_restock_product_materials_record': {
      'name': 'Restock Product Material'
    },
  };

  //? EXTRAS
  // get products
  List<ProductItemModel> get_products(Map? data) {
    var p_list = data?['products'] ?? data?['items'] ?? [];
    List<ProductItemModel> products = [];

    for (var i = 0; i < p_list.length; i++) {
      var p = p_list[i];

      var ps = Provider.of<AppData>(context, listen: false).product_list;

      var pps = ps.where((e) => e.key == p['product']).toList();

      if (pps.isNotEmpty) {
        var _product = pps.first;
        var product = ProductItemModel(
            product: _product,
            quantity: p['quantity'] ?? 0,
            price: p['price'] ?? 0);
        products.add(product);
      }
    }

    return products;
  }

  //

//
}
// , widget.editModel?.recordId
// , record.recordId

// SizedBox(width: 10),
// OfflineRecordIndicator(rec_key: record.key),

// // connection status
//             Positioned(
//               top: 15,
//               right: 15,
//               child: OfflineNotifier(),
//             ),
