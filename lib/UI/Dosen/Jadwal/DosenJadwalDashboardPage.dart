import 'package:flutter/material.dart';

class DosenJadwalDashboardPage extends StatelessWidget {
  const DosenJadwalDashboardPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Jadwal'),
          centerTitle: true,
        ),
        body: ListView(children: const <Widget>[
          Flexible(
              child: ListTile(
            title: Text('Tes'),
          )),
        ]),
      ),
    );
  }
}
