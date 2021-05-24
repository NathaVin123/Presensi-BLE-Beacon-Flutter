import 'package:flutter/material.dart';

class DosenRiwayatDashboardPage extends StatelessWidget {
  const DosenRiwayatDashboardPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Riwayat'),
          centerTitle: true,
        ),
      ),
    );
  }
}
