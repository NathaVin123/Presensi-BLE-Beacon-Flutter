import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:presensiblebeacon/UI/Dosen/Akun/DosenAkunDashboardPage.dart';
import 'package:presensiblebeacon/UI/Dosen/DosenDashboardPage.dart';
import 'package:presensiblebeacon/UI/Dosen/Jadwal/DosenJadwalDashboardPage.dart';
import 'package:presensiblebeacon/UI/Dosen/Presensi/DosenPresensiDashboardPage.dart';
import 'package:presensiblebeacon/UI/Dosen/Riwayat/DosenRiwayatDashboardPage.dart';
import 'package:presensiblebeacon/UI/Login/BluetoothOff.dart';
import 'package:presensiblebeacon/UI/Login/LoginPage.dart';
import 'package:presensiblebeacon/UI/Login/LoginWidgets/LoginDosen.dart';
import 'package:presensiblebeacon/UI/Login/LoginWidgets/LoginMahasiswa.dart';
import 'package:presensiblebeacon/UI/Login/SplashPage.dart';
import 'package:presensiblebeacon/UI/Mahasiswa/Akun/MahasiswaAkunDashboardPage.dart';
import 'package:presensiblebeacon/UI/Mahasiswa/Jadwal/MahasiswaJadwalDashboardPage.dart';
import 'package:presensiblebeacon/UI/Mahasiswa/MahasiswaDashboardPage.dart';
import 'package:presensiblebeacon/UI/Mahasiswa/Presensi/MahasiswaPresensiDashboardPage.dart';
import 'package:presensiblebeacon/UI/Mahasiswa/Riwayat/MahasiswaRiwayatDashboardPage.dart';
import 'package:presensiblebeacon/UI/Statistik/DosenStatistikPage.dart';
import 'package:presensiblebeacon/UI/Statistik/MahasiswaStatistikPage.dart';
import 'package:presensiblebeacon/UI/Tentang/TentangPage.dart';

import 'UI/Mahasiswa/Akun/MahasiswaInformasiAkunPage.dart';

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // bool isMahasiswa = false;

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    // _initCheckLoginMahasiswa();
  }

  Future<bool> _requestPermission(PermissionGroup permission) async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  Future<bool> requestLocationPermission({Function onPermissionDenied}) async {
    var granted = await _requestPermission(PermissionGroup.location);
    if (granted != true) {
      requestLocationPermission();
    }
    debugPrint('requestContactsPermission $granted');
    return granted;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Presensi BLE Beacon',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      debugShowCheckedModeBanner: false,
      // home: SplashPage(),
      initialRoute: '/',
      getPages: [
        // Splash Page
        GetPage(
            name: '/', page: () => SplashPage(), transition: Transition.fade),
        // BluetoothOff Page
        GetPage(
            name: '/bluetooth',
            page: () => BluetoothOff(),
            transition: Transition.fade),
        // Login Page
        GetPage(
            name: '/login',
            page: () => LoginPage(),
            transition: Transition.fade),
        GetPage(name: '/login/mahasiswa', page: () => LoginMahasiswa()),
        GetPage(name: '/login/dosen', page: () => LoginDosen()),
        // Mahasiswa Page
        GetPage(
            name: '/mahasiswa/dashboard',
            page: () => MahasiswaDashboardPage(),
            transition: Transition.fade),
        GetPage(
            name: '/mahasiswa/dashboard/presensi',
            page: () => MahasiswaPresensiDashboardPage()),
        GetPage(
            name: '/mahasiswa/dashboard/jadwal',
            page: () => MahasiswaJadwalDashboardPage()),
        GetPage(
            name: '/mahasiswa/dashboard/riwayat',
            page: () => MahasiswaRiwayatDashboardPage()),
        GetPage(
            name: '/mahasiswa/dashboard/akun',
            page: () => MahasiswaAkunDashboardPage()),
        GetPage(
            name: '/mahasiswa/dashboard/akun/informasi',
            page: () => MahasiswaInformasiAkunPage()),
        // Dosen Page
        GetPage(
            name: '/dosen/dashboard',
            page: () => DosenDashboardPage(),
            transition: Transition.fade),
        GetPage(
            name: '/dosen/dashboard/presensi',
            page: () => DosenPresensiDashboardPage()),
        GetPage(
            name: '/dosen/dashboard/jadwal',
            page: () => DosenJadwalDashboardPage()),
        GetPage(
            name: '/dosen/dashboard/riwayat',
            page: () => DosenRiwayatDashboardPage()),
        GetPage(
            name: '/dosen/dashboard/akun',
            page: () => DosenAkunDashboardPage()),
        // Statistik Page
        GetPage(
            name: '/statistik/mahasiswa',
            page: () => MahasiswaStatistikPage(),
            transition: Transition.fade),
        GetPage(
            name: '/statistik/dosen',
            page: () => DosenStatistikPage(),
            transition: Transition.fade),
        // Tentang Page
        GetPage(
            name: '/tentang',
            page: () => TentangPage(),
            transition: Transition.fade),
      ],
    );
  }

  // void _initCheckLoginMahasiswa() async {
  //   SharedPreferences dataLoginMahasiswa =
  //       await SharedPreferences.getInstance();

  //   if (dataLoginMahasiswa.getBool('isMahasiswa') != null) {
  //     setState(() {
  //       isMahasiswa = dataLoginMahasiswa.getBool('isMahasiswa');
  //     });
  //   }
  // }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
