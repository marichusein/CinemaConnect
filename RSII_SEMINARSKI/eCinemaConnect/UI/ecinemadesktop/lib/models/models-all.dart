class Movie {
  String nazivFilma;
  int zanrId;
  String opis;
  int trajanje;
  int godinaIzdanja;
  int reziserId;
  String plakatFilma;
  List<Actor> glumciUFlimu;

  String filmPlakat;

  Movie({
    required this.nazivFilma,
    required this.zanrId,
    required this.opis,
    required this.trajanje,
    required this.godinaIzdanja,
    required this.reziserId,
    required this.plakatFilma,
    required this.filmPlakat,

    required this.glumciUFlimu,
  });

    Map<String, dynamic> toJson() {
    return {
      'nazivFilma': nazivFilma,
      'zanrId': zanrId,
      'opis': opis,
      'trajanje': trajanje,
      'godinaIzdanja': godinaIzdanja,
      'reziserId': reziserId,
      'plakatFilma': plakatFilma,
      'filmPlakat':filmPlakat,
      'glumciUFlimu': glumciUFlimu.map((actor) => actor.toJson()).toList(),
    };
  }
}

class Actor {
  int idglumca;
  String ime;
  String prezime;
  String slika;

  Actor({
    required this.idglumca,
    required this.ime,
    required this.prezime,
    required this.slika,
  });

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      idglumca: json['idglumca'],
      ime: json['ime'],
      prezime: json['prezime'],
      slika: json['slika'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idglumca': idglumca,
      'ime': ime,
      'prezime': prezime,
      'slika': slika,
    };
  }
}

class Genre {
  int idzanra;
  String nazivZanra;

  Genre({
    required this.idzanra,
    required this.nazivZanra,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      idzanra: json['idzanra'],
      nazivZanra: json['nazivZanra'],
    );
  }
}

class Director {
  int idrezisera;
  String ime;
  String prezime;

  Director({
    required this.idrezisera,
    required this.ime,
    required this.prezime,
  });

  factory Director.fromJson(Map<String, dynamic> json) {
    return Director(
      idrezisera: json['idrezisera'],
      ime: json['ime'],
      prezime: json['prezime'],
    );
  }
}
