import 'package:delightsome_software/helpers/serverHelpers.dart';
import 'package:delightsome_software/pages/landing.page.dart';

import 'package:flutter/material.dart';

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

  

  @override
  Widget build(BuildContext context) {
    return LandingPage();
  }
}
