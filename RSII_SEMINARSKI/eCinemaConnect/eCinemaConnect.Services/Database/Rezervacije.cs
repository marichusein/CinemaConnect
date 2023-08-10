using System;
using System.Collections.Generic;

namespace eCinemaConnect.Services.Database;

public partial class Rezervacije
{
    public int Idrezervacije { get; set; }

    public int? KorisnikId { get; set; }

    public int? ProjekcijaId { get; set; }

    public int? BrojRezervisanihKarata { get; set; }

    public bool? Kupljeno { get; set; }

    public virtual Korisnici? Korisnik { get; set; }

    public virtual Projekcije? Projekcija { get; set; }

    public virtual ICollection<RezervacijeMeniGrickalica> RezervacijeMeniGrickalicas { get; set; } = new List<RezervacijeMeniGrickalica>();

    public virtual ICollection<RezervacijeZanrovi> RezervacijeZanrovis { get; set; } = new List<RezervacijeZanrovi>();
}
