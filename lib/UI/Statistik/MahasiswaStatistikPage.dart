import 'package:flutter/material.dart';

class MahasiswaStatistikPage extends StatefulWidget {
  MahasiswaStatistikPage({Key key}) : super(key: key);

  @override
  _MahasiswaStatistikPageState createState() => _MahasiswaStatistikPageState();
}

class _MahasiswaStatistikPageState extends State<MahasiswaStatistikPage> {
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
                'Statistik',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'WorkSansMedium',
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
