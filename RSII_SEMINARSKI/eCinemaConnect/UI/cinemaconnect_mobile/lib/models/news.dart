class News {
  final int id;
  final int korisnikId;
  final String naslov;
  final String sadrzaj;
  final DateTime datumObjave;
  final String slika;
  final DateTime datumUredjivanja;
  String autorIme;
  String autorPrezime;

  News({
    required this.id,
    required this.korisnikId,
    required this.naslov,
    required this.sadrzaj,
    required this.datumObjave,
    required this.slika,
    required this.datumUredjivanja,
    required this.autorIme,
    required this.autorPrezime,
  });
}
