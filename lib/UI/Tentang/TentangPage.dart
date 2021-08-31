import 'package:flutter/material.dart';
import 'package:presensiblebeacon/Utils/extension_image.dart';

class TentangPage extends StatefulWidget {
  TentangPage({Key key}) : super(key: key);

  @override
  _TentangPageState createState() => _TentangPageState();
}

class _TentangPageState extends State<TentangPage> {
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
                'Tentang Aplikasi',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'WorkSansMedium',
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 14, right: 14, top: 14),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(25)),
                        // decoration: BoxDecoration(),
                        child: Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.all(22),
                                child: CircleAvatar(
                                    backgroundColor: Colors.grey[350],
                                    radius: 50,
                                    // child: const Text('NV'),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.asset(
                                        'SplashPage_LogoAtmaJaya'.png,
                                      ),
                                    ))),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text('Sistem Presensi UAJY',
                                        style: const TextStyle(
                                            fontFamily: 'WorkSansSemiBold',
                                            fontSize: 22.0,
                                            color: Colors.black)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                          'Aplikasi untuk mengisi data kehadiran perkuliahan new normal mahasiswa dan dosen dengan teknologi bluetooth low energy.',
                                          style: const TextStyle(
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 16,
                                              color: Colors.black)),
                                    ),
                                  ),
                                  Divider(
                                    height: 20,
                                    thickness: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          Text('KSI UAJY',
                                              style: const TextStyle(
                                                  fontFamily: 'WorkSansMedium',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.black)),
                                          Text('2021',
                                              style: const TextStyle(
                                                  fontFamily: 'WorkSansMedium',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.black)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text('Version Pre-Alpha',
                                          style: const TextStyle(
                                              fontFamily: 'WorkSansMedium',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black)),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                ],
              ),
            ),
          )

          // SliverList(
          //   delegate: SliverChildBuilderDelegate(
          //     (BuildContext context, int index) {
          //       return Container(
          //         color: index.isOdd ? Colors.white : Colors.black12,
          //         height: 100.0,
          //         child: Center(
          //           child: Text('$index', textScaleFactor: 5),
          //         ),
          //       );
          //     },
          //     childCount: 20,
          //   ),
          // ),
        ],
      ),
    );
  }
}
