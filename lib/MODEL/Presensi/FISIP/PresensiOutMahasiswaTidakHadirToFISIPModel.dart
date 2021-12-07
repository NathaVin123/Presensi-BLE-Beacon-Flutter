class PresensiOUTMahasiswaTidakHadirFISIPRequestModel {
  String idkelas;

  int pertemuan;

  PresensiOUTMahasiswaTidakHadirFISIPRequestModel(
      {this.idkelas, this.pertemuan});

  factory PresensiOUTMahasiswaTidakHadirFISIPRequestModel.fromJson(
          Map<String, dynamic> json) =>
      PresensiOUTMahasiswaTidakHadirFISIPRequestModel(
        idkelas: json["ID_KELAS"] == null ? null : json['ID_KELAS'] as String,
        pertemuan:
            json["PERTEMUAN_KE"] == null ? null : json['PERTEMUAN_KE'] as int,
      );

  Map<String, dynamic> toJson() => {
        "ID_KELAS": idkelas,
        "PERTEMUAN_KE":
            pertemuan?.toString() == null ? null : pertemuan?.toString(),
      };
}
