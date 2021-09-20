class PresensiINDosenBukaPresensiRequestModel {
  int idkelas;
  int bukapresensi;

  PresensiINDosenBukaPresensiRequestModel({this.idkelas, this.bukapresensi});

  factory PresensiINDosenBukaPresensiRequestModel.fromJson(
          Map<String, dynamic> json) =>
      PresensiINDosenBukaPresensiRequestModel(
        idkelas: json["ID_KELAS"] == null ? null : json['ID_KELAS'] as int,
        bukapresensi: json["IS_BUKA_PRESENSI"] == null
            ? null
            : json['IS_BUKA_PRESENSI'] as int,
      );

  Map<String, dynamic> toJson() => {
        "ID_KELAS": idkelas?.toString() == null ? null : idkelas?.toString(),
        "IS_BUKA_PRESENSI":
            bukapresensi?.toString() == null ? null : bukapresensi?.toString(),
      };
}
