import 'package:delightsome_software/dataModels/userModels/staff.model.dart';
import 'package:delightsome_software/globalvariables.dart';
import 'package:delightsome_software/helpers/serverHelpers.dart';
import 'package:delightsome_software/pages/landing.page.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:delightsome_software/utils/offlineStore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    ServerHelpers.get_all_data(context);
    get_offline_data();
    super.initState();
  }

  void get_offline_data() async {
    await OfflineStore.get_offline_data();
  }

  watchForInactiveUser() {
    StaffModel? staff = Provider.of<AppData>(context).active_staff;

    if (staff == null) return;

    bool isActive = staff.active;

    if (!isActive) {
      Future.delayed(Duration(seconds: 1), () {
        appRestartNotifier.value = UniqueKey();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    watchForInactiveUser();
    return LandingPage();
  }
}
