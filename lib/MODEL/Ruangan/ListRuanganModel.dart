import 'dart:convert';

ListRuanganResponseModel responseModelFromJson(String str) =>
    ListRuanganResponseModel.fromJson(json.decode(str));

String responseModelToJson(ListRuanganResponseModel data) =>
    json.encode(data.toJson());

class ListRuanganResponseModel {
  final String error;
  List<Data> data;

  ListRuanganResponseModel({this.error, this.data});

  String toString() => 'ListRuanganResponseModel{error: $error, data: $data}';

  factory ListRuanganResponseModel.fromJson(Map<String, dynamic> json) {
    var list = json["data"] as List;
    print(list.runtimeType);
    List<Data> dataList = list.map((i) => Data.fromJson(i)).toList();

    return ListRuanganResponseModel(error: json["error"], data: dataList);
  }

  Map<String, dynamic> toJson() => {"error": error, "data": data};
}

class Data {
  final String ruang;
  final String fakultas;
  final String prodi;
  final String namadevice;

  Data({this.ruang, this.fakultas, this.prodi, this.namadevice});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        ruang: json["RUANG"] == null ? null : json["RUANG"],
        fakultas: json["FAKULTAS"] == null ? null : json["FAKULTAS"],
        prodi: json["PRODI"] == null ? null : json["PRODI"],
        namadevice: json["NAMA_DEVICE"] == null ? null : json["NAMA_DEVICE"],
      );

  Map<String, dynamic> toJson() => {
        "RUANG": ruang,
        "FAKULTAS": fakultas,
        "PRODI": prodi,
        "NAMA_DEVICE": namadevice,
      };
}
