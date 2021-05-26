import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:presensiblebeacon/Utils/extension_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class MahasiswaPresensiDashboardPage extends StatefulWidget {
  @override
  _MahasiswaPresensiDashboardPageState createState() =>
      _MahasiswaPresensiDashboardPageState();
}

class _MahasiswaPresensiDashboardPageState
    extends State<MahasiswaPresensiDashboardPage> with WidgetsBindingObserver {
  final StreamController<BluetoothState> streamController = StreamController();
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

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();

    _timeString = _formatTime(DateTime.now());
    _dateString = _formatDate(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    Timer.periodic(Duration(seconds: 100), (Timer t) => _getDate());
    super.initState();

    listeningState();
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
    return DateFormat('MM/dd/yyyy').format(dateTime);
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss').format(dateTime);
  }

  listeningState() async {
    print('Listening to bluetooth state');
    _streamBluetooth = flutterBeacon
        .bluetoothStateChanged()
        .listen((BluetoothState state) async {
      print('BluetoothState = $state');
      streamController.add(state);

      // switch (state) {
      //   case BluetoothState.stateOn:
      //     initScanBeacon();
      //     break;
      //   case BluetoothState.stateOff:
      //     await pauseScanBeacon();
      //     await checkAllRequirements();
      //     break;
      // }
      if (BluetoothState.stateOn == state) {
        initScanBeacon();
      }
      if (BluetoothState.stateOff == state) {
        await pauseScanBeacon();
        await checkAllRequirements();
      }
    });
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

    _streamRanging = flutterBeacon.ranging(
        <Region>[new Region(identifier: "")]).listen((RangingResult result) {
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
    print('AppLifecycleState = $state');
    if (state == AppLifecycleState.resumed) {
      if (_streamBluetooth != null && _streamBluetooth.isPaused) {
        _streamBluetooth.resume();
      }
      await checkAllRequirements();
      if (authorizationStatusOk && locationServiceEnabled && bluetoothEnabled) {
        await initScanBeacon();
      } else {
        await pauseScanBeacon();
        await checkAllRequirements();
      }
    } else if (state == AppLifecycleState.paused) {
      _streamBluetooth?.pause();
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

  void getModalKelas() async {
    SharedPreferences modalKelas = await SharedPreferences.getInstance();

    kelas = modalKelas.getString('Kelas');
    print(kelas);
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
                Icons.notifications_none_rounded,
                color: Colors.black,
              ),
              onPressed: () => initScanBeacon(),
            ),
            title: Image.asset(
              'SplashPage_LogoAtmaJaya'.png,
              height: 30,
            ),
            centerTitle: true,
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
                      } else if (Platform.isIOS) {}
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
                          } else if (Platform.isIOS) {}
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
                child: Center(
                  // alignment: Alignment.topLeft,
                  child: Text(
                    'Kelas Selanjutnya',
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
                      'Kelas Terdekat',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'WorkSansMedium'),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: _beacons == null || _beacons.isEmpty
                    ? SingleChildScrollView(
                        child: Shimmer.fromColors(
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
                                      title: Text('                        '),
                                      subtitle: Text('                       '),
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
                                      title: Text('                        '),
                                      subtitle: Text('                       '),
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
                                      title: Text('                        '),
                                      subtitle: Text('                       '),
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
                                      title: Text('                        '),
                                      subtitle: Text('                       '),
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
                                      title: Text('                        '),
                                      subtitle: Text('                       '),
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
                                      title: Text('                        '),
                                      subtitle: Text('                       '),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: ListTile.divideTiles(
                              context: context,
                              tiles: _beacons.map((beacon) {
                                if (beacon.accuracy < 1.0) {
                                  return Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: ListTile(
                                            title: Text(
                                                'Kelas : ${beacon.proximityUUID}',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontFamily:
                                                        'WorkSansMedium',
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            subtitle: new Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                // Flexible(
                                                //     child: Text(
                                                //         'Alamat MAC: ${beacon.macAddress}',
                                                //         style: TextStyle(fontSize: 13.0)),
                                                //     flex: 1,
                                                //     fit: FlexFit.tight),
                                                Flexible(
                                                    child: Text(
                                                        // 'Accuracy: ${beacon.accuracy}m\nRSSI: ${beacon.proximityUUID}',
                                                        'Jarak: ${beacon.accuracy} m',
                                                        style: TextStyle(
                                                            fontSize: 14.0,
                                                            fontFamily:
                                                                'WorkSansMedium',
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    flex: 1,
                                                    fit: FlexFit.tight),
                                                // Flexible(
                                                //     child: Text(
                                                //         // 'Accuracy: ${beacon.accuracy}m\nRSSI: ${beacon.proximityUUID}',
                                                //         '${beacon.proximity}',
                                                //         style: TextStyle(fontSize: 13.0)),
                                                //     flex: 1,
                                                //     fit: FlexFit.tight)
                                              ],
                                            ),
                                            trailing: Icon(Icons.arrow_forward),
                                            onTap: () async {
                                              SharedPreferences modalKelas =
                                                  await SharedPreferences
                                                      .getInstance();
                                              await modalKelas.setString(
                                                  'Kelas',
                                                  beacon.proximityUUID);

                                              getModalKelas();
                                              // Get.to(() =>
                                              //     MahasiswaPresensiDetailPage());
                                              showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  context: context,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(25),
                                                              topRight: Radius
                                                                  .circular(
                                                                      25))),
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  builder: (builder) {
                                                    return new Container(
                                                      height: 550,
                                                      color: Colors.white,
                                                      child: new Column(
                                                        children: [
                                                          new Center(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              child: new Text(
                                                                'Presensi',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'WorkSansMedium',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        24),
                                                              ),
                                                            ),
                                                          ),
                                                          new Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child: new Center(
                                                              child: new Text(
                                                                kelas,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'WorkSansMedium',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  });
                                            },
                                          )));
                                } else {
                                  return Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: Colors.grey[200],
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Text(
                                            'Anda harus di dekat kelas ${beacon.proximityUUID} minimal 1 meter.',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.red,
                                                fontFamily: 'WorkSansMedium',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ));
                                }
                              })).toList(),
                        ),
                      ),
              ),
            ],
          )),
    );
  }
}
