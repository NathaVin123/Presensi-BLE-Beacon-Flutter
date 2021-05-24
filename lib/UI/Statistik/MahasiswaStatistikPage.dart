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
            expandedHeight: 100,
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Statistik Mahasiswa',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
              child: Center(
                child: Text('Coba Dlu gan'),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  color: index.isOdd ? Colors.white : Colors.black12,
                  height: 100.0,
                  child: Center(
                    child: Text('$index', textScaleFactor: 5),
                  ),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}
