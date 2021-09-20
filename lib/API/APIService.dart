import 'dart:convert';
import 'package:presensiblebeacon/MODEL/Beacon/HapusBeaconModel.dart';
import 'package:presensiblebeacon/MODEL/Beacon/ListBeaconModel.dart';
import 'package:presensiblebeacon/MODEL/Beacon/RuangBeaconModel.dart';
import 'package:presensiblebeacon/MODEL/Beacon/TambahBeaconModel.dart';
import 'package:presensiblebeacon/MODEL/Beacon/UbahBeaconModel.dart';
import 'package:presensiblebeacon/MODEL/Login/LoginAdminModel.dart';
import 'package:presensiblebeacon/MODEL/Mahasiswa/JadwalMahasiswaModel.dart';
import 'package:presensiblebeacon/MODEL/Mahasiswa/RiwayatMahasiswaModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/ListKelasDosenModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/PresensiINDosenBukaPresensiModel.dart';
import 'package:presensiblebeacon/MODEL/Presensi/TampilPesertaKelasModel.dart';
import 'package:presensiblebeacon/MODEL/Ruangan/ListDetailRuanganModel.dart';
import 'package:presensiblebeacon/MODEL/Ruangan/ListRuanganModel.dart';
import 'package:presensiblebeacon/MODEL/Ruangan/UbahRuangBeaconModel.dart';

import '../MODEL/Login/LoginMahasiswaModel.dart';
import '../MODEL/Login/LoginDosenModel.dart';
import 'package:http/http.dart' as http;

class APIService {
  String BASE_URL = 'https://192.168.100.251:5000/api/';
  // Login Mahasiswa API
  Future<LoginMahasiswaResponseModel> loginMahasiswa(
      LoginMahasiswaRequestModel requestModel) async {
    String url = BASE_URL + "auth/loginmhs";
    print(url);
    http.Response response = await http.post(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return LoginMahasiswaResponseModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      return LoginMahasiswaResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  // Login Dosen API
  Future<LoginDosenResponseModel> loginDosen(
      LoginDosenRequestModel requestModel) async {
    String url = BASE_URL + "auth/logindsn";
    print(url);
    http.Response response = await http.post(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return LoginDosenResponseModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      return LoginDosenResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future<LoginAdminResponseModel> loginAdmin(
      LoginAdminRequestModel requestModel) async {
    String url = BASE_URL + "auth/loginadm";
    print(url);
    http.Response response = await http.post(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return LoginAdminResponseModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      return LoginAdminResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  // Post Get Data Jadwal Mahasiswa
  Future<JadwalMahasiswaResponseModel> postJadwalMahasiswa(
      JadwalMahasiswaRequestModel requestModel) async {
    String url = BASE_URL + "jadwalmhs/postgetall";
    print(url);
    http.Response response = await http.post(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return JadwalMahasiswaResponseModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      return JadwalMahasiswaResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  // Post Get Data Jadwal Dosen
  Future<RiwayatMahasiswaResponseModel> postRiwayatMahasiswa(
      RiwayatMahasiswaRequestModel requestModel) async {
    String url = BASE_URL + "riwayatmhs/postgetall/";
    print(url);
    http.Response response = await http.post(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return RiwayatMahasiswaResponseModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      return RiwayatMahasiswaResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  // Get Jadwal Beacon
  Future<RuangBeaconResponseModel> getKelasBeacon() async {
    String url = BASE_URL + "ruangbeacon";
    print(url);
    http.Response response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return RuangBeaconResponseModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      return RuangBeaconResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future postTambahBeacon(TambahBeaconRequestModel requestModel) async {
    String url = BASE_URL + "ruangbeacon/tambah";
    print(url);
    http.Response response = await http.post(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      // return JadwalMahasiswaResponseModel.fromJson(
      //   json.decode(response.body),
      // );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      // return JadwalMahasiswaResponseModel.fromJson(
      //   json.decode(response.body),
      // );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future<ListBeaconResponseModel> getListBeacon() async {
    String url = BASE_URL + "ruangbeacon/tampil";
    print(url);
    http.Response response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return ListBeaconResponseModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      return ListBeaconResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future putUbahBeacon(UbahBeaconRequestModel requestModel) async {
    String url = BASE_URL + "ruangbeacon/ubah";
    print(url);
    http.Response response = await http.put(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      // return JadwalMahasiswaResponseModel.fromJson(
      //   json.decode(response.body),
      // );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      // return JadwalMahasiswaResponseModel.fromJson(
      //   json.decode(response.body),
      // );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future hapusBeacon(HapusBeaconRequestModel requestModel) async {
    String url = BASE_URL + "ruangbeacon/hapus";
    print(url);
    http.Response response = await http.delete(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return ListBeaconResponseModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      return ListBeaconResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future<ListRuanganResponseModel> getListRuangan() async {
    String url = BASE_URL + "ruangbeacon/tampilruangan";
    print(url);
    http.Response response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return ListRuanganResponseModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      return ListRuanganResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future<ListDetailRuanganResponseModel> getListDetailRuangan() async {
    String url = BASE_URL + "ruangbeacon/tampildetailruangan";
    print(url);
    http.Response response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return ListDetailRuanganResponseModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      return ListDetailRuanganResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future putUbahRuangBeacon(UbahRuangBeaconRequestModel requestModel) async {
    String url = BASE_URL + "ruangbeacon/ubahruangbeacon";
    print(url);
    http.Response response = await http.put(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      // return JadwalMahasiswaResponseModel.fromJson(
      //   json.decode(response.body),
      // );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      // return JadwalMahasiswaResponseModel.fromJson(
      //   json.decode(response.body),
      // );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future<ListKelasDosenResponseModel> postListKelasDosen(
      ListKelasDosenRequestModel requestModel) async {
    String url = BASE_URL + "presensi/postgetlistkelas";
    print(url);
    http.Response response = await http.post(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return ListKelasDosenResponseModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      return ListKelasDosenResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future putBukaPresensiDosen(
      PresensiINDosenBukaPresensiRequestModel requestModel) async {
    String url = BASE_URL + "presensi/bukapresensidosen";
    print(url);
    http.Response response = await http.put(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      // return JadwalMahasiswaResponseModel.fromJson(
      //   json.decode(response.body),
      // );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      // return JadwalMahasiswaResponseModel.fromJson(
      //   json.decode(response.body),
      // );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }

  Future<TampilPesertaKelasResponseModel> postListPesertaKelas(
      TampilPesertaKelasRequestModel requestModel) async {
    String url = BASE_URL + "presensi/postgetlistpesertakelas";
    print(url);
    http.Response response = await http.post(url, body: requestModel.toJson());
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      return TampilPesertaKelasResponseModel.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      print(response.body);
      return TampilPesertaKelasResponseModel.fromJson(
        json.decode(response.body),
      );
    } else {
      print(response);
      throw Exception('Failed to load data!');
    }
  }
}
