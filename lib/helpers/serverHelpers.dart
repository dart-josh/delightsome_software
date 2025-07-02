import 'package:delightsome_software/globalvariables.dart';
import 'package:delightsome_software/helpers/dataGetters.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ServerHelpers {
  static bool is_socket_connected = false;

  static IO.Socket? socket;

  // start socket & listen
  static void start_socket_listerners(context) {
    var auth_staff = Provider.of<AppData>(context, listen: false).active_staff;

    socket = IO.io(server_url, {
      'transports': ['websocket'],
      "query": {'staffId': auth_staff?.staffId}
    }
        // IO.OptionBuilder()
        //     .setTransports(['websocket']) // for Flutter or Dart VM
        //     .disableAutoConnect() // disable auto-connection
        //     .setQuery({'staffId': auth_staff?.staffId})
        //     .build()
        );

    socket!.connect();

    //? MATERIALS STORE

    // ProductMaterials
    socket!.on('ProductMaterials', (data) {
      DataGetters.get_product_materials(context);
    });

    // RawMaterials
    socket!.on('RawMaterials', (data) {
      DataGetters.get_raw_materials(context);
    });

    // RestockProductMaterialsRecord
    socket!.on('RestockProductMaterialsRecord', (data) {
      DataGetters.get_restock_product_materials_record(context);
    });

    // RestockRawMaterialsRecord
    socket!.on('RestockRawMaterialsRecord', (data) {
      DataGetters.get_restock_raw_materials_record(context);
    });

    // ProductMaterialsRequestRecord
    socket!.on('ProductMaterialsRequestRecord', (data) {
      DataGetters.get_product_materials_request_record(context);
    });

    // RawMaterialsRequestRecord
    socket!.on('RawMaterialsRequestRecord', (data) {
      DataGetters.get_raw_materials_request_record(context);
    });

    // ProductMaterialsReturnRecord
    socket!.on('ProductMaterialsReturnRecord', (data) {
      DataGetters.get_product_materials_return_record(context);
    });

    // ProductMaterialsCategory
    socket!.on('ProductMaterialsCategory', (data) {
      DataGetters.get_product_materials_categories(context);
    });

    // RawMaterialsCategory
    socket!.on('RawMaterialsCategory', (data) {
      DataGetters.get_raw_materials_categories(context);
    });

    //? PRODUCTS STORE

    // Product
    socket!.on('Product', (data) {
      DataGetters.get_products(context);
    });

    // TerminalProduct
    socket!.on('TerminalProduct', (data) {
      DataGetters.get_terminal_products(context);
    });

    // DangoteProduct
    socket!.on('DangoteProduct', (data) {
      DataGetters.get_dangote_products(context);
    });

    // ProductionRecord
    socket!.on('ProductionRecord', (data) {
      DataGetters.get_production_record(context);
    });

    // ProductReceived
    socket!.on('ProductReceived', (data) {
      DataGetters.get_product_received_record(context);
    });

    // ProductRequest
    socket!.on('ProductRequest', (data) {
      DataGetters.get_product_request_record(context);
    });

    // ProductTakeOut
    socket!.on('ProductTakeOut', (data) {
      DataGetters.get_product_takeOut_record(context);
    });

    // ProductReturn
    socket!.on('ProductReturn', (data) {
      DataGetters.get_product_return_record(context);
    });

    // BadProduct
    socket!.on('BadProduct', (data) {
      DataGetters.get_bad_product_record(context);
    });

    // TerminalCollectionRecord
    socket!.on('TerminalCollectionRecord', (data) {
      DataGetters.get_terminalCollection_record(context);
    });

    // DangoteCollectionRecord
    socket!.on('DangoteCollectionRecord', (data) {
      DataGetters.get_dangoteCollection_record(context);
    });

    // ProductCategory
    socket!.on('ProductCategory', (data) {
      DataGetters.get_product_categories(context);
    });

    // ? SALES

    // SalesRecord
    socket!.on('SalesRecord', (data) {
      DataGetters.get_sales_record(context);
    });

    // DailySalesRecord
    socket!.on('DailySalesRecord', (data) {
      DataGetters.get_daily_sales_record(context);
    });

    // TerminalSalesRecord
    socket!.on('TerminalSalesRecord', (data) {
      DataGetters.get_terminal_sales_record(context);
    });

    // TerminalDailySalesRecord
    socket!.on('TerminalDailySalesRecord', (data) {
      DataGetters.get_terminal_daily_sales_record(context);
    });

    // DangoteSalesRecord
    socket!.on('DangoteSalesRecord', (data) {
      DataGetters.get_dangote_sales_record(context);
    });

    // DangoteDailySalesRecord
    socket!.on('DangoteDailySalesRecord', (data) {
      DataGetters.get_dangote_daily_sales_record(context);
    });

    // ? USER

    // Staff
    socket!.on('Staff', (data) {
      DataGetters.get_all_staff(context);
    });

    // Customer
    socket!.on('Customer', (data) {
      DataGetters.get_all_customer(context);
    });

    // staffId
    socket!.on(auth_staff?.staffId ?? '', (data) {
      DataGetters.get_active_staff(context, auth_staff?.staffId ?? '');
    });
  }

  // get all data
  static void get_all_data(context, {bool refresh = false}) {
      if (!refresh) {
        UniversalHelpers.canLogout(context, value: false);
        UniversalHelpers.canRefresh(context, value: false);
      } else {
        Provider.of<AppData>(context, listen: false).update_can_logout(false);
        Provider.of<AppData>(context, listen: false).update_can_refresh(false);
      }

      // ? MATERIALS STORE
      DataGetters.get_product_materials(context);
      DataGetters.get_raw_materials(context);

      DataGetters.get_restock_product_materials_record(context);
      DataGetters.get_restock_raw_materials_record(context);
      DataGetters.get_product_materials_request_record(context);
      DataGetters.get_raw_materials_request_record(context);
      DataGetters.get_product_materials_return_record(context);

      DataGetters.get_product_materials_categories(context);
      DataGetters.get_raw_materials_categories(context);

      //? PRODUCTS STORE
      DataGetters.get_products(context);
      DataGetters.get_terminal_products(context);
      DataGetters.get_dangote_products(context);

      DataGetters.get_product_categories(context);

      DataGetters.get_production_record(context);
      DataGetters.get_product_received_record(context);
      DataGetters.get_product_request_record(context);
      DataGetters.get_product_takeOut_record(context);
      DataGetters.get_product_return_record(context);
      DataGetters.get_bad_product_record(context);
      DataGetters.get_terminalCollection_record(context);
      DataGetters.get_dangoteCollection_record(context);

      // ? SALES
      DataGetters.get_sales_record(context);
      DataGetters.get_daily_sales_record(context);

      DataGetters.get_terminal_sales_record(context);
      DataGetters.get_terminal_daily_sales_record(context);

      DataGetters.get_dangote_sales_record(context);
      DataGetters.get_dangote_daily_sales_record(context);

      // ? USER
      DataGetters.get_all_staff(context);
      DataGetters.get_all_customer(context);

      // start db socket listeners
      if (!is_socket_connected) {
        start_socket_listerners(context);
        is_socket_connected = true;
      }

      UniversalHelpers.canLogout(context, value: true);
      UniversalHelpers.canRefresh(context, value: true);
    
  }

  // disconnect socket
  static void disconnect_socket() {
    if (socket != null) {
      socket!.close();
      socket!.destroy();
      socket!.dispose();
    }

    socket = null;
    is_socket_connected = false;
  }

  //
}
