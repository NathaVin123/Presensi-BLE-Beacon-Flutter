import 'package:flutter/material.dart';

class DosenRiwayatDashboardPage extends StatefulWidget {
  DosenRiwayatDashboardPage({Key key}) : super(key: key);

  @override
  _DosenRiwayatDashboardPageState createState() =>
      _DosenRiwayatDashboardPageState();
}

class Semester {
  String semester;
  Semester(this.semester);
}

class _DosenRiwayatDashboardPageState extends State<DosenRiwayatDashboardPage> {
  String npp = "";
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Segarkan'),
        icon: Icon(Icons.refresh_rounded),
        onPressed: () => {},
      ),
      backgroundColor: Color.fromRGBO(23, 75, 137, 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(23, 75, 137, 1),
        centerTitle: true,
        title: Text(
          'Riwayat Presensi',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'WorkSansMedium',
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Center(
                child: Text(
              'Pilih Semester',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'WorkSansMedium',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
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
                      color: Colors.white, style: BorderStyle.solid, width: 1),
                ),
                child: DropdownButton(
                  iconEnabledColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  dropdownColor: Color.fromRGBO(23, 75, 137, 1),
                  underline: Text(''),
                  // style: TextStyle(
                  //   fontFamily: 'WorkSansMedium',
                  // ),
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
      ),
    );
  }
}
