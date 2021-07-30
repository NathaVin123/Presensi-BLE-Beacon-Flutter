import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Beacon/RuangBeaconModel.dart';
import 'package:presensiblebeacon/Utils/extension_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:system_setting/system_setting.dart';

class MahasiswaPresensiDashboardPage extends StatefulWidget {
  @override
  _MahasiswaPresensiDashboardPageState createState() =>
      _MahasiswaPresensiDashboardPageState();
}

class _MahasiswaPresensiDashboardPageState
    extends State<MahasiswaPresensiDashboardPage> with WidgetsBindingObserver {
  final StreamController<BluetoothState> streamController = StreamController();

  RuangBeaconResponseModel ruangBeaconResponseModel;

  StreamSubscription<BluetoothState> _streamBluetooth;
  StreamSubscription<RangingResult> _streamRanging;

  final _regionBeacons = <Region, List<Beacon>>{};
  final _beacons = <Beacon>[];
  final _regions = <Region>[];

  bool authorizationStatusOk = false;
  bool locationServiceEnabled = false;
  bool bluetoothEnabled = false;

  String _timeString;
  String _dateString;

  String namamhs = "";

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();

    ruangBeaconResponseModel = RuangBeaconResponseModel();

    _timeString = _formatTime(DateTime.now());
    _dateString = _formatDate(DateTime.now());

    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    Timer.periodic(Duration(hours: 1), (Timer t) => _getDate());

    getDataMahasiswa();

    getDataRuangBeacon();

    // listeningState();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedTime = _formatTime(now);

    setState(() {
      _timeString = formattedTime;
    });
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

  String _formatTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss').format(dateTime);
  }

  listeningState() async {
    if (Platform.isAndroid) {
      print('Listening to bluetooth state');
      _streamBluetooth = flutterBeacon
          .bluetoothStateChanged()
          .listen((BluetoothState state) async {
        print('BluetoothState = $state');
        streamController.add(state);
        if (BluetoothState.stateOn == state) {
          initScanBeacon();
        }
        if (BluetoothState.stateOff == state) {
          await pauseScanBeacon();
          await checkAllRequirements();
        }
      });
    } else if (Platform.isIOS) {
      print('Listening to bluetooth state');
      _streamBluetooth = flutterBeacon
          .bluetoothStateChanged()
          .listen((BluetoothState state) async {
        print('BluetoothState = $state');
        streamController.add(state);

        if (BluetoothState.stateOn == state) {
          initScanBeacon();
        }
        if (BluetoothState.stateOff == state) {
          await pauseScanBeacon();
        }
      });
    }
  }

  initScanBeacon() async {
    await flutterBeacon.initializeScanning;
    await checkAllRequirements();
    if (!authorizationStatusOk ||
        !locationServiceEnabled ||
        !bluetoothEnabled) {
      print('RETURNED, authorizationStatusOk=$authorizationStatusOk, '
          'locationServiceEnabled=$locationServiceEnabled, '
          'bluetoothEnabled=$bluetoothEnabled');
      return;
    }

    if (_streamRanging != null) {
      if (_streamRanging.isPaused) {
        _streamRanging.resume();
        return;
      }
    }

    // Bluetooth ranging Algorithm 1
    if (Platform.isIOS) {
      _regions.add(Region(
          identifier: '',
          proximityUUID: 'fda50693-a4e2-4fb1-afcf-c6eb07647825'));
      _regions.add(Region(
          identifier: '',
          proximityUUID: 'b9407f30-f5f8-466e-aff9-25556b57fe6d'));
      _streamRanging =
          flutterBeacon.ranging(_regions).listen((RangingResult result) {
        print(result);
        if (result != null && mounted) {
          setState(() {
            _regionBeacons[result.region] = result.beacons;
            _beacons.clear();
            _regionBeacons.values.forEach((list) {
              _beacons.addAll(list);
            });
            _beacons.sort(_compareParameters);
            Timer(Duration(seconds: 2), () => _streamRanging?.pause());
          });
        }
      });
    } else if (Platform.isAndroid) {
      _regions.add(Region(
        identifier: '',
      ));
      _streamRanging =
          flutterBeacon.ranging(_regions).listen((RangingResult result) {
        print(result);
        if (result != null && mounted) {
          setState(() {
            _regionBeacons[result.region] = result.beacons;
            _beacons.clear();
            _regionBeacons.values.forEach((list) {
              _beacons.addAll(list);
            });
            _beacons.sort(_compareParameters);
            Timer(Duration(seconds: 2), () => _streamRanging?.pause());
          });
        }
      });
    }

    // Bluetooth ranging Algorithm 1
    // if (Platform.isIOS) {
    //   _streamRanging = flutterBeacon.ranging(<Region>[
    //     new Region(
    //       identifier: '',
    //       proximityUUID: 'fda50693-a4e2-4fb1-afcf-c6eb07647825',
    //     ),
    //     new Region(
    //         identifier: '',
    //         proximityUUID: 'b9407f30-f5f8-466e-aff9-25556b57fe6d')
    //   ]).listen((RangingResult result) {
    //     print(result);
    //     if (result != null && mounted) {
    //       setState(() {
    //         _regionBeacons[result.region] = result.beacons;
    //         _beacons.clear();
    //         _regionBeacons.values.forEach((list) {
    //           _beacons.addAll(list);
    //         });
    //         _beacons.sort(_compareParameters);
    //         Timer(Duration(seconds: 2), () => _streamRanging?.pause());
    //       });
    //     }
    //   });
    // } else if (Platform.isAndroid) {
    //   _streamRanging = flutterBeacon.ranging(<Region>[
    //     new Region(
    //       identifier: '',
    //     )
    //   ]).listen((RangingResult result) {
    //     print(result);
    //     if (result != null && mounted) {
    //       setState(() {
    //         _regionBeacons[result.region] = result.beacons;
    //         _beacons.clear();
    //         _regionBeacons.values.forEach((list) {
    //           _beacons.addAll(list);
    //         });
    //         _beacons.sort(_compareParameters);
    //         Timer(Duration(seconds: 2), () => _streamRanging?.pause());
    //       });
    //     }
    //   });
    // }
  }

  checkAllRequirements() async {
    final bluetoothState = await flutterBeacon.bluetoothState;
    final bluetoothEnabled = bluetoothState == BluetoothState.stateOn;
    final authorizationStatus = await flutterBeacon.authorizationStatus;
    final authorizationStatusOk =
        authorizationStatus == AuthorizationStatus.allowed ||
            authorizationStatus == AuthorizationStatus.always;
    final locationServiceEnabled =
        await flutterBeacon.checkLocationServicesIfEnabled;

    setState(() {
      this.authorizationStatusOk = authorizationStatusOk;
      this.locationServiceEnabled = locationServiceEnabled;
      this.bluetoothEnabled = bluetoothEnabled;
    });
  }

  pauseScanBeacon() async {
    _streamRanging?.pause();
    if (_beacons.isNotEmpty) {
      setState(() {
        _beacons.clear();
      });
    }
  }

  int _compareParameters(Beacon a, Beacon b) {
    int compare = a.proximityUUID.compareTo(b.proximityUUID);

    if (compare == 0) {
      compare = a.major.compareTo(b.major);
    }

    if (compare == 0) {
      compare = a.minor.compareTo(b.minor);
    }

    return compare;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (Platform.isAndroid) {
      print('AppLifecycleState = $state');
      if (state == AppLifecycleState.resumed) {
        if (_streamBluetooth != null && _streamBluetooth.isPaused) {
          _streamBluetooth.resume();
        }
        await checkAllRequirements();
        if (authorizationStatusOk &&
            locationServiceEnabled &&
            bluetoothEnabled) {
          await initScanBeacon();
        } else {
          await pauseScanBeacon();
          await checkAllRequirements();
        }
      } else if (state == AppLifecycleState.paused) {
        _streamBluetooth?.pause();
      }
    } else if (Platform.isIOS) {
      print('AppLifecycleState = $state');
      if (state == AppLifecycleState.resumed) {
        if (_streamBluetooth != null && _streamBluetooth.isPaused) {
          _streamBluetooth.resume();
        }
      } else if (state == AppLifecycleState.paused) {
        _streamBluetooth?.pause();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    streamController?.close();
    _streamRanging?.cancel();
    _streamBluetooth?.cancel();
    flutterBeacon.close;

    super.dispose();
  }

  // void getModalKelas() async {
  //   SharedPreferences modalKelas = await SharedPreferences.getInstance();
  //   setState(() {
  //     kelas = modalKelas.getString('Kelas');
  //     jam = modalKelas.getString('Jam');
  //   });
  // }

  void getDataMahasiswa() async {
    SharedPreferences loginMahasiswa = await SharedPreferences.getInstance();
    setState(() {
      namamhs = loginMahasiswa.getString('namamhs');
    });
  }

  void getDataRuangBeacon() async {
    setState(() {
      print(ruangBeaconResponseModel.toJson());
      APIService apiService = new APIService();
      apiService.getKelasBeacon().then((value) async {
        ruangBeaconResponseModel = value;
      });
    });
  }

  // void getDataBeacon() async {
  //   SharedPreferences dataBeacon = await SharedPreferences.getInstance();
  //   _beacons.map((beacon) async {
  //     await dataBeacon.setString('UUID', beacon.proximityUUID);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton.extended(
            // onPressed: () => {_streamRanging?.resume(), getDataRuangBeacon()},
            onPressed: () => getDataRuangBeacon(),
            label: Text(
              'Segarkan',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'WorkSansMedium'),
            ),
            icon: Icon(Icons.search_rounded),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndFloat,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.black,
              ),
              onPressed: () =>
                  Get.toNamed('/mahasiswa/dashboard/presensi/notifikasi'),
            ),
            title: Image.asset(
              'SplashPage_LogoAtmaJaya'.png,
              height: 30,
            ),
            centerTitle: true,
            // actions: <Widget>[
            //   if (!authorizationStatusOk)
            //     IconButton(
            //         icon: Icon(Icons.portable_wifi_off),
            //         color: Colors.red,
            //         onPressed: () async {
            //           await flutterBeacon.requestAuthorization;
            //         }),
            //   if (!locationServiceEnabled)
            //     IconButton(
            //         icon: Icon(Icons.location_off),
            //         color: Colors.red,
            //         onPressed: () async {
            //           if (Platform.isAndroid) {
            //             await flutterBeacon.openLocationSettings;
            //           } else if (Platform.isIOS) {
            //             await _jumpToSetting();
            //           }
            //         }),
            //   StreamBuilder<BluetoothState>(
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         final state = snapshot.data;

            //         if (state == BluetoothState.stateOn) {
            //           return IconButton(
            //             icon: Icon(Icons.bluetooth_connected),
            //             onPressed: () {},
            //             color: Colors.blue,
            //           );
            //         }

            //         if (state == BluetoothState.stateOff) {
            //           return IconButton(
            //             icon: Icon(Icons.bluetooth),
            //             onPressed: () async {
            //               if (Platform.isAndroid) {
            //                 try {
            //                   await flutterBeacon.openBluetoothSettings;
            //                 } on PlatformException catch (e) {
            //                   print(e);
            //                 }
            //               } else if (Platform.isIOS) {
            //                 try {
            //                   await _jumpToSetting();
            //                 } on PlatformException catch (e) {
            //                   print(e);
            //                 }
            //               }
            //             },
            //             color: Colors.red,
            //           );
            //         }

            //         return IconButton(
            //           icon: Icon(Icons.bluetooth_disabled),
            //           onPressed: () {},
            //           color: Colors.grey,
            //         );
            //       }

            //       return SizedBox.shrink();
            //     },
            //     stream: streamController.stream,
            //     initialData: BluetoothState.stateUnknown,
            //   ),
            // ],
          ),
          body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: Column(
                  children: [
                    Center(
                      // alignment: Alignment.centerRight,
                      child: Text(
                        _dateString,
                        style: TextStyle(
                            fontSize: 22, fontFamily: 'WorkSansMedium'),
                      ),
                    ),
                    Center(
                      // alignment: Alignment.centerLeft,
                      child: Text(
                        _timeString,
                        style: TextStyle(
                            fontSize: 40, fontFamily: 'WorkSansMedium'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          new Text(
                            'Halo, ',
                            style: TextStyle(
                                fontSize: 20, fontFamily: 'WorkSansMedium'),
                          ),
                          new Text(
                            '${namamhs ?? "-"}',
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'WorkSansMedium',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(
              //       left: 20, right: 20, top: 10, bottom: 10),
              //   child: Center(
              //     // alignment: Alignment.topLeft,
              //     child: Text(
              //       'Kuliah Selanjutnya',
              //       style: TextStyle(
              //           fontSize: 22,
              //           fontWeight: FontWeight.bold,
              //           fontFamily: 'WorkSansMedium'),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 10, bottom: 10),
              //   child: CarouselSlider(
              //     items: [
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Container(
              //           decoration: BoxDecoration(
              //               color: Colors.grey[200],
              //               borderRadius: BorderRadius.circular(25)),
              //           child: Padding(
              //             padding: EdgeInsets.all(10),
              //             child: Column(
              //               children: [
              //                 Align(
              //                   alignment: Alignment.centerLeft,
              //                   child: Padding(
              //                     padding: const EdgeInsets.all(5.0),
              //                     child: Text('Mata Kuliah : -',
              //                         style: TextStyle(
              //                             fontSize: 14,
              //                             fontWeight: FontWeight.bold,
              //                             fontFamily: 'WorkSansMedium')),
              //                   ),
              //                 ),
              //                 Align(
              //                   alignment: Alignment.centerLeft,
              //                   child: Padding(
              //                     padding: const EdgeInsets.all(5.0),
              //                     child: Text('Ruangan : -',
              //                         style: TextStyle(
              //                             fontSize: 14,
              //                             fontWeight: FontWeight.bold,
              //                             fontFamily: 'WorkSansMedium')),
              //                   ),
              //                 ),
              //                 Align(
              //                   alignment: Alignment.centerLeft,
              //                   child: Padding(
              //                     padding: const EdgeInsets.all(5.0),
              //                     child: Text('Sesi : -',
              //                         style: TextStyle(
              //                             fontSize: 14,
              //                             fontWeight: FontWeight.bold,
              //                             fontFamily: 'WorkSansMedium')),
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //     ],
              //     options: CarouselOptions(
              //         initialPage: 0,
              //         enlargeCenterPage: false,
              //         height: 125,
              //         scrollDirection: Axis.horizontal,
              //         autoPlay: true,
              //         autoPlayAnimationDuration: Duration(seconds: 1)),
              //   ),
              // ),
              Divider(
                height: 20,
                thickness: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 25, top: 10, bottom: 5),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Center(
                    child: Text(
                      'Kuliah Hari Ini',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'WorkSansMedium'),
                    ),
                  ),
                ),
              ),
              ruangBeaconResponseModel.data == null
                  ? Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            'Silakan tekan tombol segarkan',
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'WorkSansMedium',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                          itemCount: ruangBeaconResponseModel.data?.length,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        new Text(
                                          ruangBeaconResponseModel
                                              .data[index].ruang,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'WorkSansMedium',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        new Text(
                                          'Mata Kuliah : ${ruangBeaconResponseModel.data[index].namamk}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'WorkSansMedium',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // subtitle: Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: Column(
                                  //     children: <Widget>[
                                  //       Text(
                                  //         jadwalMahasiswaResponseModel
                                  //             .data[index].namadosen,
                                  //         style: TextStyle(
                                  //           fontSize: 14,
                                  //           fontFamily: 'WorkSansMedium',
                                  //         ),
                                  //       ),
                                  //       Padding(
                                  //         padding: const EdgeInsets.all(8.0),
                                  //         child: Row(
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.spaceAround,
                                  //           children: <Widget>[
                                  //             Text(
                                  //               jadwalMahasiswaResponseModel
                                  //                   .data[index].hari,
                                  //               style: TextStyle(
                                  //                 fontSize: 12,
                                  //                 fontFamily: 'WorkSansMedium',
                                  //               ),
                                  //             ),
                                  //             Text(
                                  //               'Ruang ${jadwalMahasiswaResponseModel.data[index].ruang}',
                                  //               style: TextStyle(
                                  //                 fontSize: 12,
                                  //                 fontFamily: 'WorkSansMedium',
                                  //               ),
                                  //             ),
                                  //             Text(
                                  //               'Sesi ${jadwalMahasiswaResponseModel.data[index].sesi}',
                                  //               style: TextStyle(
                                  //                 fontSize: 12,
                                  //                 fontFamily: 'WorkSansMedium',
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  onTap: () async {
                                    SharedPreferences dataPresensiMahasiswa =
                                        await SharedPreferences.getInstance();
                                    await dataPresensiMahasiswa.setString(
                                        'ruang',
                                        ruangBeaconResponseModel
                                            .data[index].ruang);
                                    await dataPresensiMahasiswa.setString(
                                        'namamk',
                                        ruangBeaconResponseModel
                                            .data[index].namamk);
                                    await dataPresensiMahasiswa.setString(
                                        'namadosen',
                                        ruangBeaconResponseModel
                                            .data[index].namadosen);
                                    await dataPresensiMahasiswa.setString(
                                        'hari',
                                        ruangBeaconResponseModel
                                            .data[index].hari);
                                    await dataPresensiMahasiswa.setString(
                                        'sesi',
                                        ruangBeaconResponseModel
                                            .data[index].sesi);
                                    await dataPresensiMahasiswa.setString(
                                        'uuid',
                                        ruangBeaconResponseModel
                                            .data[index].uuid);
                                    await dataPresensiMahasiswa.setString(
                                        'jam', _timeString);
                                    await dataPresensiMahasiswa.setString(
                                        'tanggal', _dateString);
                                    await Get.toNamed('/pindai');

                                    // Tampilan Modal Kelas
                                    // showModalBottomSheet(
                                    //     isScrollControlled: true,
                                    //     context: context,
                                    //     shape: RoundedRectangleBorder(
                                    //         borderRadius: BorderRadius.only(
                                    //             topLeft: Radius.circular(25),
                                    //             topRight: Radius.circular(25))),
                                    //     clipBehavior: Clip.antiAliasWithSaveLayer,
                                    //     builder: (builder) {
                                    //       return new Container(
                                    //         height: 650,
                                    //         color: Colors.white,
                                    //         child: new Column(
                                    //           children: [
                                    //             new Center(
                                    //               child: Padding(
                                    //                 padding: EdgeInsets.only(
                                    //                     top: 25, bottom: 10),
                                    //                 child: new Text(
                                    //                   'Detail Kelas',
                                    //                   style: TextStyle(
                                    //                       fontFamily:
                                    //                           'WorkSansMedium',
                                    //                       fontWeight:
                                    //                           FontWeight.bold,
                                    //                       fontSize: 24),
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //             Divider(
                                    //               height: 20,
                                    //               thickness: 5,
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       );
                                    //     });
                                  },
                                ),
                              ),
                            );
                          }),
                    )

              // Flexible(
              //   child: _beacons == null || _beacons.isEmpty
              //       ? SingleChildScrollView(
              //           child: Shimmer.fromColors(
              //             baseColor: Colors.grey[200],
              //             highlightColor: Colors.grey[100],
              //             enabled: true,
              //             child: Column(
              //               children: <Widget>[
              //                 // Padding(
              //                 //   padding: EdgeInsets.all(10),
              //                 //   child: Container(
              //                 //     decoration: BoxDecoration(
              //                 //         color: Colors.grey,
              //                 //         borderRadius: BorderRadius.circular(25)),
              //                 //     child: Flexible(
              //                 //       child: Column(
              //                 //         children: <Widget>[
              //                 //           Text(
              //                 //             '                                              ',
              //                 //             style: TextStyle(fontSize: 225),
              //                 //           ),
              //                 //         ],
              //                 //       ),
              //                 //     ),
              //                 //   ),
              //                 // ),
              //                 // Padding(
              //                 //   padding: EdgeInsets.all(10),
              //                 //   child: Container(
              //                 //     decoration: BoxDecoration(
              //                 //         color: Colors.grey,
              //                 //         borderRadius: BorderRadius.circular(25)),
              //                 //     child: Flexible(
              //                 //       child: ListTile(
              //                 //         title: Text('                        '),
              //                 //         subtitle: Text('                       '),
              //                 //       ),
              //                 //     ),
              //                 //   ),
              //                 // ),
              //                 // Padding(
              //                 //   padding: EdgeInsets.all(10),
              //                 //   child: Container(
              //                 //     decoration: BoxDecoration(
              //                 //         color: Colors.grey,
              //                 //         borderRadius: BorderRadius.circular(25)),
              //                 //     child: Flexible(
              //                 //       child: ListTile(
              //                 //         title: Text('                        '),
              //                 //         subtitle: Text('                       '),
              //                 //       ),
              //                 //     ),
              //                 //   ),
              //                 // ),
              //                 // Padding(
              //                 //   padding: EdgeInsets.all(10),
              //                 //   child: Container(
              //                 //     decoration: BoxDecoration(
              //                 //         color: Colors.grey,
              //                 //         borderRadius: BorderRadius.circular(25)),
              //                 //     child: Flexible(
              //                 //       child: ListTile(
              //                 //         title: Text('                        '),
              //                 //         subtitle: Text('                       '),
              //                 //       ),
              //                 //     ),
              //                 //   ),
              //                 // ),
              //                 // Padding(
              //                 //   padding: EdgeInsets.all(10),
              //                 //   child: Container(
              //                 //     decoration: BoxDecoration(
              //                 //         color: Colors.grey,
              //                 //         borderRadius: BorderRadius.circular(25)),
              //                 //     child: Flexible(
              //                 //       child: ListTile(
              //                 //         title: Text('                        '),
              //                 //         subtitle: Text('                       '),
              //                 //       ),
              //                 //     ),
              //                 //   ),
              //                 // ),
              //                 // Padding(
              //                 //   padding: EdgeInsets.all(10),
              //                 //   child: Container(
              //                 //     decoration: BoxDecoration(
              //                 //         color: Colors.grey,
              //                 //         borderRadius: BorderRadius.circular(25)),
              //                 //     child: Flexible(
              //                 //       child: ListTile(
              //                 //         title: Text('                        '),
              //                 //         subtitle: Text('                       '),
              //                 //       ),
              //                 //     ),
              //                 //   ),
              //                 // ),
              //               ],
              //             ),
              //           ),
              //         )
              //       : SingleChildScrollView(
              //           child: Column(
              //             children: ListTile.divideTiles(
              //                 context: context,
              //                 tiles: _beacons.map((beacon) {
              //                   if (beacon.accuracy < 1.0) {
              //                     return Padding(
              //                         padding: EdgeInsets.all(10),
              //                         child: Container(
              //                             decoration: BoxDecoration(
              //                                 color: Colors.grey[200],
              //                                 borderRadius:
              //                                     BorderRadius.circular(25)),
              //                             child: ListTile(
              //                               title: Padding(
              //                                 padding:
              //                                     const EdgeInsets.all(8.0),
              //                                 child: Text(
              //                                     'Ruangan : ${beacon.proximityUUID}',
              //                                     style: TextStyle(
              //                                         fontSize: 16.0,
              //                                         fontFamily:
              //                                             'WorkSansMedium',
              //                                         fontWeight:
              //                                             FontWeight.bold)),
              //                               ),
              //                               subtitle: new Row(
              //                                 mainAxisSize: MainAxisSize.max,
              //                                 children: <Widget>[
              //                                   Flexible(
              //                                       child: Padding(
              //                                         padding:
              //                                             const EdgeInsets.all(
              //                                                 8.0),
              //                                         child: Text(
              //                                             // 'Accuracy: ${beacon.accuracy}m\nRSSI: ${beacon.proximityUUID}',
              //                                             'Mata Kuliah : -',
              //                                             style: TextStyle(
              //                                                 fontSize: 14.0,
              //                                                 fontFamily:
              //                                                     'WorkSansMedium',
              //                                                 fontWeight:
              //                                                     FontWeight
              //                                                         .bold)),
              //                                       ),
              //                                       flex: 1,
              //                                       fit: FlexFit.tight),
              //                                   Flexible(
              //                                       child: Padding(
              //                                         padding:
              //                                             const EdgeInsets.all(
              //                                                 8.0),
              //                                         child: Text(
              //                                             // 'Accuracy: ${beacon.accuracy}m\nRSSI: ${beacon.proximityUUID}',
              //                                             'Kelas : -',
              //                                             style: TextStyle(
              //                                                 fontSize: 14.0,
              //                                                 fontFamily:
              //                                                     'WorkSansMedium',
              //                                                 fontWeight:
              //                                                     FontWeight
              //                                                         .bold)),
              //                                       ),
              //                                       flex: 1,
              //                                       fit: FlexFit.tight),
              //                                   Flexible(
              //                                       child: Padding(
              //                                         padding:
              //                                             const EdgeInsets.all(
              //                                                 8.0),
              //                                         child: Text(
              //                                             // 'Accuracy: ${beacon.accuracy}m\nRSSI: ${beacon.proximityUUID}',
              //                                             'Jarak: ${beacon.accuracy} m',
              //                                             style: TextStyle(
              //                                                 fontSize: 14.0,
              //                                                 fontFamily:
              //                                                     'WorkSansMedium',
              //                                                 fontWeight:
              //                                                     FontWeight
              //                                                         .bold)),
              //                                       ),
              //                                       flex: 1,
              //                                       fit: FlexFit.tight),
              //                                   // Flexible(
              //                                   //     child: Text(
              //                                   //         // 'Accuracy: ${beacon.accuracy}m\nRSSI: ${beacon.proximityUUID}',
              //                                   //         '${beacon.proximity}',
              //                                   //         style: TextStyle(fontSize: 13.0)),
              //                                   //     flex: 1,
              //                                   //     fit: FlexFit.tight)
              //                                 ],
              //                               ),
              //                               trailing: Icon(Icons.arrow_forward),
              //                               onTap: () async {
              //                                 SharedPreferences modalKelas =
              //                                     await SharedPreferences
              //                                         .getInstance();
              //                                 await modalKelas.setString(
              //                                     'Kelas',
              //                                     beacon.proximityUUID);
              //                                 await modalKelas.setString(
              //                                     'Jam', _timeString);
              //                                 await modalKelas.setString(
              //                                     'Tanggal', _dateString);

              //                                 Get.toNamed(
              //                                     '/mahasiswa/dashboard/presensi/detail');
              //                                 // getModalKelas();
              //                                 // Tampilan Modal Kelas
              //                                 // showModalBottomSheet(
              //                                 //     isScrollControlled: true,
              //                                 //     context: context,
              //                                 //     shape: RoundedRectangleBorder(
              //                                 //         borderRadius:
              //                                 //             BorderRadius.only(
              //                                 //                 topLeft: Radius
              //                                 //                     .circular(25),
              //                                 //                 topRight: Radius
              //                                 //                     .circular(
              //                                 //                         25))),
              //                                 //     clipBehavior: Clip
              //                                 //         .antiAliasWithSaveLayer,
              //                                 //     builder: (builder) {
              //                                 //       return new Container(
              //                                 //         height: 650,
              //                                 //         color: Colors.white,
              //                                 //         child: new Column(
              //                                 //           children: [
              //                                 //             new Center(
              //                                 //               child: Padding(
              //                                 //                 padding: EdgeInsets
              //                                 //                     .only(
              //                                 //                         top: 25,
              //                                 //                         bottom:
              //                                 //                             10),
              //                                 //                 child: new Text(
              //                                 //                   'Presensi',
              //                                 //                   style: TextStyle(
              //                                 //                       fontFamily:
              //                                 //                           'WorkSansMedium',
              //                                 //                       fontWeight:
              //                                 //                           FontWeight
              //                                 //                               .bold,
              //                                 //                       fontSize:
              //                                 //                           24),
              //                                 //                 ),
              //                                 //               ),
              //                                 //             ),
              //                                 //             Divider(
              //                                 //               height: 20,
              //                                 //               thickness: 5,
              //                                 //             ),
              //                                 //             new Padding(
              //                                 //                 padding:
              //                                 //                     EdgeInsets
              //                                 //                         .all(10),
              //                                 //                 child: Column(
              //                                 //                   children: <
              //                                 //                       Widget>[
              //                                 //                     Padding(
              //                                 //                       padding:
              //                                 //                           const EdgeInsets.all(
              //                                 //                               8.0),
              //                                 //                       child:
              //                                 //                           new Center(
              //                                 //                         child:
              //                                 //                             new Text(
              //                                 //                           'Ruangan',
              //                                 //                           style: TextStyle(
              //                                 //                               fontFamily:
              //                                 //                                   'WorkSansMedium',
              //                                 //                               fontWeight:
              //                                 //                                   FontWeight.bold,
              //                                 //                               fontSize: 20),
              //                                 //                         ),
              //                                 //                       ),
              //                                 //                     ),
              //                                 //                     Padding(
              //                                 //                       padding:
              //                                 //                           const EdgeInsets.all(
              //                                 //                               8.0),
              //                                 //                       child:
              //                                 //                           new Center(
              //                                 //                         child:
              //                                 //                             new Text(
              //                                 //                           kelas,
              //                                 //                           style: TextStyle(
              //                                 //                               fontFamily: 'WorkSansMedium',
              //                                 //                               // fontWeight:
              //                                 //                               //     FontWeight.bold,
              //                                 //                               fontSize: 16),
              //                                 //                         ),
              //                                 //                       ),
              //                                 //                     ),
              //                                 //                     Padding(
              //                                 //                       padding:
              //                                 //                           const EdgeInsets.all(
              //                                 //                               8.0),
              //                                 //                       child:
              //                                 //                           new Center(
              //                                 //                         child:
              //                                 //                             new Text(
              //                                 //                           'Mata Kuliah',
              //                                 //                           style: TextStyle(
              //                                 //                               fontFamily:
              //                                 //                                   'WorkSansMedium',
              //                                 //                               fontWeight:
              //                                 //                                   FontWeight.bold,
              //                                 //                               fontSize: 20),
              //                                 //                         ),
              //                                 //                       ),
              //                                 //                     ),
              //                                 //                     Padding(
              //                                 //                       padding:
              //                                 //                           const EdgeInsets.all(
              //                                 //                               8.0),
              //                                 //                       child:
              //                                 //                           new Center(
              //                                 //                         child:
              //                                 //                             new Text(
              //                                 //                           '-',
              //                                 //                           style: TextStyle(
              //                                 //                               fontFamily: 'WorkSansMedium',
              //                                 //                               // fontWeight:
              //                                 //                               //     FontWeight.bold,
              //                                 //                               fontSize: 18),
              //                                 //                         ),
              //                                 //                       ),
              //                                 //                     ),
              //                                 //                     Padding(
              //                                 //                       padding:
              //                                 //                           const EdgeInsets.all(
              //                                 //                               8.0),
              //                                 //                       child:
              //                                 //                           new Center(
              //                                 //                         child:
              //                                 //                             new Text(
              //                                 //                           'Kelas',
              //                                 //                           style: TextStyle(
              //                                 //                               fontFamily:
              //                                 //                                   'WorkSansMedium',
              //                                 //                               fontWeight:
              //                                 //                                   FontWeight.bold,
              //                                 //                               fontSize: 20),
              //                                 //                         ),
              //                                 //                       ),
              //                                 //                     ),
              //                                 //                     Padding(
              //                                 //                       padding:
              //                                 //                           const EdgeInsets.all(
              //                                 //                               8.0),
              //                                 //                       child:
              //                                 //                           new Center(
              //                                 //                         child:
              //                                 //                             new Text(
              //                                 //                           '-',
              //                                 //                           style: TextStyle(
              //                                 //                               fontFamily: 'WorkSansMedium',
              //                                 //                               // fontWeight:
              //                                 //                               //     FontWeight.bold,
              //                                 //                               fontSize: 18),
              //                                 //                         ),
              //                                 //                       ),
              //                                 //                     ),
              //                                 //                     Padding(
              //                                 //                       padding:
              //                                 //                           const EdgeInsets.all(
              //                                 //                               8.0),
              //                                 //                       child:
              //                                 //                           new Center(
              //                                 //                         child:
              //                                 //                             new Text(
              //                                 //                           'Dosen',
              //                                 //                           style: TextStyle(
              //                                 //                               fontFamily:
              //                                 //                                   'WorkSansMedium',
              //                                 //                               fontWeight:
              //                                 //                                   FontWeight.bold,
              //                                 //                               fontSize: 20),
              //                                 //                         ),
              //                                 //                       ),
              //                                 //                     ),
              //                                 //                     Padding(
              //                                 //                       padding:
              //                                 //                           const EdgeInsets.all(
              //                                 //                               8.0),
              //                                 //                       child:
              //                                 //                           new Center(
              //                                 //                         child:
              //                                 //                             new Text(
              //                                 //                           '-',
              //                                 //                           style: TextStyle(
              //                                 //                               fontFamily: 'WorkSansMedium',
              //                                 //                               // fontWeight:
              //                                 //                               //     FontWeight.bold,
              //                                 //                               fontSize: 18),
              //                                 //                         ),
              //                                 //                       ),
              //                                 //                     ),
              //                                 //                     Padding(
              //                                 //                       padding:
              //                                 //                           const EdgeInsets.all(
              //                                 //                               8.0),
              //                                 //                       child:
              //                                 //                           new Center(
              //                                 //                         child:
              //                                 //                             new Text(
              //                                 //                           'Jam Masuk',
              //                                 //                           style: TextStyle(
              //                                 //                               fontFamily:
              //                                 //                                   'WorkSansMedium',
              //                                 //                               fontWeight:
              //                                 //                                   FontWeight.bold,
              //                                 //                               fontSize: 20),
              //                                 //                         ),
              //                                 //                       ),
              //                                 //                     ),
              //                                 //                     Padding(
              //                                 //                       padding:
              //                                 //                           const EdgeInsets.all(
              //                                 //                               8.0),
              //                                 //                       child:
              //                                 //                           new Center(
              //                                 //                         child:
              //                                 //                             new Text(
              //                                 //                           jam,
              //                                 //                           style: TextStyle(
              //                                 //                               fontFamily: 'WorkSansMedium',
              //                                 //                               // fontWeight:
              //                                 //                               //     FontWeight.bold,
              //                                 //                               fontSize: 18),
              //                                 //                         ),
              //                                 //                       ),
              //                                 //                     ),
              //                                 //                     Padding(
              //                                 //                       padding:
              //                                 //                           const EdgeInsets.all(
              //                                 //                               8.0),
              //                                 //                       child:
              //                                 //                           new Center(
              //                                 //                         child:
              //                                 //                             new Text(
              //                                 //                           'Jam Keluar',
              //                                 //                           style: TextStyle(
              //                                 //                               fontFamily:
              //                                 //                                   'WorkSansMedium',
              //                                 //                               fontWeight:
              //                                 //                                   FontWeight.bold,
              //                                 //                               fontSize: 20),
              //                                 //                         ),
              //                                 //                       ),
              //                                 //                     ),
              //                                 //                     Padding(
              //                                 //                       padding:
              //                                 //                           const EdgeInsets.all(
              //                                 //                               8.0),
              //                                 //                       child:
              //                                 //                           new Center(
              //                                 //                         child:
              //                                 //                             new Text(
              //                                 //                           '-',
              //                                 //                           style: TextStyle(
              //                                 //                               fontFamily: 'WorkSansMedium',
              //                                 //                               // fontWeight:
              //                                 //                               //     FontWeight.bold,
              //                                 //                               fontSize: 18),
              //                                 //                         ),
              //                                 //                       ),
              //                                 //                     ),
              //                                 //                   ],
              //                                 //                 )),
              //                                 //             new Align(
              //                                 //               child: new Padding(
              //                                 //                 padding:
              //                                 //                     EdgeInsets
              //                                 //                         .all(10),
              //                                 //                 child: new Row(
              //                                 //                     mainAxisAlignment:
              //                                 //                         MainAxisAlignment
              //                                 //                             .spaceAround,
              //                                 //                     children: <
              //                                 //                         Widget>[
              //                                 //                       MaterialButton(
              //                                 //                         color: Colors
              //                                 //                             .green,
              //                                 //                         shape:
              //                                 //                             StadiumBorder(),
              //                                 //                         padding: EdgeInsets.only(
              //                                 //                             left:
              //                                 //                                 50,
              //                                 //                             right:
              //                                 //                                 50,
              //                                 //                             top:
              //                                 //                                 5,
              //                                 //                             bottom:
              //                                 //                                 5),
              //                                 //                         onPressed:
              //                                 //                             () {},
              //                                 //                         child:
              //                                 //                             Column(
              //                                 //                           mainAxisAlignment:
              //                                 //                               MainAxisAlignment.spaceAround,
              //                                 //                           children: <
              //                                 //                               Widget>[
              //                                 //                             Icon(
              //                                 //                               Icons.arrow_upward_rounded,
              //                                 //                               color:
              //                                 //                                   Colors.white,
              //                                 //                             ),
              //                                 //                             SizedBox(
              //                                 //                               height:
              //                                 //                                   5,
              //                                 //                             ),
              //                                 //                             Text(
              //                                 //                               'MASUK',
              //                                 //                               style: TextStyle(
              //                                 //                                   fontFamily: 'WorkSansMedium',
              //                                 //                                   fontWeight: FontWeight.bold,
              //                                 //                                   color: Colors.white,
              //                                 //                                   fontSize: 18),
              //                                 //                             ),
              //                                 //                           ],
              //                                 //                         ),
              //                                 //                       ),
              //                                 //                       MaterialButton(
              //                                 //                         color: Colors
              //                                 //                             .red,
              //                                 //                         shape:
              //                                 //                             StadiumBorder(),
              //                                 //                         padding: EdgeInsets.only(
              //                                 //                             left:
              //                                 //                                 50,
              //                                 //                             right:
              //                                 //                                 50,
              //                                 //                             top:
              //                                 //                                 5,
              //                                 //                             bottom:
              //                                 //                                 5),
              //                                 //                         onPressed:
              //                                 //                             () {},
              //                                 //                         child:
              //                                 //                             Column(
              //                                 //                           mainAxisAlignment:
              //                                 //                               MainAxisAlignment.spaceAround,
              //                                 //                           children: <
              //                                 //                               Widget>[
              //                                 //                             Icon(
              //                                 //                               Icons.arrow_downward_rounded,
              //                                 //                               color:
              //                                 //                                   Colors.white,
              //                                 //                             ),
              //                                 //                             SizedBox(
              //                                 //                               height:
              //                                 //                                   5,
              //                                 //                             ),
              //                                 //                             Text(
              //                                 //                               'KELUAR',
              //                                 //                               style: TextStyle(
              //                                 //                                   fontFamily: 'WorkSansMedium',
              //                                 //                                   fontWeight: FontWeight.bold,
              //                                 //                                   color: Colors.white,
              //                                 //                                   fontSize: 18),
              //                                 //                             ),
              //                                 //                           ],
              //                                 //                         ),
              //                                 //                       ),
              //                                 //                     ]),
              //                                 //               ),
              //                                 //             ),
              //                                 //           ],
              //                                 //         ),
              //                                 //       );
              //                                 //     });
              //                               },
              //                             )));
              //                   } else {
              //                     // return Padding(
              //                     //     padding: EdgeInsets.all(10),
              //                     //     child: Container(
              //                     //       decoration: BoxDecoration(
              //                     //         borderRadius:
              //                     //             BorderRadius.circular(25),
              //                     //         color: Colors.grey[200],
              //                     //       ),
              //                     //       child: Padding(
              //                     //         padding: EdgeInsets.all(20),
              //                     //         child: Text(
              //                     //           'Anda harus di dekat kelas ${beacon.proximityUUID} minimal 1 meter.',
              //                     //           style: TextStyle(
              //                     //               fontSize: 16,
              //                     //               color: Colors.red,
              //                     //               fontFamily: 'WorkSansMedium',
              //                     //               fontWeight: FontWeight.bold),
              //                     //         ),
              //                     //       ),
              //                     //     ));
              //                     return SizedBox.shrink();
              //                   }
              //                 })).toList(),
              //           ),
              //         ),
              // ),
            ],
          )),
    );
  }
}

// _jumpToSetting() {
//   SystemSetting.goto(SettingTarget.BLUETOOTH);
// }
