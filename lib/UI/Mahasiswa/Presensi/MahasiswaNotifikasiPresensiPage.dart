import 'package:flutter/material.dart';

class MahasiswaNotifikasiPresensiPage extends StatefulWidget {
  MahasiswaNotifikasiPresensiPage({Key key}) : super(key: key);

  @override
  _MahasiswaNotifikasiPresensiPageState createState() =>
      _MahasiswaNotifikasiPresensiPageState();
}

class _MahasiswaNotifikasiPresensiPageState
    extends State<MahasiswaNotifikasiPresensiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              pinned: true,
              floating: false,
              snap: false,
              expandedHeight: 85,
              flexibleSpace: const FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  'Notifikasi',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'WorkSansMedium',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverToBoxAdapter(
                child: Center(
                    child: Text(
                        'Aplikasi sedang dalam pembangunan, tunggu update selanjutnya ya...')))
          ],
        ));
  }
}
