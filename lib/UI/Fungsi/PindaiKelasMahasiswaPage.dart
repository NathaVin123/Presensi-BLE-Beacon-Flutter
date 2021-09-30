import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  double jarakmin = 0;

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
      jarakmin = dataPresensiMahasiswa.getDouble('jarakmin') ?? 0.0;
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
                            SpinKitRipple(
                              color: Colors.white,
                              size: 100,
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Text(
                              'Mohon Tunggu...',
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
                              'Sistem sedang menghubungkan\nke perangkat beacon kelas.',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'WorkSansMedium',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 100,
                            ),
                            Text(
                              'Pastikan anda dekat dengan\nperangkat beacon kelas yang dipilih.',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'WorkSansMedium',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(
                    child: Column(
                        children: ListTile.divideTiles(
                            context: context,
                            tiles: _beacons.map((beacon) {
                              if (beacon.accuracy < jarakmin) {
                                return Container(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Icon(
                                            Icons.check_circle_outline_rounded,
                                            size: 100,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text(
                                          'Ruangan kelas sudah ditemukan',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'WorkSansMedium',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        MaterialButton(
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Text(
                                              'MASUK',
                                              style: const TextStyle(
                                                  fontFamily:
                                                      'WorkSansSemiBold',
                                                  fontSize: 18.0,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          onPressed: () => {
                                            Get.offAllNamed(
                                                '/mahasiswa/dashboard/presensi/detail')
                                          },
                                          shape: StadiumBorder(),
                                          color: Color.fromRGBO(247, 180, 7, 1),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SpinKitPulse(
                                          color: Colors.red,
                                          size: 100,
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        Text(
                                          'Anda berada di luar jangkauan\nminimal kelas',
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
                                          'Jarak Anda : ${beacon.accuracy} m',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'WorkSansMedium',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          'Jarak Minimal : ${jarakmin} m',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'WorkSansMedium',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            })).toList()),
                  )));
  }
}
