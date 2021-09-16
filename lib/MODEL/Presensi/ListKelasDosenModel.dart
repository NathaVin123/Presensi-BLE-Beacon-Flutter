import 'dart:convert';

ListKelasDosenResponseModel responseModelFromJson(String str) =>
    ListKelasDosenResponseModel.fromJson(json.decode(str));

String responseModelToJson(ListKelasDosenResponseModel data) =>
    json.encode(data.toJson());

class ListKelasDosenResponseModel {
  final String error;
  List<Data> data;

  ListKelasDosenResponseModel({this.error, this.data});

  factory ListKelasDosenResponseModel.fromJson(Map<String, dynamic> json) =>
      ListKelasDosenResponseModel(
        error: json["error"],
        data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Data {
  // final int idkelas;
  final String namamk;
  final String kelas;
  final String nppdosen1;
  final String namadosen1;
  final String nppdosen2;
  final String namadosen2;
  final String nppdosen3;
  final String namadosen3;
  final String nppdosen4;
  final String namadosen4;
  final String hari1;
  final String hari2;
  final String hari3;
  final String hari4;
  final String sesi1;
  final String sesi2;
  final String sesi3;
  final String sesi4;
  // final int sks;
  final String ruang;
  final String uuid;
  final String namadevice;
  final double jarakmin;
  // final int kapasitas;

  Data({
    // this.idkelas,
    this.namamk,
    this.kelas,
    this.nppdosen1,
    this.namadosen1,
    this.nppdosen2,
    this.namadosen2,
    this.nppdosen3,
    this.namadosen3,
    this.nppdosen4,
    this.namadosen4,
    this.hari1,
    this.hari2,
    this.hari3,
    this.hari4,
    this.sesi1,
    this.sesi2,
    this.sesi3,
    this.sesi4,
    // this.sks,
    this.ruang,
    this.uuid,
    this.namadevice,
    this.jarakmin,
    // this.kapasitas,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        // idkelas: ((json["ID_Kelas"] as num) ?? 0).toInt(),
        namamk: json["NAMA_MK"],
        kelas: json["KELAS"],
        nppdosen1: json["NPP_DOSEN1"],
        namadosen1: json["NAMA_DOSEN1"],
        nppdosen2: json["NPP_DOSEN2"],
        namadosen2: json["NAMA_DOSEN2"],
        nppdosen3: json["NPP_DOSEN3"],
        namadosen3: json["NAMA_DOSEN3"],
        nppdosen4: json["NPP_DOSEN4"],
        namadosen4: json["NAMA_DOSEN4"],
        hari1: json["HARI1"],
        hari2: json["HARI2"],
        hari3: json["HARI3"],
        hari4: json["HARI4"],
        sesi1: json["SESI1"],
        sesi2: json["SESI2"],
        sesi3: json["SESI3"],
        sesi4: json["SESI4"],
        // sks: ((json["SKS"] as num) ?? 0).toInt(),
        ruang: json["RUANG"],
        uuid: json["PROXIMITY_UUID"],
        namadevice: json["NAMA_DEVICE"],
        jarakmin: ((json["JARAK_MIN_DEC"] as num) ?? 0.0).toDouble(),
        // kapasitas: ((json["KAPASITAS_KELAS"] as num) ?? 0).toInt(),
      );

  Map<String, dynamic> toJson() => {
        // "ID_Kelas": idkelas,
        "NAMA_MK": namamk,
        "KELAS": kelas,
        "NPP_DOSEN1": nppdosen1,
        "NAMA_DOSEN1": namadosen1,
        "NPP_DOSEN2": nppdosen2,
        "NAMA_DOSEN2": namadosen2,
        "NPP_DOSEN3": nppdosen3,
        "NAMA_DOSEN3": namadosen3,
        "NPP_DOSEN4": nppdosen4,
        "NAMA_DOSEN4": namadosen4,
        "HARI1": hari1,
        "HARI2": hari2,
        "HARI3": hari3,
        "HARI4": hari4,
        "SESI1": sesi1,
        "SESI2": sesi2,
        "SESI3": sesi3,
        "SESI4": sesi4,
        // "SKS": sks,
        "RUANG": ruang,
        "PROXIMITY_UUID": uuid,
        "NAMA_DEVICE": namadevice,
        "JARAK_MIN_DEC": jarakmin,
        // "KAPASITAS_KELAS": kapasitas,
      };
}

class ListKelasDosenRequestModel {
  String npp;
  String semester;

  ListKelasDosenRequestModel({this.npp, this.semester});

  factory ListKelasDosenRequestModel.fromJson(Map<String, dynamic> json) =>
      ListKelasDosenRequestModel(
        npp: json["NPP"] as String,
        semester: json["SEMESTER"] as String,
      );

  Map<String, dynamic> toJson() => {
        "NPP": npp,
        "SEMESTER": semester,
      };
}
