import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';
import 'package:system_setting/system_setting.dart';

class DosenPindaiBeacon extends StatefulWidget {
  @override
  _DosenPindaiBeaconState createState() => _DosenPindaiBeaconState();
}

class _DosenPindaiBeaconState extends State<DosenPindaiBeacon>
    with WidgetsBindingObserver {
  final StreamController<BluetoothState> streamController = StreamController();

  StreamSubscription<BluetoothState> _streamBluetooth;
  StreamSubscription<RangingResult> _streamRanging;

  final _regionBeacons = <Region, List<Beacon>>{};
  final _beacons = <Beacon>[];

  bool authorizationStatusOk = false;
  bool locationServiceEnabled = false;
  bool bluetoothEnabled = false;

  @override
  void initState() {
    super.initState();
    listeningState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
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
                        await _jumpToSetting();
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
                              await _jumpToSetting();
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
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            pinned: true,
            floating: false,
            snap: false,
            expandedHeight: 85,
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Pindai Beacon',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'WorkSansMedium',
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverFillRemaining(
              child: Platform.isIOS == null
                  ? Center(
                      child: Text('Mohon maaf, iOS belum mendukung fitur ini'),
                    )
                  : Container(
                      child: _beacons == null || _beacons.isEmpty
                          ? Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                              child: Column(
                                children: ListTile.divideTiles(
                                    context: context,
                                    tiles: _beacons.map((beacon) {
                                      return Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                              child: ListTile(
                                                onTap: () => {
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                          text: beacon
                                                              .proximityUUID)),
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'Berhasil menyalin UUID',
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.green,
                                                      textColor: Colors.white,
                                                      fontSize: 14.0),
                                                },
                                                title: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Text(
                                                          'UUID : ${beacon.proximityUUID}',
                                                          style: TextStyle(
                                                              fontSize: 12.0,
                                                              fontFamily:
                                                                  'WorkSansMedium',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                          'MAC Address : ${beacon.macAddress}',
                                                          style: TextStyle(
                                                            fontSize: 12.0,
                                                            fontFamily:
                                                                'WorkSansMedium',
                                                          )),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: <Widget>[
                                                          Text(
                                                              'Major : ${beacon.major}',
                                                              style: TextStyle(
                                                                fontSize: 14.0,
                                                                fontFamily:
                                                                    'WorkSansMedium',
                                                              )),
                                                          Text(
                                                              'Minor : ${beacon.minor}',
                                                              style: TextStyle(
                                                                fontSize: 12.0,
                                                                fontFamily:
                                                                    'WorkSansMedium',
                                                              )),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: <Widget>[
                                                          Text(
                                                              'RSSI : ${beacon.rssi}',
                                                              style: TextStyle(
                                                                fontSize: 12.0,
                                                                fontFamily:
                                                                    'WorkSansMedium',
                                                              )),
                                                          Text(
                                                              'Tx Power : ${beacon.txPower}',
                                                              style: TextStyle(
                                                                fontSize: 12.0,
                                                                fontFamily:
                                                                    'WorkSansMedium',
                                                              )),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                          'Jarak : ${beacon.accuracy}',
                                                          style: TextStyle(
                                                            fontSize: 12.0,
                                                            fontFamily:
                                                                'WorkSansMedium',
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              )));
                                    })).toList(),
                              ),
                            ),
                    ))
        ],
      ),
    );
  }
}
