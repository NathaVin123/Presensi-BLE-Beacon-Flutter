import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MahasiswaTampilPesertaKelasPage extends StatefulWidget {
  @override
  _MahasiswaTampilPesertaKelasPageState createState() =>
      _MahasiswaTampilPesertaKelasPageState();
}

class _MahasiswaTampilPesertaKelasPageState
    extends State<MahasiswaTampilPesertaKelasPage> {
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
                'Tampil Peserta Kelas',
                style: TextStyle(
                    color: Colors.black,
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
                    'Aplikasi sedang dalam pembangunan, tunggu update selanjutnya ya...')),
          ))
        ],
      ),
    );
  }
}
