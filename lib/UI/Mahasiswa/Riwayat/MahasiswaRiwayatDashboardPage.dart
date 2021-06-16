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
                  'Riwayat Kelas',
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'WorkSansMedium',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(25)),
                          child: Flexible(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.yellow[600],
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            '03/06/2021',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'WorkSansMedium',
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          'Pertemuan ke - 5',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 10,
                                  thickness: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          'Magang',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Center(
                                        child: Text(
                                          'Kelas B',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 18),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Center(
                                        child: Text(
                                          'Dosen Tek. Informatika',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(25)),
                          child: Flexible(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.yellow[600],
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            '03/05/2021',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'WorkSansMedium',
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          'Pertemuan ke - 4',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 10,
                                  thickness: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          'Magang',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Center(
                                        child: Text(
                                          'Kelas A',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 18),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Center(
                                        child: Text(
                                          'Dosen Tek. Informatika',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(25)),
                          child: Flexible(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.yellow[600],
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            '03/04/2021',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'WorkSansMedium',
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          'Pertemuan ke - 3',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 10,
                                  thickness: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          'Magang',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Center(
                                        child: Text(
                                          'Kelas E',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 18),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Center(
                                        child: Text(
                                          'Dosen Tek. Informatika',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(25)),
                          child: Flexible(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.yellow[600],
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            '03/03/2021',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'WorkSansMedium',
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          'Pertemuan ke - 2',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 10,
                                  thickness: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          'Magang',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Center(
                                        child: Text(
                                          'Kelas B',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 18),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Center(
                                        child: Text(
                                          'Dosen Tek. Informatika',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(25)),
                          child: Flexible(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.yellow[600],
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            '03/02/2021',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'WorkSansMedium',
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          'Pertemuan ke - 1',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 10,
                                  thickness: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          'Magang',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Center(
                                        child: Text(
                                          'Kelas B',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 18),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Center(
                                        child: Text(
                                          'Dosen Tek. Informatika',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                // Shimmer.fromColors(
                //   baseColor: Colors.grey[200],
                //   highlightColor: Colors.grey[100],
                //   enabled: true,
                //   child: Column(
                //     children: [
                //       Padding(
                //         padding: EdgeInsets.all(10),
                //         child: Container(
                //           decoration: BoxDecoration(
                //               color: Colors.grey,
                //               borderRadius: BorderRadius.circular(25)),
                //           child: Flexible(
                //             child: ListTile(
                //               title: Text(' '),
                //               subtitle: Text(' '),
                //             ),
                //           ),
                //         ),
                //       ),
                //       Padding(
                //         padding: EdgeInsets.all(10),
                //         child: Container(
                //           decoration: BoxDecoration(
                //               color: Colors.grey,
                //               borderRadius: BorderRadius.circular(25)),
                //           child: Flexible(
                //             child: ListTile(
                //               title: Text(' '),
                //               subtitle: Text(' '),
                //             ),
                //           ),
                //         ),
                //       ),
                //       Padding(
                //         padding: EdgeInsets.all(10),
                //         child: Container(
                //           decoration: BoxDecoration(
                //               color: Colors.grey,
                //               borderRadius: BorderRadius.circular(25)),
                //           child: Flexible(
                //             child: ListTile(
                //               title: Text(' '),
                //               subtitle: Text(' '),
                //             ),
                //           ),
                //         ),
                //       ),
                //       Padding(
                //         padding: EdgeInsets.all(10),
                //         child: Container(
                //           decoration: BoxDecoration(
                //               color: Colors.grey,
                //               borderRadius: BorderRadius.circular(25)),
                //           child: Flexible(
                //             child: ListTile(
                //               title: Text(' '),
                //               subtitle: Text(' '),
                //             ),
                //           ),
                //         ),
                //       ),
                //       Padding(
                //         padding: EdgeInsets.all(10),
                //         child: Container(
                //           decoration: BoxDecoration(
                //               color: Colors.grey,
                //               borderRadius: BorderRadius.circular(25)),
                //           child: Flexible(
                //             child: ListTile(
                //               title: Text(' '),
                //               subtitle: Text(' '),
                //             ),
                //           ),
                //         ),
                //       ),
                //       Padding(
                //         padding: EdgeInsets.all(10),
                //         child: Container(
                //           decoration: BoxDecoration(
                //               color: Colors.grey,
                //               borderRadius: BorderRadius.circular(25)),
                //           child: Flexible(
                //             child: ListTile(
                //               title: Text(' '),
                //               subtitle: Text(' '),
                //             ),
                //           ),
                //         ),
                //       ),
                //       Padding(
                //         padding: EdgeInsets.all(10),
                //         child: Container(
                //           decoration: BoxDecoration(
                //               color: Colors.grey,
                //               borderRadius: BorderRadius.circular(25)),
                //           child: Flexible(
                //             child: ListTile(
                //               title: Text(' '),
                //               subtitle: Text(' '),
                //             ),
                //           ),
                //         ),
                //       ),
                //       Padding(
                //         padding: EdgeInsets.all(10),
                //         child: Container(
                //           decoration: BoxDecoration(
                //               color: Colors.grey,
                //               borderRadius: BorderRadius.circular(25)),
                //           child: Flexible(
                //             child: ListTile(
                //               title: Text(' '),
                //               subtitle: Text(' '),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // )
              ]),
            )
          ],
        ));
  }
}
