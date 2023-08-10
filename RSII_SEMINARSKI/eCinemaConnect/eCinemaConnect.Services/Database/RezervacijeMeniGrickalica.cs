using System;
using System.Collections.Generic;

namespace eCinemaConnect.Services.Database;

public partial class RezervacijeMeniGrickalica
{
    public int Id { get; set; }

    public int? RezervacijaId { get; set; }

    public int? MeniGrickalicaId { get; set; }

    public virtual MeniGrickalica? MeniGrickalica { get; set; }

    public virtual Rezervacije? Rezervacija { get; set; }
}
