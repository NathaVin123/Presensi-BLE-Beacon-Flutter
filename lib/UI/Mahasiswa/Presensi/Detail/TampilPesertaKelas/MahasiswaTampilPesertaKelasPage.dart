import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Presensi/TampilPesertaKelasModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MahasiswaTampilPesertaKelasPage extends StatefulWidget {
  @override
  _MahasiswaTampilPesertaKelasPageState createState() =>
      _MahasiswaTampilPesertaKelasPageState();
}

class _MahasiswaTampilPesertaKelasPageState
    extends State<MahasiswaTampilPesertaKelasPage> {
  int idkelas = 0;
  TampilPesertaKelasRequestModel tampilPesertaKelasRequestModel;
  TampilPesertaKelasResponseModel tampilPesertaKelasResponseModel;

  @override
  void initState() {
    super.initState();

    tampilPesertaKelasRequestModel = TampilPesertaKelasRequestModel();
    tampilPesertaKelasResponseModel = TampilPesertaKelasResponseModel();

    this.getDataIDKelas();
  }

  getDataIDKelas() async {
    SharedPreferences datapresensiMahasiswa =
        await SharedPreferences.getInstance();

    setState(() {
      idkelas = datapresensiMahasiswa.getInt('idkelas');
    });
  }

  void getDataPesertaKelas() async {
    setState(() {
      tampilPesertaKelasRequestModel.idkelas = idkelas;

      print(tampilPesertaKelasRequestModel.toJson());

      APIService apiService = new APIService();

      apiService
          .postListPesertaKelas(tampilPesertaKelasRequestModel)
          .then((value) async {
        tampilPesertaKelasResponseModel = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          label: Text('Segarkan'),
          icon: Icon(Icons.refresh_rounded),
          onPressed: () => getDataPesertaKelas()),
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
                'Tampil Peserta Kelas',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'WorkSansMedium',
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverFillRemaining(
              child: tampilPesertaKelasResponseModel.data == null
                  ? Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            'Silahkan klik tombol segarkan...',
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'WorkSansMedium',
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: tampilPesertaKelasResponseModel.data?.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 8, bottom: 8),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(25)),
                            child: new ListTile(
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    new Text(
                                      tampilPesertaKelasResponseModel
                                          .data[index].namamhs,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'WorkSansMedium',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    new Text(
                                      tampilPesertaKelasResponseModel
                                          .data[index].npm,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'WorkSansMedium',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {},
                            ),
                          ),
                        );
                      }))
        ],
      ),
    );
  }
}
