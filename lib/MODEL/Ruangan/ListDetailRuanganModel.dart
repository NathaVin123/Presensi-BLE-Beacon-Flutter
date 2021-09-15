import 'dart:convert';

ListDetailRuanganResponseModel responseModelFromJson(String str) =>
    ListDetailRuanganResponseModel.fromJson(json.decode(str));

String responseModelToJson(ListDetailRuanganResponseModel data) =>
    json.encode(data.toJson());

class ListDetailRuanganResponseModel {
  final String error;
  List<Data> data;

  ListDetailRuanganResponseModel({this.error, this.data});

  factory ListDetailRuanganResponseModel.fromJson(Map<String, dynamic> json) =>
      ListDetailRuanganResponseModel(
        error: json["error"],
        data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
        // data: json["data"]
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        // "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "data": data == null
      };
}

class Data {
  final String ruang;
  final String fakultas;
  final String prodi;
  final String uuid;
  final String namadevice;
  final double jarak;

  Data({
    this.ruang,
    this.fakultas,
    this.prodi,
    this.uuid,
    this.namadevice,
    this.jarak,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        ruang: json["RUANG"],
        fakultas: json["FAKULTAS"],
        prodi: json["PRODI"],
        uuid: json["PROXIMITY_UUID"],
        namadevice: json["NAMA_DEVICE"],
        jarak: ((json["JARAK_MIN_DEC"] as num) ?? 0.0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "RUANG": ruang,
        "FAKULTAS": fakultas,
        "PRODI": prodi,
        "PROXIMITY_UUID": uuid,
        "NAMA_DEVICE": namadevice,
        "JARAK_MIN_DEC": jarak,
      };
}
