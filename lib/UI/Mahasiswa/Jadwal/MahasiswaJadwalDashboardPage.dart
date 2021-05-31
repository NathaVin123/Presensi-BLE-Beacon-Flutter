import 'package:flutter/material.dart';
import 'package:presensiblebeacon/MODEL/JadwalMahasiswaModel.dart';
import 'package:shimmer/shimmer.dart';
import 'package:presensiblebeacon/API/APIService.dart';

class MahasiswaJadwalDashboardPage extends StatefulWidget {
  MahasiswaJadwalDashboardPage({Key key}) : super(key: key);

  @override
  _MahasiswaJadwalDashboardPageState createState() =>
      _MahasiswaJadwalDashboardPageState();
}

class _MahasiswaJadwalDashboardPageState
    extends State<MahasiswaJadwalDashboardPage> {
  JadwalMahasiswaRequestModel jadwalMahasiswaRequestModel;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _jadwal = <JadwalMahasiswaRequestModel>[];

  @override
  void initState() {
    super.initState();
    jadwalMahasiswaRequestModel = new JadwalMahasiswaRequestModel();

    APIService apiService = new APIService();
    apiService
        .jadwalMahasiswa(jadwalMahasiswaRequestModel)
        .then((value) async {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(slivers: <Widget>[
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
                'Jadwal',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'WorkSansMedium'),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Shimmer.fromColors(
                baseColor: Colors.grey[200],
                highlightColor: Colors.grey[100],
                enabled: true,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(25)),
                        child: Flexible(
                          child: ListTile(
                            title: Text(' '),
                            subtitle: Text(' '),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(25)),
                        child: Flexible(
                          child: ListTile(
                            title: Text(' '),
                            subtitle: Text(' '),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(25)),
                        child: Flexible(
                          child: ListTile(
                            title: Text(' '),
                            subtitle: Text(' '),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(25)),
                        child: Flexible(
                          child: ListTile(
                            title: Text(' '),
                            subtitle: Text(' '),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(25)),
                        child: Flexible(
                          child: ListTile(
                            title: Text(' '),
                            subtitle: Text(' '),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(25)),
                        child: Flexible(
                          child: ListTile(
                            title: Text(' '),
                            subtitle: Text(' '),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(25)),
                        child: Flexible(
                          child: ListTile(
                            title: Text(' '),
                            subtitle: Text(' '),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(25)),
                        child: Flexible(
                          child: ListTile(
                            title: Text(' '),
                            subtitle: Text(' '),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              // SingleChildScrollView(
              //   child: Column(
              //     children: ListTile.divideTiles(
              //         context: context,
              //         tiles: _jadwal.map((jadwal) {
              //           return Padding(
              //             padding: EdgeInsets.all(10),
              //             child: Container(
              //               decoration: BoxDecoration(
              //                   color: Colors.grey[200],
              //                   borderRadius: BorderRadius.circular(25)),
              //             ),
              //           );
              //         })),
              //   ),
              // )
            ]),
          )
        ]));
  }
}
