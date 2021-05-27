import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MahasiswaRiwayatDashboardPage extends StatelessWidget {
  const MahasiswaRiwayatDashboardPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'Riwayat',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'WorkSansMedium',
                      fontWeight: FontWeight.bold),
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
              ]),
            )
          ],
        ));
  }
}
