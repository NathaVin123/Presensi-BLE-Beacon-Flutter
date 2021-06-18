import 'package:http/http.dart' as http;
import 'package:presensiblebeacon/MODEL/Mahasiswa/JadwalMahasiswaModel.dart';
import 'dart:convert';
import '../MODEL/Login/LoginMahasiswaModel.dart';
import '../MODEL/Login/LoginDosenModel.dart';

class APIService {
  // Login Mahasiswa API
  Future<LoginMahasiswaResponseModel> loginMahasiswa(
      LoginMahasiswaRequestModel requestModel) async {
    try {
      String url = "https://192.168.100.227:5000/api/auth/loginmhs";
      print(url);
      http.Response response =
          await http.post(url, body: requestModel.toJson());
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
    } catch (e) {
      print(e);
    }
  }

  // Login Dosen API
  Future<LoginDosenResponseModel> loginDosen(
      LoginDosenRequestModel requestModel) async {
    try {
      String url = "https://192.168.100.227:5000/api/auth/logindsn";
      print(url);
      http.Response response =
          await http.post(url, body: requestModel.toJson());
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
    } catch (e) {
      print(e);
    }
  }

  // Get Jadwal Mahasiswa API
  // Future<JadwalMahasiswaResponseModel> jadwalMahasiswa(
  //     JadwalMahasiswaRequestModel requestModel) async {
  //   String url = "https://192.168.100.227:5000/api/jadwalmhs/postgetall";
  //   print(url);
  //   http.Response response = await http.post(url, body: requestModel.toJson());
  //   print(response.statusCode);
  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     return JadwalMahasiswaResponseModel.fromJson(
  //       json.decode(response.body),
  //     );
  //   } else if (response.statusCode == 400 || response.statusCode == 422) {
  //     print(response.body);
  //     return JadwalMahasiswaResponseModel.fromJson(
  //       json.decode(response.body),
  //     );
  //   } else {
  //     print(response);
  //     throw Exception('Failed to load data!');
  //   }
  // }

  // Get Riwayat Mahasiswa API
  // Future<JadwalMahasiswaResponseModel> riwayatMahasiswa(
  //     JadwalMahasiswaRequestModel requestModel) async {
  //   String url = "https://192.168.100.56:5000/api/jadwalmhs/jadwalmhs";
  //   print(url);
  //   http.Response response = await http.post(url, body: requestModel.toJson());
  //   print(response.statusCode);
  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     return JadwalMahasiswaResponseModel.fromJson(
  //       json.decode(response.body),
  //     );
  //   } else if (response.statusCode == 400 || response.statusCode == 422) {
  //     print(response.body);
  //     return JadwalMahasiswaResponseModel.fromJson(
  //       json.decode(response.body),
  //     );
  //   } else {
  //     print(response);
  //     throw Exception('Failed to load data!');
  //   }
  // }
}
