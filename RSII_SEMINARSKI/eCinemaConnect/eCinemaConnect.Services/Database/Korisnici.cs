using System;
using System.Collections.Generic;

namespace eCinemaConnect.Services.Database;

public partial class Korisnici
{
    public int Idkorisnika { get; set; }

    public string? Ime { get; set; }

    public string? Prezime { get; set; }

    public string? KorisnickoIme { get; set; }

    public string? Lozinka { get; set; }

    public string? Email { get; set; }

    public string? Telefon { get; set; }

    public int? TipGledateljaId { get; set; }
    public byte[]? Salt { get; set; }
    public virtual ICollection<KomentariObavijesti> KomentariObavijestis { get; set; } = new List<KomentariObavijesti>();

    public virtual ICollection<Obavijesti> Obavijestis { get; set; } = new List<Obavijesti>();

    public virtual ICollection<OcjeneIkomentari> OcjeneIkomentaris { get; set; } = new List<OcjeneIkomentari>();

    public virtual ICollection<OdgovoriNaKomentare> OdgovoriNaKomentares { get; set; } = new List<OdgovoriNaKomentare>();

    public virtual ICollection<Rezervacije> Rezervacijes { get; set; } = new List<Rezervacije>();

    public virtual TipoviGledatelja? TipGledatelja { get; set; }
}
