import 'dart:async';

import 'package:flutter/material.dart';
import 'package:presensiblebeacon/MODEL/Mahasiswa/JadwalMahasiswaModel.dart';
import 'package:shimmer/shimmer.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:intl/intl.dart';

class DosenJadwalDashboardPage extends StatefulWidget {
  DosenJadwalDashboardPage({Key key}) : super(key: key);

  @override
  _DosenJadwalDashboardPageState createState() =>
      _DosenJadwalDashboardPageState();
}

class Semester {
  String semester;
  Semester(this.semester);
}

class _DosenJadwalDashboardPageState extends State<DosenJadwalDashboardPage> {
  String _dateString;

  String npm = "";
  String semesterShared = "";

  String data;

  Semester selectedSemester;

  List<Semester> semesters = [
    Semester("1"),
    Semester("2"),
    Semester("3"),
    Semester("4"),
    Semester("5"),
    Semester("6"),
    Semester("7"),
    Semester("8"),
  ];

  List<DropdownMenuItem> generateSemester(List<Semester> semesters) {
    List<DropdownMenuItem> items = [];

    for (var item in semesters) {
      items.add(DropdownMenuItem(
        child: Text((item.semester)),
        value: item,
      ));
    }
    return items;
  }

  @override
  void initState() {
    super.initState();

    _dateString = _formatDate(DateTime.now());
    Timer.periodic(Duration(hours: 1), (Timer t) => _getDate());
  }

  void _getDate() {
    final DateTime now = DateTime.now();
    final String formattedDate = _formatDate(now);

    setState(() {
      _dateString = formattedDate;
    });
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            label: Text('Segarkan'),
            icon: Icon(Icons.refresh_rounded),
            onPressed: () {}),
        backgroundColor: Color.fromRGBO(23, 75, 137, 1),
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
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
                'Jadwal Kelas',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'WorkSansMedium'),
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            _dateString,
                            style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'WorkSansMedium',
                                color: Colors.white),
                          ),
                        ),
                      ],
                    )),
                Center(
                    child: Text(
                  'Pilih Semester',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'WorkSansMedium',
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
                SizedBox(
                  height: 8,
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                          color: Colors.white,
                          style: BorderStyle.solid,
                          width: 1),
                    ),
                    child: DropdownButton(
                      iconEnabledColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      dropdownColor: Color.fromRGBO(23, 75, 137, 1),
                      underline: Text(''),
                      onTap: () => {},
                      items: generateSemester(semesters),
                      value: selectedSemester,
                      onChanged: (item) {
                        setState(() {
                          selectedSemester = item;
                          semesterShared = selectedSemester.semester;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          )),
          SliverFillRemaining()
        ]));
  }
}
