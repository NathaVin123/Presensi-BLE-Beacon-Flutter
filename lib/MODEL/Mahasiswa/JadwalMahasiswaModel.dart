import 'dart:convert';

JadwalMahasiswaResponseModel responseModelFromJson(String str) =>
    JadwalMahasiswaResponseModel.fromJson(json.decode(str));

String responseModelToJson(JadwalMahasiswaResponseModel data) =>
    json.encode(data.toJson());

class JadwalMahasiswaResponseModel {
  final String error;
  final Data data;

  JadwalMahasiswaResponseModel({this.error, this.data});

  factory JadwalMahasiswaResponseModel.fromJson(Map<String, dynamic> json) =>
      JadwalMahasiswaResponseModel(
        error: json["error"] == null ? null : json["error"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error == null ? null : error,
        "data": data == null ? null : data.toJson(),
      };
}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data(
      {this.npm,
      this.kodemk,
      this.namamk,
      this.kelas,
      this.sks,
      this.namadosen,
      this.hari,
      this.sesi,
      this.semester,
      this.ruang,
      this.jumlahpertemuan});

  final String npm;
  final String kodemk;
  final String namamk;
  final String kelas;
  final String sks;
  final String namadosen;
  final String hari;
  final String sesi;
  final String semester;
  final String ruang;
  final String jumlahpertemuan;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        npm: json["NPM"] == null ? null : json["NPM"],
        kodemk: json["KODE_MK"] == null ? null : json["KODE_MK"],
        namamk: json["NAMA_MK"] == null ? null : json["NAMA_MK"],
        kelas: json["KELAS"] == null ? null : json["KELAS"],
        sks: json["SKS"] == null ? null : json["SKS"],
        namadosen: json["NAMA_DOSEN_LENGKAP"] == null
            ? null
            : json["NAMA_DOSEN_LENGKAP"],
        hari: json["HARI"] == null ? null : json["HARI"],
        sesi: json["SESI"] == null ? null : json["SESI"],
        semester: json["SEMESTER"] == null ? null : json["SEMESTER"],
        ruang: json["RUANG1"] == null ? null : json["RUANG1"],
        jumlahpertemuan:
            json["JUMLAH_PERTEMUAN"] == null ? null : json["JUMLAH_PERTEMUAN"],
      );

  Map<String, dynamic> toJson() => {
        "NPM": npm == null ? null : npm,
        "KODE_MK": kodemk == null ? null : kodemk,
        "NAMA_MK": namamk == null ? null : namamk,
        "KELAS": kelas == null ? null : kelas,
        "SKS": sks == null ? null : sks,
        "NAMA_DOSEN_LENGKAP": namadosen == null ? null : namadosen,
        "HARI": hari == null ? null : hari,
        "SESI": sesi == null ? null : sesi,
        "SEMESTER": semester == null ? null : semester,
        "RUANG1": ruang == null ? null : ruang,
        "JUMLAH_PERTEMUAN": jumlahpertemuan == null ? null : jumlahpertemuan,
      };
}

JadwalMahasiswaRequestModel requestModelFromJson(String str) =>
    JadwalMahasiswaRequestModel.fromJson(json.decode(str));
String requestModelToJson(JadwalMahasiswaRequestModel data) =>
    json.encode(data.toJson());

class JadwalMahasiswaRequestModel {
  String npm;

  JadwalMahasiswaRequestModel({
    this.npm,
  });

  factory JadwalMahasiswaRequestModel.fromJson(Map<String, dynamic> json) =>
      JadwalMahasiswaRequestModel(
        npm: json["NPM"] == null ? null : json["NPM"],
      );

  Map<String, dynamic> toJson() => {
        "NPM": npm == null ? null : npm.trim(),
      };
}
