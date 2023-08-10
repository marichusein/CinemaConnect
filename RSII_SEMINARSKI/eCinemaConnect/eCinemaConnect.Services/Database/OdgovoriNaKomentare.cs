using System;
using System.Collections.Generic;

namespace eCinemaConnect.Services.Database;

public partial class OdgovoriNaKomentare
{
    public int Id { get; set; }

    public int? KomentarId { get; set; }

    public int? KorisnikId { get; set; }

    public string? TekstOdgovora { get; set; }

    public DateTime? DatumOdgovora { get; set; }

    public virtual KomentariObavijesti? Komentar { get; set; }

    public virtual Korisnici? Korisnik { get; set; }
}
