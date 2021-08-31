import 'package:flutter/material.dart';

class DosenNotifikasiPresensiPage extends StatefulWidget {
  DosenNotifikasiPresensiPage({Key key}) : super(key: key);

  @override
  _DosenNotifikasiPresensiPageState createState() =>
      _DosenNotifikasiPresensiPageState();
}

class _DosenNotifikasiPresensiPageState
    extends State<DosenNotifikasiPresensiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(23, 75, 137, 1),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Color.fromRGBO(23, 75, 137, 1),
              pinned: true,
              floating: false,
              snap: false,
              expandedHeight: 85,
              flexibleSpace: const FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  'Notifikasi',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'WorkSansMedium',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                'Aplikasi sedang dalam pembangunan, tunggu update selanjutnya ya...',
                style: TextStyle(color: Colors.white),
              )),
            ))
          ],
        ));
  }
}
