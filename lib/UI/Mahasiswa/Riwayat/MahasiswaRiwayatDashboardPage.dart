import 'package:flutter/material.dart';

class MahasiswaRiwayatDashboardPage extends StatelessWidget {
  const MahasiswaRiwayatDashboardPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
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
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Flexible(
                    child: ListTile(
                  title: Text('Tes'),
                )),
                Flexible(
                    child: ListTile(
                  title: Text('Tes'),
                )),
                Flexible(
                    child: ListTile(
                  title: Text('Tes'),
                )),
                Flexible(
                    child: ListTile(
                  title: Text('Tes'),
                )),
                Flexible(
                    child: ListTile(
                  title: Text('Tes'),
                )),
                Flexible(
                    child: ListTile(
                  title: Text('Tes'),
                )),
                Flexible(
                    child: ListTile(
                  title: Text('Tes'),
                )),
                Flexible(
                    child: ListTile(
                  title: Text('Tes'),
                )),
                Flexible(
                    child: ListTile(
                  title: Text('Tes'),
                )),
                Flexible(
                    child: ListTile(
                  title: Text('Tes'),
                )),
                Flexible(
                    child: ListTile(
                  title: Text('Tes'),
                )),
                Flexible(
                    child: ListTile(
                  title: Text('Tes'),
                )),
                Flexible(
                    child: ListTile(
                  title: Text('Tes'),
                )),
                Flexible(
                    child: ListTile(
                  title: Text('Tes'),
                )),
                Flexible(
                    child: ListTile(
                  title: Text('Tes'),
                )),
                Flexible(
                    child: ListTile(
                  title: Text('Tes'),
                )),
              ]),
            )
          ],
        )
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

        //   ],
        // ),
        );
  }
}
