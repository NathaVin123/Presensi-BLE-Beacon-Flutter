import 'package:flutter/material.dart';

class AdminDashboardPage extends StatefulWidget {
  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'ADMIN',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontFamily: 'WorkSansMedium'),
          ),
          backgroundColor: Color.fromRGBO(23, 75, 137, 1),
          elevation: 0,
        ),
        body: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(23, 75, 137, 1)),
        ));
  }
}
