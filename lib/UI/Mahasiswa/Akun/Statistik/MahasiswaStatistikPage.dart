import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class MahasiswaStatistikPage extends StatefulWidget {
  MahasiswaStatistikPage({Key key}) : super(key: key);

  @override
  _MahasiswaStatistikPageState createState() => _MahasiswaStatistikPageState();
}

class _MahasiswaStatistikPageState extends State<MahasiswaStatistikPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(23, 75, 137, 1),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color.fromRGBO(23, 75, 137, 1),
          centerTitle: true,
          title: Text(
            'Statistik Mahasiswa',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'WorkSansMedium',
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
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
        ));
  }
}
