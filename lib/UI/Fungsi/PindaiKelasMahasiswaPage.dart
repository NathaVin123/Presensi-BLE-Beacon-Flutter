import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();

    getProximityUUID();

    listeningState();
  }

  getProximityUUID() async {
    SharedPreferences dataPresensiMahasiswa =
        await SharedPreferences.getInstance();

    setState(() {
      uuid = dataPresensiMahasiswa.getString('uuid');
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
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
        ),
        body: Container(
            child: _beacons == null || _beacons.isEmpty
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Mohon Tunggu...',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'WorkSansMedium',
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              'Sistem sedang menghubungkan ke\nperangkat beacon kelas yang dipilih.',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'WorkSansMedium',
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 100,
                            ),
                            Text(
                              'Pastikan anda dekat dengan\nperangkat beacon kelas yang dipilih.',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'WorkSansMedium',
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                        children: ListTile.divideTiles(
                            context: context,
                            tiles: _beacons.map((beacon) {
                              if (beacon.accuracy < 0.7) {
                                return Container(
                                  child: Center(
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 250,
                                        ),
                                        Text(
                                          'Ruangan kelas sudah ditemukan',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'WorkSansMedium',
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        MaterialButton(
                                          child: Text(
                                            'Masuk',
                                            style: const TextStyle(
                                                fontFamily: 'WorkSansSemiBold',
                                                fontSize: 18.0,
                                                color: Colors.white),
                                          ),
                                          onPressed: () => {
                                            Get.offAllNamed(
                                                '/mahasiswa/dashboard/presensi/detail')
                                          },
                                          shape: StadiumBorder(),
                                          color: Colors.blue,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 250,
                                      ),
                                      Text(
                                        'Anda berada di luar jangkauan\nminimal kelas',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'WorkSansMedium',
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Text(
                                        'Jarak Anda : ${beacon.accuracy}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'WorkSansMedium',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            })).toList()),
                  )));
  }
}
