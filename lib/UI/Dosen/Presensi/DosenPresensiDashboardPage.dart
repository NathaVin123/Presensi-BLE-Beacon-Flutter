import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Beacon/RuangBeaconModel.dart';
import 'package:presensiblebeacon/Utils/extension_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:system_setting/system_setting.dart';

class DosenPresensiDashboardPage extends StatefulWidget {
  @override
  _DosenPresensiDashboardPageState createState() =>
      _DosenPresensiDashboardPageState();
}

class _DosenPresensiDashboardPageState extends State<DosenPresensiDashboardPage>
    with WidgetsBindingObserver {
  final StreamController<BluetoothState> streamController = StreamController();

  RuangBeaconResponseModel ruangBeaconResponseModel;

  StreamSubscription<BluetoothState> _streamBluetooth;
  StreamSubscription<RangingResult> _streamRanging;

  final _regionBeacons = <Region, List<Beacon>>{};
  final _beacons = <Beacon>[];

  bool authorizationStatusOk = false;
  bool locationServiceEnabled = false;
  bool bluetoothEnabled = false;

  String _timeString;
  String _dateString;

  String kelas = "";
  String jam = "";

  String namadsn = "";

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();

    ruangBeaconResponseModel = RuangBeaconResponseModel();

    _timeString = _formatTime(DateTime.now());
    _dateString = _formatDate(DateTime.now());

    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    Timer.periodic(Duration(hours: 1), (Timer t) => _getDate());

    getDataDosen();

    getDataRuangBeacon();

    // listeningState();
  }

  void getDataRuangBeacon() async {
    APIService apiService = new APIService();
    apiService.getKelasBeacon().then((value) async {
      ruangBeaconResponseModel = value;
    });
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

    if (Platform.isIOS) {
      _streamRanging = flutterBeacon.ranging(<Region>[
        new Region(
          identifier: '',
          proximityUUID: 'FDA50693-A4E2-4FB1-AFCF-C6EB07647825',
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
      _streamRanging = flutterBeacon.ranging(
          <Region>[new Region(identifier: '')]).listen((RangingResult result) {
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

  _jumpToSetting() {
    SystemSetting.goto(SettingTarget.BLUETOOTH);
  }

  void getModalKelas() async {
    SharedPreferences modalKelas = await SharedPreferences.getInstance();

    kelas = modalKelas.getString('Kelas');
    jam = modalKelas.getString('Jam');
    print(kelas);
  }

  getDataDosen() async {
    SharedPreferences loginDosen = await SharedPreferences.getInstance();

    namadsn = loginDosen.getString('namadsn');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white,
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
                    Get.toNamed('/dosen/dashboard/presensi/notifikasi')),
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
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(
                            'Halo, ',
                            style: TextStyle(
                                fontSize: 20, fontFamily: 'WorkSansMedium'),
                          ),
                          Text(
                            '${namadsn ?? "-"}',
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
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: Center(
                  // alignment: Alignment.topLeft,
                  child: Text(
                    'Kuliah Hari Ini',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'WorkSansMedium'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('-'),
                  ),
                ),
              ),
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
                      'Kelas Aktif Saya',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'WorkSansMedium'),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
