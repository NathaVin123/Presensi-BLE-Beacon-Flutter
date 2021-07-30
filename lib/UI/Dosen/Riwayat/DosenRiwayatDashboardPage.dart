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
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              pinned: true,
              floating: false,
              snap: false,
              expandedHeight: 85,
              flexibleSpace: const FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  'Riwayat Presensi',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'WorkSansMedium',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Center(
                        child: Text(
                      'Pilih Semester',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'WorkSansMedium',
                          fontWeight: FontWeight.bold),
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
                              color: Colors.grey,
                              style: BorderStyle.solid,
                              width: 1),
                        ),
                        child: DropdownButton(
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
            ),
          ],
        ));
  }
}
