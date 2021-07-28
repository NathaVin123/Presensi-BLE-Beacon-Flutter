import 'package:flutter/material.dart';

class DosenGantiJadwalPage extends StatefulWidget {
  @override
  _DosenGantiJadwalPageState createState() => _DosenGantiJadwalPageState();
}

class _DosenGantiJadwalPageState extends State<DosenGantiJadwalPage> {
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
                'Ganti Jadwal Kelas',
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
