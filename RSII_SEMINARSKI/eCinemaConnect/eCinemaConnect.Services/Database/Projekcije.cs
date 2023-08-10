using System;
using System.Collections.Generic;

namespace eCinemaConnect.Services.Database;

public partial class Projekcije
{
    public int Idprojekcije { get; set; }

    public int? FilmId { get; set; }

    public int? SalaId { get; set; }

    public DateTime? DatumVrijemeProjekcije { get; set; }

    public decimal? CijenaKarte { get; set; }

    public virtual Filmovi? Film { get; set; }

    public virtual ICollection<ProjekcijeRepertoari> ProjekcijeRepertoaris { get; set; } = new List<ProjekcijeRepertoari>();

    public virtual ICollection<ProjekcijeSjedistum> ProjekcijeSjedista { get; set; } = new List<ProjekcijeSjedistum>();

    public virtual ICollection<Rezervacije> Rezervacijes { get; set; } = new List<Rezervacije>();

    public virtual Sale? Sala { get; set; }
}
