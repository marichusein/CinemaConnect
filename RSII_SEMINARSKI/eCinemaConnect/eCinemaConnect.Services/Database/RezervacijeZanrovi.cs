using System;
using System.Collections.Generic;

namespace eCinemaConnect.Services.Database;

public partial class RezervacijeZanrovi
{
    public int Id { get; set; }

    public int? RezervacijaId { get; set; }

    public int? ZanrId { get; set; }

    public virtual Rezervacije? Rezervacija { get; set; }

    public virtual Zanrovi? Zanr { get; set; }
}
