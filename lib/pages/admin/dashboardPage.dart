import 'package:delightsome_software/pages/admin/loadJsonPage.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Load Products'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoadJsonPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.receipt),
            title: Text('Load Record'),
            onTap: () {
              
            },
          ),
        ],
      ),
    );
  }
}
