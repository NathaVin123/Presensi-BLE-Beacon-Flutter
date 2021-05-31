import 'package:flutter/material.dart';

class MahasiswaInformasiAkunPage extends StatefulWidget {
  MahasiswaInformasiAkunPage({Key key}) : super(key: key);

  @override
  _MahasiswaInformasiAkunPageState createState() =>
      _MahasiswaInformasiAkunPageState();
}

class _MahasiswaInformasiAkunPageState
    extends State<MahasiswaInformasiAkunPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            pinned: true,
            floating: false,
            snap: false,
            expandedHeight: 85,
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Informasi Akun',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'WorkSansMedium',
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // SliverList(
          //   delegate: SliverChildBuilderDelegate(

          //   ),
          // ),
        ],
      ),
    );
  }
}
