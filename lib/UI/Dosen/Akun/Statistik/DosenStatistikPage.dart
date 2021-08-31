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
      backgroundColor: Color.fromRGBO(23, 75, 137, 1),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Color.fromRGBO(23, 75, 137, 1),
            pinned: true,
            floating: false,
            snap: false,
            expandedHeight: 85,
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Statistik',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'WorkSansMedium',
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverFillRemaining(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      Text(
                        '-',
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
                        progressColor: Color.fromRGBO(247, 180, 7, 1),
                        currentValue: 80,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )),
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
