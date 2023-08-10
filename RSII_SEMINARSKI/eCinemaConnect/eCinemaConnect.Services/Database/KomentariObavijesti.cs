using System;
using System.Collections.Generic;

namespace eCinemaConnect.Services.Database;

public partial class KomentariObavijesti
{
    public int Id { get; set; }

    public int? ObavijestId { get; set; }

    public int? KorisnikId { get; set; }

    public string? TekstKomentara { get; set; }

    public DateTime? DatumKomentara { get; set; }

    public virtual Korisnici? Korisnik { get; set; }

    public virtual Obavijesti? Obavijest { get; set; }

    public virtual ICollection<OdgovoriNaKomentare> OdgovoriNaKomentares { get; set; } = new List<OdgovoriNaKomentare>();
}
