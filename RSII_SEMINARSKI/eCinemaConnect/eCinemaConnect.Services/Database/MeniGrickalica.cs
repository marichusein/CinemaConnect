using System;
using System.Collections.Generic;

namespace eCinemaConnect.Services.Database;

public partial class MeniGrickalica
{
    public int Idgrickalice { get; set; }

    public string? Naziv { get; set; }

    public string? Opis { get; set; }

    public decimal? Cijena { get; set; }

    public byte[]? Slika { get; set; }

    public virtual ICollection<RezervacijeMeniGrickalica> RezervacijeMeniGrickalicas { get; set; } = new List<RezervacijeMeniGrickalica>();
}
