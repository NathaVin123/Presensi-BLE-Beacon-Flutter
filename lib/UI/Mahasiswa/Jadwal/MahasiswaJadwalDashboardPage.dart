import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MahasiswaJadwalDashboardPage extends StatelessWidget {
  const MahasiswaJadwalDashboardPage({Key key}) : super(key: key);

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
              centerTitle: false,
              title: Text(
                'Jadwal',
                style: TextStyle(color: Colors.black),
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
                            title: Text('Blaaaaaaaaaaaaaaaaaaaaaa'),
                            subtitle: Text('Blaaaaaaaaaaaaaaaaaaa'),
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
                            title: Text('Blaaaaaaaaaaaaaaaaaaaaaa'),
                            subtitle: Text('Blaaaaaaaaaaaaaaaaaaa'),
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
                            title: Text('Blaaaaaaaaaaaaaaaaaaaaaa'),
                            subtitle: Text('Blaaaaaaaaaaaaaaaaaaa'),
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
                            title: Text('Blaaaaaaaaaaaaaaaaaaaaaa'),
                            subtitle: Text('Blaaaaaaaaaaaaaaaaaaa'),
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
                            title: Text('Blaaaaaaaaaaaaaaaaaaaaaa'),
                            subtitle: Text('Blaaaaaaaaaaaaaaaaaaa'),
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
                            title: Text('Blaaaaaaaaaaaaaaaaaaaaaa'),
                            subtitle: Text('Blaaaaaaaaaaaaaaaaaaa'),
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
                            title: Text('Blaaaaaaaaaaaaaaaaaaaaaa'),
                            subtitle: Text('Blaaaaaaaaaaaaaaaaaaa'),
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
                            title: Text('Blaaaaaaaaaaaaaaaaaaaaaa'),
                            subtitle: Text('Blaaaaaaaaaaaaaaaaaaa'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]),
          )
        ])
        // Column(
        //   children: [
        //     SizedBox(
        //       height: 45,
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.only(left: 25, right: 25),
        //       child: Align(
        //         alignment: Alignment.topLeft,
        //         child: Text(
        //           'Jadwal',
        //           style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        //         ),
        //       ),
        //     ),
        //     Expanded(
        //         child: ListView(
        //       children: const <Widget>[
        //         Flexible(
        //             child: ListTile(
        //           title: Text('Tes'),
        //         )),
        //       ],
        //     ))
        //   ],
        // ),
        );
  }
}
