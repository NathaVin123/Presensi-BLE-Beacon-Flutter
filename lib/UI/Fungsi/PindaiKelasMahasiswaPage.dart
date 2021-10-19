import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiINMahasiswaToFBEModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiINMahasiswaToFHModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiINMahasiswaToFISIPModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiINMahasiswaToFTBModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiINMahasiswaToFTIModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiINMahasiswaToFTModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiINMahasiswaToKSIModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiOUTMahasiswaToFBEModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiOUTMahasiswaToFHModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiOUTMahasiswaToFISIPModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiOUTMahasiswaToFTBModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiOUTMahasiswaToFTIModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiOUTMahasiswaToFTModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiOUTMahasiswaToKSIModel.dart';
import 'package:presensiblebeacon/UTILS/LoginProgressHUD.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sk_alert_dialog/sk_alert_dialog.dart';

class PindaiKelasMahasiswaPage extends StatefulWidget {
  @override
  _PindaiKelasMahasiswaPageState createState() =>
      _PindaiKelasMahasiswaPageState();
}

class _PindaiKelasMahasiswaPageState extends State<PindaiKelasMahasiswaPage>
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

  String npm = "";
  String fakultas = "";
  int idkelas = 0;
  String ruang = "";
  String namamk = "";
  String dosen = "";
  String kelas = "";
  int sks = 0;
  int pertemuan = 0;
  String hari = "";
  String sesi = "";
  int kapasitas = 0;
  String jam = "";
  String tanggalnow = "";
  String tglmasuk = "";
  String tglkeluar = "";
  int bukapresensi = 0;

  String idkelasString;
  String idkelasFakultas;

  int statusPresensi = 0;

  bool isApiCallProcess = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  PresensiINMahasiswaToKSIRequestModel presensiINMahasiswaToKSIRequestModel;

  PresensiOUTMahasiswaToKSIRequestModel presensiOUTMahasiswaToKSIRequestModel;

  PresensiINMahasiswaToFBERequestModel presensiINMahasiswaToFBERequestModel;

  PresensiOUTMahasiswaToFBERequestModel presensiOUTMahasiswaToFBERequestModel;

  PresensiINMahasiswaToFHRequestModel presensiINMahasiswaToFHRequestModel;

  PresensiOUTMahasiswaToFHRequestModel presensiOUTMahasiswaToFHRequestModel;

  PresensiINMahasiswaToFISIPRequestModel presensiINMahasiswaToFISIPRequestModel;

  PresensiOUTMahasiswaToFISIPRequestModel
      presensiOUTMahasiswaToFISIPRequestModel;

  PresensiINMahasiswaToFTRequestModel presensiINMahasiswaToFTRequestModel;

  PresensiOUTMahasiswaToFTRequestModel presensiOUTMahasiswaToFTRequestModel;

  PresensiINMahasiswaToFTBRequestModel presensiINMahasiswaToFTBRequestModel;

  PresensiOUTMahasiswaToFTBRequestModel presensiOUTMahasiswaToFTBRequestModel;

  PresensiINMahasiswaToFTIRequestModel presensiINMahasiswaToFTIRequestModel;

  PresensiOUTMahasiswaToFTIRequestModel presensiOUTMahasiswaToFTIRequestModel;

  @override
  void initState() {
    super.initState();

    getProximityUUID();

    listeningState();

    Timer.periodic(Duration(seconds: 1), (Timer t) {
      getDetailKelas();
      getDetailMahasiswa();

      Future.delayed(Duration(seconds: 5), () {
        t.cancel();
      });
    });

    presensiINMahasiswaToKSIRequestModel =
        PresensiINMahasiswaToKSIRequestModel();

    presensiOUTMahasiswaToKSIRequestModel =
        PresensiOUTMahasiswaToKSIRequestModel();

    presensiINMahasiswaToFBERequestModel =
        PresensiINMahasiswaToFBERequestModel();

    presensiOUTMahasiswaToFBERequestModel =
        PresensiOUTMahasiswaToFBERequestModel();

    presensiINMahasiswaToFHRequestModel = PresensiINMahasiswaToFHRequestModel();

    presensiOUTMahasiswaToFHRequestModel =
        PresensiOUTMahasiswaToFHRequestModel();

    presensiINMahasiswaToFISIPRequestModel =
        PresensiINMahasiswaToFISIPRequestModel();

    presensiOUTMahasiswaToFISIPRequestModel =
        PresensiOUTMahasiswaToFISIPRequestModel();

    presensiINMahasiswaToFTRequestModel = PresensiINMahasiswaToFTRequestModel();

    presensiOUTMahasiswaToFTRequestModel =
        PresensiOUTMahasiswaToFTRequestModel();

    presensiINMahasiswaToFTBRequestModel =
        PresensiINMahasiswaToFTBRequestModel();

    presensiOUTMahasiswaToFTBRequestModel =
        PresensiOUTMahasiswaToFTBRequestModel();

    presensiINMahasiswaToFTIRequestModel =
        PresensiINMahasiswaToFTIRequestModel();

    presensiOUTMahasiswaToFTIRequestModel =
        PresensiOUTMahasiswaToFTIRequestModel();

    Timer.periodic(Duration(seconds: 1), (Timer t) {
      getIDKelasFakultas();

      Future.delayed(Duration(seconds: 5), () {
        t.cancel();
      });
    });
  }

  getDetailMahasiswa() async {
    SharedPreferences loginMahasiswa = await SharedPreferences.getInstance();

    setState(() {
      npm = loginMahasiswa.getString('npm');
      fakultas = loginMahasiswa.getString('fakultas');
    });
  }

  getDetailKelas() async {
    SharedPreferences dataPresensiMahasiswa =
        await SharedPreferences.getInstance();

    setState(() {
      idkelas = dataPresensiMahasiswa.getInt('idkelas');
      ruang = dataPresensiMahasiswa.getString('ruang');
      namamk = dataPresensiMahasiswa.getString('namamk');
      dosen = dataPresensiMahasiswa.getString('namadosen1');
      kelas = dataPresensiMahasiswa.getString('kelas');
      sks = dataPresensiMahasiswa.getInt('sks');
      pertemuan = dataPresensiMahasiswa.getInt('pertemuan');
      hari = dataPresensiMahasiswa.getString('hari1');
      sesi = dataPresensiMahasiswa.getString('sesi1');
      kapasitas = dataPresensiMahasiswa.getInt('kapasitas');
      jam = dataPresensiMahasiswa.getString('jam');
      tanggalnow = dataPresensiMahasiswa.getString('tanggal');
      tglmasuk = dataPresensiMahasiswa.getString('tglmasuk');
      tglkeluar = dataPresensiMahasiswa.getString('tglkeluar');
      bukapresensi = dataPresensiMahasiswa.getInt('bukapresensi');
      statusPresensi = dataPresensiMahasiswa.getInt('statuspresensi');
    });
  }

  getIDKelasFakultas() async {
    idkelasString = idkelas.toString();

    idkelasFakultas = idkelasString.substring(2);
  }

  getProximityUUID() async {
    SharedPreferences dataPresensiMahasiswa =
        await SharedPreferences.getInstance();

    setState(() {
      uuid = dataPresensiMahasiswa.getString('uuid');
      jarakmin = dataPresensiMahasiswa.getDouble('jarakmin') ?? 0.0;
      major = dataPresensiMahasiswa.getInt('major');
      minor = dataPresensiMahasiswa.getInt('minor');
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
      child: buildDetailPresensiMahasiswa(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0,
    );
  }

  Widget buildDetailPresensiMahasiswa(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
        appBar: AppBar(
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
                    return IconButton(
                      icon: Icon(Icons.bluetooth_connected),
                      onPressed: () {},
                      color: Colors.blue,
                    );
                  }

                  if (state == BluetoothState.stateOff) {
                    return IconButton(
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
                    );
                  }

                  return IconButton(
                    icon: Icon(Icons.bluetooth_disabled),
                    onPressed: () {},
                    color: Colors.grey,
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
                      Center(
                        child: Column(
                          children: <Widget>[
                            uuid != "-"
                                ? SpinKitRipple(
                                    color: Colors.white,
                                    size: 100,
                                  )
                                : Container(),
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
                                        color: Colors.white),
                                  )
                                : Text(
                                    'Tidak ada perangkat beacon di ruangan',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'WorkSansMedium',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              'Silahkan menghubungkan perangkat beacon ke kelas',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'WorkSansMedium',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 100,
                            ),
                            uuid != '-'
                                ? Text(
                                    'Pastikan anda dekat dengan\nperangkat beacon kelas yang dipilih.',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'WorkSansMedium',
                                        color: Colors.white),
                                  )
                                : Container(),
                          ],
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
                                    statusPresensi == 0 ||
                                            statusPresensi == null
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: new Center(
                                              child: new Text(
                                                '${tglmasuk ?? "-"}',
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
                                                '${tglkeluar ?? "-"}',
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
                                          'NPM',
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
                                          '${npm ?? "-"}',
                                          style: TextStyle(
                                              fontFamily: 'WorkSansMedium',
                                              // fontWeight:
                                              //     FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: new Center(
                                    //     child: new Text(
                                    //       '${idkelasFakultas ?? "-"}',
                                    //       style: TextStyle(
                                    //           fontFamily: 'WorkSansMedium',
                                    //           // fontWeight:
                                    //           //     FontWeight.bold,
                                    //           fontSize: 16),
                                    //     ),
                                    //   ),
                                    // ),
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
                                          'Dosen',
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
                                          '${dosen ?? "-"}',
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
                                    statusPresensi == 0 ||
                                            statusPresensi == null
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
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    statusPresensi == 0 ||
                                            statusPresensi == null
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
                                            ),
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Center(
                                        child: new Text(
                                          '${jam ?? "-"}',
                                          style: TextStyle(
                                              fontFamily: 'WorkSansMedium',
                                              // fontWeight:
                                              //     FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
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
                                            '/mahasiswa/dashboard/presensi/detail/tampilpeserta')
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
                                    statusPresensi == 0 ||
                                            statusPresensi == null
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
                                                    'Apakah anda yakin ingin\nmasuk ke kelas ini ?',
                                                okBtnText: 'Ya',
                                                okBtnTxtColor: Colors.white,
                                                okBtnColor: Colors.green,
                                                cancelBtnText: 'Tidak',
                                                cancelBtnTxtColor: Colors.white,
                                                cancelBtnColor: Colors.grey,
                                                onOkBtnTap: (value) async {
                                                  SharedPreferences
                                                      dataPresensiMahasiswa =
                                                      await SharedPreferences
                                                          .getInstance();

                                                  await dataPresensiMahasiswa
                                                      .setInt(
                                                          'statuspresensi', 1);

                                                  setState(() {
                                                    isApiCallProcess = true;

                                                    presensiINMahasiswaToKSIRequestModel
                                                        .idkelas = idkelas;

                                                    presensiINMahasiswaToKSIRequestModel
                                                        .npm = npm;

                                                    presensiINMahasiswaToKSIRequestModel
                                                        .pertemuan = pertemuan;

                                                    presensiINMahasiswaToKSIRequestModel
                                                            .tglin =
                                                        jam + ' ' + tanggalnow;

                                                    // if (fakultas ==
                                                    //     'Bisnis dan Ekonomika') {
                                                    //   presensiINMahasiswaToFBERequestModel
                                                    //       .idkelas = idkelasFakultas;

                                                    //   presensiINMahasiswaToFBERequestModel
                                                    //       .npm = npm;

                                                    //   presensiINMahasiswaToFBERequestModel
                                                    //       .pertemuan = pertemuan;

                                                    //   presensiINMahasiswaToFBERequestModel
                                                    //       .tglin = jam + ' ' + tanggalnow;
                                                    // } else if (fakultas == 'Hukum') {
                                                    //   presensiINMahasiswaToFHRequestModel
                                                    //       .idkelas = idkelasFakultas;

                                                    //   presensiINMahasiswaToFHRequestModel
                                                    //       .npm = npm;

                                                    //   presensiINMahasiswaToFHRequestModel
                                                    //       .pertemuan = pertemuan;

                                                    //   presensiINMahasiswaToFHRequestModel
                                                    //       .tglin = jam + ' ' + tanggalnow;
                                                    // } else if (fakultas ==
                                                    //     'Teknobiologi') {
                                                    //   presensiINMahasiswaToFTBRequestModel
                                                    //       .idkelas = idkelasFakultas;

                                                    //   presensiINMahasiswaToFTBRequestModel
                                                    //       .npm = npm;

                                                    //   presensiINMahasiswaToFTBRequestModel
                                                    //       .pertemuan = pertemuan;

                                                    //   presensiINMahasiswaToFTBRequestModel
                                                    //       .tglin = jam + ' ' + tanggalnow;
                                                    // } else if (fakultas ==
                                                    //     'Ilmu Sosial dan Politik') {
                                                    //   presensiINMahasiswaToFISIPRequestModel
                                                    //       .idkelas = idkelasFakultas;

                                                    //   presensiINMahasiswaToFISIPRequestModel
                                                    //       .npm = npm;

                                                    //   presensiINMahasiswaToFISIPRequestModel
                                                    //       .pertemuan = pertemuan;

                                                    //   presensiINMahasiswaToFISIPRequestModel
                                                    //       .tglin = jam + ' ' + tanggalnow;
                                                    // } else if (fakultas == 'Teknik') {
                                                    //   presensiINMahasiswaToFTRequestModel
                                                    //       .idkelas = idkelasFakultas;

                                                    //   presensiINMahasiswaToFTRequestModel
                                                    //       .npm = npm;

                                                    //   presensiINMahasiswaToFTRequestModel
                                                    //       .pertemuan = pertemuan;

                                                    //   presensiINMahasiswaToFTRequestModel
                                                    //       .tglin = jam + ' ' + tanggalnow;
                                                    // } else if (fakultas ==
                                                    //     'Teknologi Industri') {
                                                    //   presensiINMahasiswaToFTIRequestModel
                                                    //       .idkelas = idkelasFakultas;

                                                    //   presensiINMahasiswaToFTIRequestModel
                                                    //       .npm = npm;

                                                    //   presensiINMahasiswaToFTIRequestModel
                                                    //       .pertemuan = pertemuan;

                                                    //   presensiINMahasiswaToFTIRequestModel
                                                    //       .tglin = jam + ' ' + tanggalnow;
                                                    // }
                                                  });

                                                  print(
                                                      PresensiINMahasiswaToKSIRequestModel()
                                                          .toJson());

                                                  // print(
                                                  //     PresensiINMahasiswaToFBERequestModel()
                                                  //         .toJson());

                                                  // print(
                                                  //     PresensiINMahasiswaToFHRequestModel()
                                                  //         .toJson());

                                                  // print(
                                                  //     PresensiINMahasiswaToFISIPRequestModel()
                                                  //         .toJson());

                                                  // print(
                                                  //     PresensiINMahasiswaToFTRequestModel()
                                                  //         .toJson());

                                                  // print(
                                                  //     PresensiINMahasiswaToFTBRequestModel()
                                                  //         .toJson());

                                                  // print(
                                                  //     PresensiINMahasiswaToFTIRequestModel()
                                                  //         .toJson());

                                                  APIService apiService =
                                                      new APIService();

                                                  // if (fakultas ==
                                                  //     'Bisnis dan Ekonomika') {
                                                  //   await apiService
                                                  //       .postInsertPresensiMhsToFBE(
                                                  //           presensiINMahasiswaToFBERequestModel);
                                                  // } else if (fakultas == 'Hukum') {
                                                  //   await apiService
                                                  //       .postInsertPresensiMhsToFH(
                                                  //           presensiINMahasiswaToFHRequestModel);
                                                  // } else if (fakultas == 'Teknobiologi') {
                                                  //   await apiService
                                                  //       .postInsertPresensiMhsToFH(
                                                  //           presensiINMahasiswaToFHRequestModel);
                                                  // } else if (fakultas ==
                                                  //     'Ilmu Sosial dan Politik') {
                                                  //   await apiService
                                                  //       .postInsertPresensiMhsToFISIP(
                                                  //           presensiINMahasiswaToFISIPRequestModel);
                                                  // } else if (fakultas == 'Teknik') {
                                                  //   await apiService
                                                  //       .postInsertPresensiMhsToFT(
                                                  //           presensiINMahasiswaToFTRequestModel);
                                                  // } else if (fakultas ==
                                                  //     'Teknologi Industri') {
                                                  //   await apiService
                                                  //       .postInsertPresensiMhsToFTI(
                                                  //           presensiINMahasiswaToFTIRequestModel);
                                                  // }

                                                  await apiService
                                                      .postInsertPresensiMhsToKSI(
                                                          presensiINMahasiswaToKSIRequestModel)
                                                      .then((value) async {
                                                    if (value != null) {
                                                      setState(() {
                                                        isApiCallProcess =
                                                            false;
                                                      });
                                                    }

                                                    Get.offAllNamed(
                                                        '/mahasiswa/dashboard');

                                                    await Fluttertoast.showToast(
                                                        msg:
                                                            'Berhasil masuk ke kelas',
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
                                                    'Apakah anda yakin ingin\nkeluar dari kelas ini ?',
                                                okBtnText: 'Ya',
                                                okBtnTxtColor: Colors.white,
                                                okBtnColor: Colors.red,
                                                cancelBtnText: 'Tidak',
                                                cancelBtnTxtColor: Colors.white,
                                                cancelBtnColor: Colors.grey,
                                                onOkBtnTap: (value) async {
                                                  SharedPreferences
                                                      dataPresensiMahasiswa =
                                                      await SharedPreferences
                                                          .getInstance();

                                                  await dataPresensiMahasiswa
                                                      .setInt(
                                                          'statuspresensi', 0);

                                                  setState(() {
                                                    isApiCallProcess = true;

                                                    presensiOUTMahasiswaToKSIRequestModel
                                                        .idkelas = idkelas;

                                                    presensiOUTMahasiswaToKSIRequestModel
                                                        .npm = npm;

                                                    presensiOUTMahasiswaToKSIRequestModel
                                                        .pertemuan = pertemuan;

                                                    presensiOUTMahasiswaToKSIRequestModel
                                                            .tglout =
                                                        jam + ' ' + tanggalnow;

                                                    presensiOUTMahasiswaToKSIRequestModel
                                                        .status = 'H';
                                                    // if (fakultas ==
                                                    //     'Bisnis dan Ekonomika') {
                                                    //   presensiOUTMahasiswaToFBERequestModel
                                                    //       .idkelas = idkelasFakultas;

                                                    //   presensiOUTMahasiswaToFBERequestModel
                                                    //       .npm = npm;

                                                    //   presensiOUTMahasiswaToFBERequestModel
                                                    //       .pertemuan = pertemuan;

                                                    //   presensiOUTMahasiswaToFBERequestModel
                                                    //           .tglout =
                                                    //       jam + ' ' + tanggalnow;

                                                    //   presensiOUTMahasiswaToFBERequestModel
                                                    //       .status = 'H';
                                                    // } else if (fakultas == 'Hukum') {
                                                    //   presensiOUTMahasiswaToFHRequestModel
                                                    //       .idkelas = idkelasFakultas;

                                                    //   presensiOUTMahasiswaToFHRequestModel
                                                    //       .npm = npm;

                                                    //   presensiOUTMahasiswaToFHRequestModel
                                                    //       .pertemuan = pertemuan;

                                                    //   presensiOUTMahasiswaToFHRequestModel
                                                    //           .tglout =
                                                    //       jam + ' ' + tanggalnow;

                                                    //   presensiOUTMahasiswaToFHRequestModel
                                                    //       .status = 'H';
                                                    // } else if (fakultas ==
                                                    //     'Teknobiologi') {
                                                    //   presensiOUTMahasiswaToFTBRequestModel
                                                    //       .idkelas = idkelasFakultas;

                                                    //   presensiOUTMahasiswaToFTBRequestModel
                                                    //       .npm = npm;

                                                    //   presensiOUTMahasiswaToFTBRequestModel
                                                    //       .pertemuan = pertemuan;

                                                    //   presensiOUTMahasiswaToFTBRequestModel
                                                    //           .tglout =
                                                    //       jam + ' ' + tanggalnow;

                                                    //   presensiOUTMahasiswaToFTBRequestModel
                                                    //       .status = 'H';
                                                    // } else if (fakultas ==
                                                    //     'Ilmu Sosial dan Politik') {
                                                    //   presensiOUTMahasiswaToFISIPRequestModel
                                                    //       .idkelas = idkelasFakultas;

                                                    //   presensiOUTMahasiswaToFISIPRequestModel
                                                    //       .npm = npm;

                                                    //   presensiOUTMahasiswaToFISIPRequestModel
                                                    //       .pertemuan = pertemuan;

                                                    //   presensiOUTMahasiswaToFISIPRequestModel
                                                    //           .tglout =
                                                    //       jam + ' ' + tanggalnow;

                                                    //   presensiOUTMahasiswaToFISIPRequestModel
                                                    //       .status = 'H';
                                                    // } else if (fakultas == 'Teknik') {
                                                    //   presensiOUTMahasiswaToFTRequestModel
                                                    //       .idkelas = idkelasFakultas;

                                                    //   presensiOUTMahasiswaToFTRequestModel
                                                    //       .npm = npm;

                                                    //   presensiOUTMahasiswaToFTRequestModel
                                                    //       .pertemuan = pertemuan;

                                                    //   presensiOUTMahasiswaToFTRequestModel
                                                    //           .tglout =
                                                    //       jam + ' ' + tanggalnow;

                                                    //   presensiOUTMahasiswaToFTRequestModel
                                                    //       .status = 'H';
                                                    // } else if (fakultas ==
                                                    //     'Teknologi Industri') {
                                                    //   presensiOUTMahasiswaToFTIRequestModel
                                                    //       .idkelas = idkelasFakultas;

                                                    //   presensiOUTMahasiswaToFTIRequestModel
                                                    //       .npm = npm;

                                                    //   presensiOUTMahasiswaToFTIRequestModel
                                                    //       .pertemuan = pertemuan;

                                                    //   presensiOUTMahasiswaToFTIRequestModel
                                                    //           .tglout =
                                                    //       jam + ' ' + tanggalnow;

                                                    //   presensiOUTMahasiswaToFTIRequestModel
                                                    //       .status = 'H';
                                                    // }
                                                  });

                                                  print(
                                                      PresensiOUTMahasiswaToKSIRequestModel()
                                                          .toJson());

                                                  // print(
                                                  //     PresensiOUTMahasiswaToFBERequestModel()
                                                  //         .toJson());

                                                  // print(
                                                  //     PresensiOUTMahasiswaToFHRequestModel()
                                                  //         .toJson());

                                                  // print(
                                                  //     PresensiOUTMahasiswaToFISIPRequestModel()
                                                  //         .toJson());

                                                  // print(
                                                  //     PresensiOUTMahasiswaToFTRequestModel()
                                                  //         .toJson());

                                                  // print(
                                                  //     PresensiOUTMahasiswaToFTBRequestModel()
                                                  //         .toJson());

                                                  // print(
                                                  //     PresensiOUTMahasiswaToFTIRequestModel()
                                                  //         .toJson());

                                                  APIService apiService =
                                                      new APIService();

                                                  // if (fakultas ==
                                                  //     'Bisnis dan Ekonomika') {
                                                  //   await apiService
                                                  //       .putUpdatePresensiMhsToFBE(
                                                  //           presensiOUTMahasiswaToFBERequestModel);
                                                  // } else if (fakultas == 'Hukum') {
                                                  //   await apiService.putUpdatePresensiMhsToFH(
                                                  //       presensiOUTMahasiswaToFHRequestModel);
                                                  // } else if (fakultas == 'Teknobiologi') {
                                                  //   await apiService
                                                  //       .putUpdatePresensiMhsToFTB(
                                                  //           presensiOUTMahasiswaToFTBRequestModel);
                                                  // } else if (fakultas ==
                                                  //     'Ilmu Sosial dan Politik') {
                                                  //   await apiService
                                                  //       .putUpdatePresensiMhsToFISIP(
                                                  //           presensiOUTMahasiswaToFISIPRequestModel);
                                                  // } else if (fakultas == 'Teknik') {
                                                  //   await apiService.putUpdatePresensiMhsToFT(
                                                  //       presensiOUTMahasiswaToFTRequestModel);
                                                  // } else if (fakultas ==
                                                  //     'Teknologi Industri') {
                                                  //   await apiService
                                                  //       .putUpdatePresensiMhsToFTI(
                                                  //           presensiOUTMahasiswaToFTIRequestModel);
                                                  // }

                                                  await apiService
                                                      .putUpdatePresensiMhsToKSI(
                                                          presensiOUTMahasiswaToKSIRequestModel)
                                                      .then((value) async {
                                                    if (value != null) {
                                                      setState(() {
                                                        isApiCallProcess =
                                                            false;
                                                      });
                                                    }

                                                    Get.offAllNamed(
                                                        '/mahasiswa/dashboard');

                                                    await Fluttertoast.showToast(
                                                        msg:
                                                            'Berhasil keluar dari kelas, data presensi telah tersimpan',
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
                                      onPressed: () => {
                                        Get.offAllNamed('/mahasiswa/dashboard')
                                      },
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
            // Get.offAllNamed('/mahasiswa/dashboard/presensi/detail')
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
            // Get.offAllNamed(
            //     '/mahasiswa/dashboard/presensi/detail')
            //                           },
            //                           shape: StadiumBorder(),
            //                           color: Color.fromRGBO(247, 180, 7, 1),
            //                         )
            //                       ],
            //                     ),
            //                   ),
            //                 );
            //               } else {
            //                 return Container(
            //                   child: Center(
            //                     child: Column(
            //                       mainAxisAlignment:
            //                           MainAxisAlignment.center,
            //                       children: <Widget>[
            //                         SpinKitPulse(
            //                           color: Colors.red,
            //                           size: 100,
            //                         ),
            //                         SizedBox(
            //                           height: 25,
            //                         ),
            //                         Text(
            //                           'Anda berada di luar jangkauan\nminimal kelas',
            //                           style: TextStyle(
            //                               fontSize: 18,
            //                               fontFamily: 'WorkSansMedium',
            //                               fontWeight: FontWeight.bold,
            //                               color: Colors.white),
            //                         ),
            //                         SizedBox(
            //                           height: 25,
            //                         ),
            //                         Text(
            //                           'Jarak Anda : ${beacon.accuracy} m',
            //                           style: TextStyle(
            //                               fontSize: 18,
            //                               fontFamily: 'WorkSansMedium',
            //                               fontWeight: FontWeight.bold,
            //                               color: Colors.white),
            //                         ),
            //                         Text(
            //                           'Jarak Minimal : ${jarakmin} m',
            //                           style: TextStyle(
            //                               fontSize: 18,
            //                               fontFamily: 'WorkSansMedium',
            //                               fontWeight: FontWeight.bold,
            //                               color: Colors.white),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                 );
            //               }
            //             })).toList()),
            //   )

            ));
  }
}
