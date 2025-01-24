import 'package:delightsome_software/dataModels/userModels/staff.model.dart';
import 'package:delightsome_software/globalvariables.dart';
import 'package:delightsome_software/helpers/serverHelpers.dart';
import 'package:delightsome_software/pages/landing.page.dart';
import 'package:delightsome_software/utils/appdata.dart';

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
    super.initState();
  }

  watchForInactiveUser() {
    StaffModel? staff = Provider.of<AppData>(context).active_staff;

    bool isActive = staff?.active ?? false;

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
