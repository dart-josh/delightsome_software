import 'package:delightsome_software/helpers/serverHelpers.dart';
import 'package:delightsome_software/pages/loginPage.dart';

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
    return LoginPage();
  }

  // WIDGETS

  // top bar
  Widget top_bar() {
    return Container();
  }

  Widget option_tile(String title, Widget? page, String section,
          {bool dialog = false, bool wait = false}) =>
      InkWell(
        onTap: () {
          if (dialog && page != null) {
            showDialog(
              context: context,
              builder: (context) => page,
            );
            return;
          }

          if (page != null)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
        },
        child: Container(
          decoration: BoxDecoration(
            color: section == 'stock'
                ? Colors.lightGreen
                : section == 'product'
                    ? Colors.lightBlue
                    : section == 'shop'
                        ? Colors.purple
                        : section == 'dan'
                            ? Colors.redAccent
                            : Colors.deepOrangeAccent.shade400,
            borderRadius: BorderRadius.circular(6),
          ),
          width: 200,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );

  // FUNCTIONS
}
