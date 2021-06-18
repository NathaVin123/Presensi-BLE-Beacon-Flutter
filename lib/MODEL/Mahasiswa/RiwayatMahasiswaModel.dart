import 'dart:convert';

class RiwayatMahasiswaResponseModel {
  final String error;
  final Data data;

  RiwayatMahasiswaResponseModel({this.error, this.data});

  factory RiwayatMahasiswaResponseModel.fromJson(Map<String, dynamic> json) =>
      RiwayatMahasiswaResponseModel(
        error: json["error"],
        data: json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error == null,
        "data": data == null,
      };
}

class Data {
  Data(
      this.idkelas,
      this.namamk,
      this.pertemuan,
      this.status,
      this.tglin,
      this.tglout,
      this.tglverifikasi,
      this.semester);

  final String idkelas;
  final String namamk;
  final String pertemuan;
  final String status;
  final String tglin;
  final String tglout;
  final String tglverifikasi;
  final String semester;

}
