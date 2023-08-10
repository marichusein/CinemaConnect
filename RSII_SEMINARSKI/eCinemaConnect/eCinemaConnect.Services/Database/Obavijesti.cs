using System;
using System.Collections.Generic;

namespace eCinemaConnect.Services.Database;

public partial class Obavijesti
{
    public int Idobavijesti { get; set; }

    public int? KorisnikId { get; set; }

    public string? Naslov { get; set; }

    public string? Sadrzaj { get; set; }

    public DateTime? DatumObjave { get; set; }

    public byte[]? Slika { get; set; }

    public DateTime? DatumUredjivanja { get; set; }

    public virtual ICollection<KomentariObavijesti> KomentariObavijestis { get; set; } = new List<KomentariObavijesti>();

    public virtual Korisnici? Korisnik { get; set; }
}
