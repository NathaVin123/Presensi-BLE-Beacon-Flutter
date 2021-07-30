import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class DosenStatistikPage extends StatefulWidget {
  DosenStatistikPage({Key key}) : super(key: key);

  @override
  _DosenStatistikPageState createState() => _DosenStatistikPageState();
}

class _DosenStatistikPageState extends State<DosenStatistikPage> {
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
          SliverFillRemaining(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Center(
                  child: Column(
                children: <Widget>[
                  Text(
                    'Nama Matakuliah',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'WorkSansMedium',
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FAProgressBar(
                    currentValue: 80,
                    displayText: '%',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Nama Matakuliah',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'WorkSansMedium',
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FAProgressBar(
                    currentValue: 40,
                    displayText: '%',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Nama Matakuliah',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'WorkSansMedium',
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FAProgressBar(
                    currentValue: 50,
                    displayText: '%',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Nama Matakuliah',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'WorkSansMedium',
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FAProgressBar(
                    currentValue: 20,
                    displayText: '%',
                  ),
                ],
              )),
            ),
          ))
        ],
      ),
    );
  }
}
