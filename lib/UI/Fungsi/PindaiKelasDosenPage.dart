import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiINDosenBukaPresensiModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiINOUTOUTPresensiDosen.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiINOUTPresensiDosen.dart';
import 'package:presensiblebeacon/UTILS/LoginProgressHUD.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sk_alert_dialog/sk_alert_dialog.dart';

class PindaiKelasDosenPage extends StatefulWidget {
  @override
  _PindaiKelasDosenPageState createState() => _PindaiKelasDosenPageState();
}

class _PindaiKelasDosenPageState extends State<PindaiKelasDosenPage>
    with WidgetsBindingObserver {
  final StreamController<BluetoothState> streamController = StreamController();

  StreamSubscription<BluetoothState> _streamBluetooth;
  StreamSubscription<RangingResult> _streamRanging;

  final _regionBeacons = <Region, List<Beacon>>{};
  final _beacons = <Beacon>[];

  bool authorizationStatusOk = false;
  bool locationServiceEnabled = false;
  bool bluetoothEnabled = false;

  String uuid = "";
  double jarakmin = 0;
  int major = 0;
  int minor = 0;

  String npp = "";
  int idkelas = 0;
  String ruang = "";
  String namamk = "";
  String kelas = "";
  int sks = 0;
  int pertemuan = 0;
  String hari = "";
  String sesi = "";
  int kapasitas = 0;
  String jam = "";
  String tanggalnow = "";
  String tanggalmasuk = "";
  String tanggalkeluar = "";
  int bukapresensi = 0;

  var _materiFieldController = TextEditingController();

  var _keteranganFieldController = TextEditingController();

  var _materiFieldFocus = FocusNode();

  var _keteranganFieldFocus = FocusNode();

  bool isApiCallProcess = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  PresensiINDosenBukaPresensiRequestModel
      presensiINDosenBukaPresensiRequestModel;

  PresensiINOUTDosenBukaPresensiRequestModel
      presensiINOUTDosenBukaPresensiRequestModel;

  PresensiINOUTOUTDosenBukaPresensiRequestModel
      presensiINOUTOUTDosenBukaPresensiRequestModel;

  @override
  void initState() {
    super.initState();

    getProximityUUID();

    listeningState();

    presensiINDosenBukaPresensiRequestModel =
        PresensiINDosenBukaPresensiRequestModel();

    presensiINOUTDosenBukaPresensiRequestModel =
        PresensiINOUTDosenBukaPresensiRequestModel();

    presensiINOUTOUTDosenBukaPresensiRequestModel =
        PresensiINOUTOUTDosenBukaPresensiRequestModel();

    Timer.periodic(Duration(seconds: 1), (Timer t) {
      getDetailKelas();
      getDetailDosen();
      Future.delayed(Duration(seconds: 5), () {
        t.cancel();
      });
    });
  }

  getDetailDosen() async {
    SharedPreferences loginDosen = await SharedPreferences.getInstance();

    setState(() {
      npp = loginDosen.getString('npp');
    });
  }

  getDetailKelas() async {
    SharedPreferences dataPresensiDosen = await SharedPreferences.getInstance();

    setState(() {
      idkelas = dataPresensiDosen.getInt('idkelas');
      ruang = dataPresensiDosen.getString('ruang');
      namamk = dataPresensiDosen.getString('namamk');
      kelas = dataPresensiDosen.getString('kelas');
      sks = dataPresensiDosen.getInt('sks');
      pertemuan = dataPresensiDosen.getInt('pertemuan');
      hari = dataPresensiDosen.getString('hari1');
      sesi = dataPresensiDosen.getString('sesi1');
      kapasitas = dataPresensiDosen.getInt('kapasitas');
      jam = dataPresensiDosen.getString('jam');
      tanggalnow = dataPresensiDosen.getString('tanggalnow');
      tanggalmasuk = dataPresensiDosen.getString('tglmasuk');
      tanggalkeluar = dataPresensiDosen.getString('tglkeluar');
      bukapresensi = dataPresensiDosen.getInt('bukapresensi');
    });
  }

  getProximityUUID() async {
    SharedPreferences dataPresensiDosen = await SharedPreferences.getInstance();

    setState(() {
      uuid = dataPresensiDosen.getString('uuid');
      jarakmin = dataPresensiDosen.getDouble('jarakmin') ?? 0.0;
      major = dataPresensiDosen.getInt('major');
      minor = dataPresensiDosen.getInt('minor');
    });
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

    if (Platform.isIOS) {
      _streamRanging = flutterBeacon.ranging(<Region>[
        new Region(
          identifier: '',
          proximityUUID: uuid,
          major: major,
          minor: minor,
        )
      ]).listen((RangingResult result) {
        print(result);
        if (result != null && mounted) {
          setState(() {
            _regionBeacons[result.region] = result.beacons;
            _beacons.clear();
            _regionBeacons.values.forEach((list) {
              _beacons.addAll(list);
            });
            _beacons.sort(_compareParameters);
          });
        }
      });
    } else if (Platform.isAndroid) {
      _streamRanging = flutterBeacon.ranging(<Region>[
        new Region(
          identifier: '',
          proximityUUID: uuid,
          major: major,
          minor: minor,
        )
      ]).listen((RangingResult result) {
        print(result);
        if (result != null && mounted) {
          setState(() {
            _regionBeacons[result.region] = result.beacons;
            _beacons.clear();
            _regionBeacons.values.forEach((list) {
              _beacons.addAll(list);
            });
            _beacons.sort(_compareParameters);
          });
        }
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return LoginProgressHUD(
      child: buildDetailPresensiDosen(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0,
    );
  }

  // @override
  Widget buildDetailPresensiDosen(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            'Presensi',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'WorkSansMedium',
                fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            if (!authorizationStatusOk)
              IconButton(
                  icon: Icon(Icons.portable_wifi_off),
                  color: Colors.red,
                  onPressed: () async {
                    await flutterBeacon.requestAuthorization;
                  }),
            if (!locationServiceEnabled)
              IconButton(
                  icon: Icon(Icons.location_off),
                  color: Colors.red,
                  onPressed: () async {
                    if (Platform.isAndroid) {
                      await flutterBeacon.openLocationSettings;
                    } else if (Platform.isIOS) {
                      // await _jumpToSetting();
                    }
                  }),
            StreamBuilder<BluetoothState>(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final state = snapshot.data;

                  if (state == BluetoothState.stateOn) {
                    return Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Bluetooth Hidup',
                            style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'WorkSansMedium',
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.bluetooth_connected),
                          onPressed: () {},
                          color: Colors.blue,
                        ),
                      ],
                    );
                  }

                  if (state == BluetoothState.stateOff) {
                    return Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Bluetooth Mati',
                            style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'WorkSansMedium',
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.bluetooth),
                          onPressed: () async {
                            if (Platform.isAndroid) {
                              try {
                                await flutterBeacon.openBluetoothSettings;
                              } on PlatformException catch (e) {
                                print(e);
                              }
                            } else if (Platform.isIOS) {
                              try {
                                // await _jumpToSetting();
                              } on PlatformException catch (e) {
                                print(e);
                              }
                            }
                          },
                          color: Colors.red,
                        ),
                      ],
                    );
                  }

                  return Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Bluetooth Tidak Aktif',
                          style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'WorkSansMedium',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.bluetooth_disabled_rounded),
                        onPressed: () {},
                        color: Colors.grey,
                      ),
                    ],
                  );
                }

                return SizedBox.shrink();
              },
              stream: streamController.stream,
              initialData: BluetoothState.stateUnknown,
            ),
          ],
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color.fromRGBO(23, 75, 137, 1),
          elevation: 0,
        ),
        body: Container(
            color: Color.fromRGBO(23, 75, 137, 1),
            child: _beacons == null || _beacons.isEmpty
                ? Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(25)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Column(
                                  children: <Widget>[
                                    uuid != "-"
                                        ? SpinKitRipple(
                                            color: Colors.black,
                                            size: 100,
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.warning_rounded,
                                              color: Colors.red,
                                              size: 100,
                                            ),
                                          ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                    uuid != '-'
                                        ? Text(
                                            'Mohon Tunggu...',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'WorkSansMedium',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          )
                                        : Text(
                                            'Tidak ada perangkat beacon di ruangan',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'WorkSansMedium',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    uuid != '-'
                                        ? Text(
                                            'Aplikasi sedang melakukan pemindaian',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'WorkSansMedium',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          )
                                        : Text(
                                            'Silahkan menghubungi admin',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'WorkSansMedium',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                    uuid != '-'
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Pastikan anda dekat dengan beacon ruangan',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: 'WorkSansMedium',
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(25)),
                            child: new Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Center(
                                        child: new Text(
                                          'Tanggal',
                                          style: TextStyle(
                                              fontFamily: 'WorkSansMedium',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    bukapresensi == 0
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: new Center(
                                              child: new Text(
                                                '${tanggalmasuk ?? "-"}',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'WorkSansMedium',
                                                    // fontWeight:
                                                    //     FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: new Center(
                                              child: new Text(
                                                '${tanggalkeluar ?? "-"}',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'WorkSansMedium',
                                                    // fontWeight:
                                                    //     FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Center(
                                        child: new Text(
                                          'NPP',
                                          style: TextStyle(
                                              fontFamily: 'WorkSansMedium',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Center(
                                        child: new Text(
                                          '${npp ?? "-"}',
                                          style: TextStyle(
                                              fontFamily: 'WorkSansMedium',
                                              // fontWeight:
                                              //     FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Center(
                                        child: new Text(
                                          'Ruangan',
                                          style: TextStyle(
                                              fontFamily: 'WorkSansMedium',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Center(
                                        child: new Text(
                                          '${ruang ?? "-"}',
                                          style: TextStyle(
                                              fontFamily: 'WorkSansMedium',
                                              // fontWeight:
                                              //     FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Center(
                                        child: new Text(
                                          'Mata Kuliah',
                                          style: TextStyle(
                                              fontFamily: 'WorkSansMedium',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Center(
                                        child: new Text(
                                          '${namamk ?? "-"}',
                                          style: TextStyle(
                                              fontFamily: 'WorkSansMedium',
                                              // fontWeight:
                                              //     FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Center(
                                        child: new Text(
                                          'Kelas',
                                          style: TextStyle(
                                              fontFamily: 'WorkSansMedium',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Center(
                                        child: new Text(
                                          '${kelas ?? "-"}',
                                          style: TextStyle(
                                              fontFamily: 'WorkSansMedium',
                                              // fontWeight:
                                              //     FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Center(
                                        child: new Text(
                                          'SKS',
                                          style: TextStyle(
                                              fontFamily: 'WorkSansMedium',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Center(
                                        child: new Text(
                                          '${sks ?? "-"}',
                                          style: TextStyle(
                                              fontFamily: 'WorkSansMedium',
                                              // fontWeight:
                                              //     FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Center(
                                        child: new Text(
                                          'Pertemuan Ke',
                                          style: TextStyle(
                                              fontFamily: 'WorkSansMedium',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Center(
                                        child: new Text(
                                          '${pertemuan ?? "-"}',
                                          style: TextStyle(
                                              fontFamily: 'WorkSansMedium',
                                              // fontWeight:
                                              //     FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Center(
                                        child: new Text(
                                          'Hari',
                                          style: TextStyle(
                                              fontFamily: 'WorkSansMedium',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Center(
                                        child: new Text(
                                          '${hari ?? "-"}',
                                          style: TextStyle(
                                              fontFamily: 'WorkSansMedium',
                                              // fontWeight:
                                              //     FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Center(
                                        child: new Text(
                                          'Sesi',
                                          style: TextStyle(
                                              fontFamily: 'WorkSansMedium',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Center(
                                        child: new Text(
                                          '${sesi ?? "-"}',
                                          style: TextStyle(
                                              fontFamily: 'WorkSansMedium',
                                              // fontWeight:
                                              //     FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Center(
                                        child: new Text(
                                          'Kapasitas',
                                          style: TextStyle(
                                              fontFamily: 'WorkSansMedium',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Center(
                                        child: new Text(
                                          '${kapasitas ?? "-"}',
                                          style: TextStyle(
                                              fontFamily: 'WorkSansMedium',
                                              // fontWeight:
                                              //     FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Column(
                            children: <Widget>[
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(25)),
                                child: Column(
                                  children: <Widget>[
                                    bukapresensi == 0
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: new Center(
                                              child: new Text(
                                                'Tanggal Masuk',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'WorkSansMedium',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: new Center(
                                              child: new Text(
                                                'Tanggal Keluar',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'WorkSansMedium',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Center(
                                        child: new Text(
                                          '${tanggalnow ?? "-"}',
                                          style: TextStyle(
                                              fontFamily: 'WorkSansMedium',
                                              // fontWeight:
                                              //     FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    bukapresensi == 0
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: new Center(
                                              child: new Text(
                                                'Jam Masuk',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'WorkSansMedium',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: new Center(
                                              child: new Text(
                                                'Jam Keluar',
                                                style: TextStyle(
                                                    fontFamily:
                                                        'WorkSansMedium',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            )),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Center(
                                        child: new Text(
                                          '${jam ?? "-"}',
                                          style: TextStyle(
                                              fontFamily: 'WorkSansMedium',
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          bukapresensi == 1
                              ? Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Form(
                                          key: globalFormKey,
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: Text(
                                                    'Keterangan',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontFamily:
                                                            'WorkSansMedium',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                    child: TextFormField(
                                                  controller:
                                                      _keteranganFieldController,
                                                  focusNode:
                                                      _keteranganFieldFocus,
                                                  onFieldSubmitted: (term) {
                                                    _fieldFocusChange(
                                                        context,
                                                        _keteranganFieldFocus,
                                                        _materiFieldFocus);
                                                  },
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  style: const TextStyle(
                                                      fontFamily:
                                                          'WorkSansSemiBold',
                                                      fontSize: 16.0,
                                                      color: Colors.black),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: new InputDecoration(
                                                      hintText:
                                                          'Silahkan Isi Keterangan Mata Kuliah Anda'),
                                                  // validator: (input) => input.length < 1
                                                  //     ? "Materi tidak boleh kosong"
                                                  //     : null,
                                                  onSaved: (input) =>
                                                      presensiINOUTOUTDosenBukaPresensiRequestModel
                                                          .keterangan = input,
                                                )),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: Text(
                                                    'Materi',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontFamily:
                                                            'WorkSansMedium',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                    child: TextFormField(
                                                  controller:
                                                      _materiFieldController,
                                                  focusNode: _materiFieldFocus,
                                                  onFieldSubmitted: (value) {
                                                    _materiFieldFocus.unfocus();
                                                  },
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  style: const TextStyle(
                                                      fontFamily:
                                                          'WorkSansSemiBold',
                                                      fontSize: 16.0,
                                                      color: Colors.black),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: new InputDecoration(
                                                      hintText:
                                                          'Silahkan Isi Materi Mata Kuliah Anda'),
                                                  // validator: (input) => input.length < 1
                                                  //     ? "Materi tidak boleh kosong"
                                                  //     : null,
                                                  onSaved: (input) =>
                                                      presensiINOUTOUTDosenBukaPresensiRequestModel
                                                          .materi = input,
                                                )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                          Divider(
                            height: 20,
                            thickness: 10,
                          ),
                          new Align(
                            child: new Padding(
                              padding: EdgeInsets.all(10),
                              child: new Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    MaterialButton(
                                      color: Colors.blue,
                                      shape: StadiumBorder(),
                                      padding: EdgeInsets.only(
                                          left: 50,
                                          right: 50,
                                          top: 25,
                                          bottom: 25),
                                      onPressed: () => {
                                        Get.toNamed(
                                            '/dosen/dashboard/presensi/detail/tampilpeserta')
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(
                                            'Lihat Peserta Kelas',
                                            style: TextStyle(
                                                fontFamily: 'WorkSansMedium',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    bukapresensi == 0
                                        ? MaterialButton(
                                            color: Colors.green,
                                            shape: StadiumBorder(),
                                            padding: EdgeInsets.only(
                                                left: 50,
                                                right: 50,
                                                top: 25,
                                                bottom: 25),
                                            onPressed: () {
                                              SKAlertDialog.show(
                                                context: context,
                                                type: SKAlertType.buttons,
                                                title: 'Masuk ?',
                                                message:
                                                    'Apakah anda yakin ingin\nmembuka kelas ini ?',
                                                okBtnText: 'Ya',
                                                okBtnTxtColor: Colors.white,
                                                okBtnColor: Colors.green,
                                                cancelBtnText: 'Tidak',
                                                cancelBtnTxtColor: Colors.white,
                                                cancelBtnColor: Colors.grey,
                                                onOkBtnTap: (value) async {
                                                  print(idkelas);

                                                  print(bukapresensi);

                                                  print(pertemuan);

                                                  print(jam + ' ' + tanggalnow);

                                                  setState(() {
                                                    isApiCallProcess = true;
                                                    presensiINOUTDosenBukaPresensiRequestModel
                                                        .idkelas = idkelas;

                                                    presensiINOUTDosenBukaPresensiRequestModel
                                                        .pertemuan = pertemuan;

                                                    presensiINOUTDosenBukaPresensiRequestModel
                                                            .jammasuk =
                                                        jam + ' ' + tanggalnow;

                                                    presensiINDosenBukaPresensiRequestModel
                                                        .idkelas = idkelas;

                                                    presensiINDosenBukaPresensiRequestModel
                                                        .bukapresensi = 1;

                                                    presensiINDosenBukaPresensiRequestModel
                                                        .pertemuan = pertemuan;
                                                  });

                                                  print(
                                                      presensiINOUTDosenBukaPresensiRequestModel
                                                          .toJson());

                                                  print(
                                                      presensiINDosenBukaPresensiRequestModel
                                                          .toJson());

                                                  APIService apiService =
                                                      new APIService();

                                                  await apiService
                                                      .putPresensiINDosen(
                                                          presensiINOUTDosenBukaPresensiRequestModel)
                                                      .then((value) async {
                                                    if (value != null) {
                                                      setState(() {
                                                        isApiCallProcess =
                                                            false;
                                                      });
                                                    }
                                                  });

                                                  await apiService
                                                      .putBukaPresensiDosen(
                                                          presensiINDosenBukaPresensiRequestModel)
                                                      .then((value) async {
                                                    if (value != null) {
                                                      setState(() {
                                                        isApiCallProcess =
                                                            false;
                                                      });
                                                    }
                                                    Get.offAllNamed(
                                                        '/dosen/dashboard');

                                                    await Fluttertoast.showToast(
                                                        msg:
                                                            'Berhasil Membuka Kelas',
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Colors.green,
                                                        textColor: Colors.white,
                                                        fontSize: 14.0);
                                                  });
                                                },
                                                onCancelBtnTap: (value) {},
                                              );
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.arrow_upward_rounded,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 25,
                                                ),
                                                Text(
                                                  'Masuk',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'WorkSansMedium',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          )
                                        : SizedBox(
                                            height: 0,
                                          ),
                                    bukapresensi == 0
                                        ? SizedBox(
                                            height: 0,
                                          )
                                        : MaterialButton(
                                            color: Colors.red,
                                            shape: StadiumBorder(),
                                            padding: EdgeInsets.only(
                                                left: 50,
                                                right: 50,
                                                top: 25,
                                                bottom: 25),
                                            onPressed: () {
                                              SKAlertDialog.show(
                                                context: context,
                                                type: SKAlertType.buttons,
                                                title: 'Keluar ?',
                                                message:
                                                    'Apakah anda yakin\ningin mengakhiri kelas ?',
                                                okBtnText: 'Ya',
                                                okBtnTxtColor: Colors.white,
                                                okBtnColor: Colors.red,
                                                cancelBtnText: 'Tidak',
                                                cancelBtnTxtColor: Colors.white,
                                                cancelBtnColor: Colors.grey,
                                                onOkBtnTap: (value) async {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  SharedPreferences
                                                      dataPresensiMahasiswa =
                                                      await SharedPreferences
                                                          .getInstance();

                                                  await dataPresensiMahasiswa
                                                      .setInt(
                                                          'statuspresensi', 0);

                                                  print(
                                                      presensiINOUTOUTDosenBukaPresensiRequestModel
                                                          .toJson());

                                                  print(
                                                      presensiINDosenBukaPresensiRequestModel
                                                          .toJson());

                                                  print(idkelas);

                                                  print(bukapresensi);

                                                  if (validateAndSave()) {
                                                    setState(() {
                                                      isApiCallProcess = true;

                                                      presensiINOUTOUTDosenBukaPresensiRequestModel
                                                          .idkelas = idkelas;

                                                      presensiINOUTOUTDosenBukaPresensiRequestModel
                                                              .pertemuan =
                                                          pertemuan;

                                                      presensiINOUTOUTDosenBukaPresensiRequestModel
                                                              .jamkeluar =
                                                          jam +
                                                              ' ' +
                                                              tanggalnow;

                                                      presensiINDosenBukaPresensiRequestModel
                                                          .idkelas = idkelas;

                                                      presensiINDosenBukaPresensiRequestModel
                                                          .bukapresensi = 0;

                                                      presensiINDosenBukaPresensiRequestModel
                                                              .pertemuan =
                                                          pertemuan;
                                                    });

                                                    APIService apiService =
                                                        new APIService();

                                                    await apiService
                                                        .putPresensiOUTDosen(
                                                            presensiINOUTOUTDosenBukaPresensiRequestModel)
                                                        .then((value) async {
                                                      if (value != null) {
                                                        setState(() {
                                                          isApiCallProcess =
                                                              false;
                                                        });
                                                      }
                                                    });

                                                    await apiService
                                                        .putBukaPresensiDosen(
                                                            presensiINDosenBukaPresensiRequestModel)
                                                        .then((value) async {
                                                      if (value != null) {
                                                        setState(() {
                                                          isApiCallProcess =
                                                              false;
                                                        });
                                                      }
                                                      Get.offAllNamed(
                                                          '/dosen/dashboard');

                                                      await Fluttertoast.showToast(
                                                          msg:
                                                              'Berhasil Mengakhiri Kelas, data presensi sudah tersimpan',
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor:
                                                              Colors.green,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 14.0);
                                                    });
                                                  }
                                                },
                                                onCancelBtnTap: (value) {},
                                              );
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.arrow_downward_rounded,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 25,
                                                ),
                                                Text(
                                                  'Keluar',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'WorkSansMedium',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    MaterialButton(
                                      color: Colors.blue,
                                      shape: StadiumBorder(),
                                      padding: EdgeInsets.only(
                                          left: 50,
                                          right: 50,
                                          top: 25,
                                          bottom: 25),
                                      onPressed: () =>
                                          {Get.offAllNamed('/dosen/dashboard')},
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(
                                            'Kembali ke Menu',
                                            style: TextStyle(
                                                fontFamily: 'WorkSansMedium',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
            // Get.offAll(PindaiKelasDosenPage())
            // Container(
            //     child: Column(
            //         children: ListTile.divideTiles(
            //             context: context,
            //             tiles: _beacons.map((beacon) {
            //               if (beacon.accuracy < jarakmin) {
            //                 return Container(
            //                   child: Center(
            //                     child: Column(
            //                       mainAxisAlignment:
            //                           MainAxisAlignment.center,
            //                       children: <Widget>[
            //                         Padding(
            //                           padding: const EdgeInsets.all(15),
            //                           child: Icon(
            //                             Icons.check_circle_outline_rounded,
            //                             size: 100,
            //                             color: Colors.green,
            //                           ),
            //                         ),
            //                         Text(
            //                           'Ruangan kelas sudah ditemukan',
            //                           style: TextStyle(
            //                               fontSize: 18,
            //                               fontFamily: 'WorkSansMedium',
            //                               fontWeight: FontWeight.bold,
            //                               color: Colors.white),
            //                         ),
            //                         SizedBox(
            //                           height: 25,
            //                         ),
            //                         MaterialButton(
            //                           child: Padding(
            //                             padding: const EdgeInsets.all(20),
            //                             child: Text(
            //                               'MASUK',
            //                               style: const TextStyle(
            //                                   fontFamily:
            //                                       'WorkSansSemiBold',
            //                                   fontSize: 18.0,
            //                                   color: Colors.white),
            //                             ),
            //                           ),
            //                           onPressed: () => {
            //                             Get.offAllNamed(
            //                                 '/dosen/dashboard/presensi/detail')
            //                           },
            //                           shape: StadiumBorder(),
            //                           color: Color.fromRGBO(247, 180, 7, 1),
            //                         )
            //                       ],
            //                     ),
            //                   ),
            //                 );
            //               } else {
            //                 return Center(
            //                   child: Column(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: <Widget>[
            //                       SpinKitPulse(
            //                         color: Colors.red,
            //                         size: 100,
            //                       ),
            //                       SizedBox(
            //                         height: 25,
            //                       ),
            //                       Text(
            //                         'Anda berada di luar jangkauan\nminimal kelas',
            //                         style: TextStyle(
            //                             fontSize: 18,
            //                             fontFamily: 'WorkSansMedium',
            //                             fontWeight: FontWeight.bold,
            //                             color: Colors.white),
            //                       ),
            //                       SizedBox(
            //                         height: 25,
            //                       ),
            //                       Text(
            //                         'Jarak Anda : ${beacon.accuracy} m',
            //                         style: TextStyle(
            //                             fontSize: 18,
            //                             fontFamily: 'WorkSansMedium',
            //                             fontWeight: FontWeight.bold,
            //                             color: Colors.white),
            //                       ),
            //                       Text(
            //                         'Jarak Minimal : ${jarakmin} m',
            //                         style: TextStyle(
            //                             fontSize: 18,
            //                             fontFamily: 'WorkSansMedium',
            //                             fontWeight: FontWeight.bold,
            //                             color: Colors.white),
            //                       ),
            //                     ],
            //                   ),
            //                 );
            //               }
            //             })).toList()),
            //   )
            ));
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
