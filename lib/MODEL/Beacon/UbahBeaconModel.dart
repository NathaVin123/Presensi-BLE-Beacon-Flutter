class UbahBeaconRequestModel {
  String uuid;
  String namadevice;
  String jarakmin;

  UbahBeaconRequestModel({this.uuid, this.namadevice, this.jarakmin});

  factory UbahBeaconRequestModel.fromJson(Map<String, dynamic> json) =>
      UbahBeaconRequestModel(
        uuid: json["UUID"] as String,
        namadevice: json["NAMA_DEVICE"] as String,
        jarakmin: json["JARAK_MIN"] as String,
      );

  Map<String, dynamic> toJson() =>
      {"UUID": uuid, "NAMA_DEVICE": namadevice, "JARAK_MIN": jarakmin};
}
