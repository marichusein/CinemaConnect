using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace eCinemaConnect.Services.Database;

public partial class CinemaContext : DbContext
{
    public CinemaContext()
    {
    }

    public CinemaContext(DbContextOptions<CinemaContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Filmovi> Filmovis { get; set; }

    public virtual DbSet<Glumci> Glumcis { get; set; }

    public virtual DbSet<GlumciFilmovi> GlumciFilmovis { get; set; }

    public virtual DbSet<KomentariObavijesti> KomentariObavijestis { get; set; }

    public virtual DbSet<Korisnici> Korisnicis { get; set; }

    public virtual DbSet<MeniGrickalica> MeniGrickalicas { get; set; }

    public virtual DbSet<Obavijesti> Obavijestis { get; set; }

    public virtual DbSet<OcjeneIkomentari> OcjeneIkomentaris { get; set; }

    public virtual DbSet<OdgovoriNaKomentare> OdgovoriNaKomentares { get; set; }

    public virtual DbSet<Projekcije> Projekcijes { get; set; }

    public virtual DbSet<ProjekcijeRepertoari> ProjekcijeRepertoaris { get; set; }

    public virtual DbSet<ProjekcijeSjedistum> ProjekcijeSjedista { get; set; }

    public virtual DbSet<Recenzije> Recenzijes { get; set; }
    public virtual DbSet<Recommender> Recommenders { get; set; }


    public virtual DbSet<Repertoari> Repertoaris { get; set; }

    public virtual DbSet<Rezervacije> Rezervacijes { get; set; }

    public virtual DbSet<RezervacijeMeniGrickalica> RezervacijeMeniGrickalicas { get; set; }

    public virtual DbSet<RezervacijeZanrovi> RezervacijeZanrovis { get; set; }

    public virtual DbSet<Reziseri> Reziseris { get; set; }

    public virtual DbSet<Sale> Sales { get; set; }

    public virtual DbSet<Sjedistum> Sjedista { get; set; }

    public virtual DbSet<TipoviGledatelja> TipoviGledateljas { get; set; }

    public virtual DbSet<Zanrovi> Zanrovis { get; set; }

//    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
//#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
//        => optionsBuilder.UseSqlServer("server=DESKTOP-5DJOIPF;database=Cinema;User ID=travel;Password=Agencija1!;Trusted_Connection=True;Encrypt=False");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Filmovi>(entity =>
        {
            entity.HasKey(e => e.Idfilma).HasName("PK__Filmovi__0DFB3B3BAA0BD309");

            entity.ToTable("Filmovi");

            entity.Property(e => e.Idfilma).HasColumnName("IDfilma");
            entity.Property(e => e.NazivFilma).HasMaxLength(100);
            entity.Property(e => e.PlakatFilma).HasMaxLength(200);
            entity.Property(e => e.ReziserId).HasColumnName("ReziserID");
            entity.Property(e => e.ZanrId).HasColumnName("ZanrID");

            entity.HasOne(d => d.Reziser).WithMany(p => p.Filmovis)
                .HasForeignKey(d => d.ReziserId)
                .HasConstraintName("FK__Filmovi__Reziser__4222D4EF");

            entity.HasOne(d => d.Zanr).WithMany(p => p.Filmovis)
                .HasForeignKey(d => d.ZanrId)
                .HasConstraintName("FK__Filmovi__ZanrID__4316F928");
        });

        modelBuilder.Entity<Glumci>(entity =>
        {
            entity.HasKey(e => e.Idglumca).HasName("PK__Glumci__5FD100C4EC7F3CE0");

            entity.ToTable("Glumci");

            entity.Property(e => e.Idglumca).HasColumnName("IDglumca");
            entity.Property(e => e.Ime).HasMaxLength(50);
            entity.Property(e => e.Prezime).HasMaxLength(50);
        });

        modelBuilder.Entity<GlumciFilmovi>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__GlumciFi__3214EC273DC6213F");

            entity.ToTable("GlumciFilmovi");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.FilmId).HasColumnName("FilmID");
            entity.Property(e => e.GlumacId).HasColumnName("GlumacID");

            entity.HasOne(d => d.Film).WithMany(p => p.GlumciFilmovis)
                .HasForeignKey(d => d.FilmId)
                .HasConstraintName("FK__GlumciFil__FilmI__45F365D3");

            entity.HasOne(d => d.Glumac).WithMany(p => p.GlumciFilmovis)
                .HasForeignKey(d => d.GlumacId)
                .HasConstraintName("FK__GlumciFil__Gluma__46E78A0C");
        });

        modelBuilder.Entity<KomentariObavijesti>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Komentar__3214EC27F9969DE3");

            entity.ToTable("KomentariObavijesti");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.DatumKomentara).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.ObavijestId).HasColumnName("ObavijestID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.KomentariObavijestis)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__Komentari__Koris__6FE99F9F");

            entity.HasOne(d => d.Obavijest).WithMany(p => p.KomentariObavijestis)
                .HasForeignKey(d => d.ObavijestId)
                .HasConstraintName("FK__Komentari__Obavi__6EF57B66");
        });

        modelBuilder.Entity<Korisnici>(entity =>
        {
            entity.HasKey(e => e.Idkorisnika).HasName("PK__Korisnic__9FBE48874B5C5E7E");

            entity.ToTable("Korisnici");

            entity.Property(e => e.Idkorisnika).HasColumnName("IDkorisnika");
            entity.Property(e => e.Email).HasMaxLength(100);
            entity.Property(e => e.Ime).HasMaxLength(50);
            entity.Property(e => e.KorisnickoIme).HasMaxLength(50);
            entity.Property(e => e.Lozinka).HasMaxLength(100);
            entity.Property(e => e.Prezime).HasMaxLength(50);
            entity.Property(e => e.Telefon).HasMaxLength(20);
            entity.Property(e => e.TipGledateljaId).HasColumnName("TipGledateljaID");

            entity.HasOne(d => d.TipGledatelja).WithMany(p => p.Korisnicis)
                .HasForeignKey(d => d.TipGledateljaId)
                .HasConstraintName("FK__Korisnici__TipGl__398D8EEE");
        });

        modelBuilder.Entity<MeniGrickalica>(entity =>
        {
            entity.HasKey(e => e.Idgrickalice).HasName("PK__MeniGric__AFCC196CD72A39EC");

            entity.ToTable("MeniGrickalica");

            entity.Property(e => e.Idgrickalice).HasColumnName("IDgrickalice");
            entity.Property(e => e.Cijena).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.Naziv).HasMaxLength(100);
        });

        modelBuilder.Entity<Obavijesti>(entity =>
        {
            entity.HasKey(e => e.Idobavijesti).HasName("PK__Obavijes__845BAAE3E86F9260");

            entity.ToTable("Obavijesti");

            entity.Property(e => e.Idobavijesti).HasColumnName("IDobavijesti");
            entity.Property(e => e.DatumObjave).HasColumnType("datetime");
            entity.Property(e => e.DatumUredjivanja).HasColumnType("datetime");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.Naslov).HasMaxLength(100);

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Obavijestis)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__Obavijest__Koris__59FA5E80");
        });

        modelBuilder.Entity<OcjeneIkomentari>(entity =>
        {
            entity.HasKey(e => e.Idocjene).HasName("PK__OcjeneIK__81E7FEC901B62685");

            entity.ToTable("OcjeneIKomentari");

            entity.Property(e => e.Idocjene).HasColumnName("IDocjene");
            entity.Property(e => e.DatumOcjene).HasColumnType("datetime");
            entity.Property(e => e.FilmId).HasColumnName("FilmID");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");

            entity.HasOne(d => d.Film).WithMany(p => p.OcjeneIkomentaris)
                .HasForeignKey(d => d.FilmId)
                .HasConstraintName("FK__OcjeneIKo__FilmI__571DF1D5");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.OcjeneIkomentaris)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__OcjeneIKo__Koris__5629CD9C");
        });

        modelBuilder.Entity<OdgovoriNaKomentare>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Odgovori__3214EC2780988414");

            entity.ToTable("OdgovoriNaKomentare");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.DatumOdgovora).HasColumnType("datetime");
            entity.Property(e => e.KomentarId).HasColumnName("KomentarID");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");

            entity.HasOne(d => d.Komentar).WithMany(p => p.OdgovoriNaKomentares)
                .HasForeignKey(d => d.KomentarId)
                .HasConstraintName("FK__OdgovoriN__Komen__72C60C4A");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.OdgovoriNaKomentares)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__OdgovoriN__Koris__73BA3083");
        });

        modelBuilder.Entity<Projekcije>(entity =>
        {
            entity.HasKey(e => e.Idprojekcije).HasName("PK__Projekci__AB609B0333EB4076");

            entity.ToTable("Projekcije");

            entity.Property(e => e.Idprojekcije).HasColumnName("IDprojekcije");
            entity.Property(e => e.CijenaKarte).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.DatumVrijemeProjekcije).HasColumnType("datetime");
            entity.Property(e => e.FilmId).HasColumnName("FilmID");
            entity.Property(e => e.SalaId).HasColumnName("SalaID");

            entity.HasOne(d => d.Film).WithMany(p => p.Projekcijes)
                .HasForeignKey(d => d.FilmId)
                .HasConstraintName("FK__Projekcij__FilmI__4BAC3F29");

            entity.HasOne(d => d.Sala).WithMany(p => p.Projekcijes)
                .HasForeignKey(d => d.SalaId)
                .HasConstraintName("FK__Projekcij__SalaI__4CA06362");
        });

        modelBuilder.Entity<ProjekcijeRepertoari>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Projekci__3214EC2731674B29");

            entity.ToTable("ProjekcijeRepertoari");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.ProjekcijaId).HasColumnName("ProjekcijaID");
            entity.Property(e => e.RepertoarId).HasColumnName("RepertoarID");

            entity.HasOne(d => d.Projekcija).WithMany(p => p.ProjekcijeRepertoaris)
                .HasForeignKey(d => d.ProjekcijaId)
                .HasConstraintName("FK__Projekcij__Proje__619B8048");

            entity.HasOne(d => d.Repertoar).WithMany(p => p.ProjekcijeRepertoaris)
                .HasForeignKey(d => d.RepertoarId)
                .HasConstraintName("FK__Projekcij__Reper__628FA481");
        });

        modelBuilder.Entity<ProjekcijeSjedistum>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Projekci__3214EC27D79A343D");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.ProjekcijaId).HasColumnName("ProjekcijaID");
            entity.Property(e => e.SjedisteId).HasColumnName("SjedisteID");

            entity.HasOne(d => d.Projekcija).WithMany(p => p.ProjekcijeSjedista)
                .HasForeignKey(d => d.ProjekcijaId)
                .HasConstraintName("FK__Projekcij__Proje__76969D2E");

            entity.HasOne(d => d.Sjediste).WithMany(p => p.ProjekcijeSjedista)
                .HasForeignKey(d => d.SjedisteId)
                .HasConstraintName("FK__Projekcij__Sjedi__778AC167");
        });

        modelBuilder.Entity<Recenzije>(entity =>
        {
            entity.HasKey(e => e.Idrecenzije).HasName("PK__Recenzij__B10C13B38F7B4234");

            entity.ToTable("Recenzije");

            entity.Property(e => e.Idrecenzije).HasColumnName("IDrecenzije");
            entity.Property(e => e.DatumObjave).HasColumnType("datetime");
            entity.Property(e => e.FilmId).HasColumnName("FilmID");
            entity.Property(e => e.NaslovRecenzije).HasMaxLength(100);

            entity.HasOne(d => d.Film).WithMany(p => p.Recenzijes)
                .HasForeignKey(d => d.FilmId)
                .HasConstraintName("FK__Recenzije__FilmI__5CD6CB2B");
        });

        modelBuilder.Entity<Recommender>(entity =>
        {
            entity.ToTable("Recommender");

            entity.Property(e => e.Id).HasColumnName("Id");
            entity.Property(e => e.FilmId).HasColumnName("FilmId");
            entity.Property(e => e.CoFilmId1).HasColumnName("CoFilmId1");
            entity.Property(e => e.CoFilmId2).HasColumnName("CoFilmId2");
            entity.Property(e => e.CoFilmId3).HasColumnName("CoFilmId3");

            // Postavljanje primarnog ključa
            entity.HasKey(e => e.Id).HasName("PK_Recommender_Id");

        
        });


        modelBuilder.Entity<Repertoari>(entity =>
        {
            entity.HasKey(e => e.Idrepertoara).HasName("PK__Repertoa__95B586343C5621ED");

            entity.ToTable("Repertoari");

            entity.Property(e => e.Idrepertoara).HasColumnName("IDrepertoara");
            entity.Property(e => e.Kraj).HasColumnType("datetime");
            entity.Property(e => e.Pocetak).HasColumnType("datetime");
        });

        modelBuilder.Entity<Rezervacije>(entity =>
        {
            entity.HasKey(e => e.Idrezervacije).HasName("PK__Rezervac__17F89442293057B0");

            entity.ToTable("Rezervacije");

            entity.Property(e => e.Idrezervacije).HasColumnName("IDrezervacije");
            entity.Property(e => e.KorisnikId).HasColumnName("KorisnikID");
            entity.Property(e => e.ProjekcijaId).HasColumnName("ProjekcijaID");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Rezervacijes)
                .HasForeignKey(d => d.KorisnikId)
                .HasConstraintName("FK__Rezervaci__Koris__52593CB8");

            entity.HasOne(d => d.Projekcija).WithMany(p => p.Rezervacijes)
                .HasForeignKey(d => d.ProjekcijaId)
                .HasConstraintName("FK__Rezervaci__Proje__534D60F1");
        });

        modelBuilder.Entity<RezervacijeMeniGrickalica>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Rezervac__3214EC27809E49E3");

            entity.ToTable("RezervacijeMeniGrickalica");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.MeniGrickalicaId).HasColumnName("MeniGrickalicaID");
            entity.Property(e => e.RezervacijaId).HasColumnName("RezervacijaID");

            entity.HasOne(d => d.MeniGrickalica).WithMany(p => p.RezervacijeMeniGrickalicas)
                .HasForeignKey(d => d.MeniGrickalicaId)
                .HasConstraintName("FK__Rezervaci__MeniG__6C190EBB");

            entity.HasOne(d => d.Rezervacija).WithMany(p => p.RezervacijeMeniGrickalicas)
                .HasForeignKey(d => d.RezervacijaId)
                .HasConstraintName("FK__Rezervaci__Rezer__6B24EA82");
        });

        modelBuilder.Entity<RezervacijeZanrovi>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__Rezervac__3214EC27AD3BEF69");

            entity.ToTable("RezervacijeZanrovi");

            entity.Property(e => e.Id).HasColumnName("ID");
            entity.Property(e => e.RezervacijaId).HasColumnName("RezervacijaID");
            entity.Property(e => e.ZanrId).HasColumnName("ZanrID");

            entity.HasOne(d => d.Rezervacija).WithMany(p => p.RezervacijeZanrovis)
                .HasForeignKey(d => d.RezervacijaId)
                .HasConstraintName("FK__Rezervaci__Rezer__656C112C");

            entity.HasOne(d => d.Zanr).WithMany(p => p.RezervacijeZanrovis)
                .HasForeignKey(d => d.ZanrId)
                .HasConstraintName("FK__Rezervaci__ZanrI__66603565");
        });

        modelBuilder.Entity<Reziseri>(entity =>
        {
            entity.HasKey(e => e.Idrezisera).HasName("PK__Reziseri__683F778C741040C8");

            entity.ToTable("Reziseri");

            entity.Property(e => e.Idrezisera).HasColumnName("IDrezisera");
            entity.Property(e => e.Ime).HasMaxLength(50);
            entity.Property(e => e.Prezime).HasMaxLength(50);
        });

        modelBuilder.Entity<Sale>(entity =>
        {
            entity.HasKey(e => e.Idsale).HasName("PK__Sale__AD70D5E14DCB8FE0");

            entity.ToTable("Sale");

            entity.Property(e => e.Idsale).HasColumnName("IDsale");
            entity.Property(e => e.NazivSale).HasMaxLength(50);
        });

        modelBuilder.Entity<Sjedistum>(entity =>
        {
            entity.HasKey(e => e.Idsjedista).HasName("PK__Sjedista__E401B99A0879DD14");

            entity.Property(e => e.Idsjedista).HasColumnName("IDsjedista");
            entity.Property(e => e.SalaId).HasColumnName("SalaID");

            entity.HasOne(d => d.Sala).WithMany(p => p.Sjedista)
                .HasForeignKey(d => d.SalaId)
                .HasConstraintName("FK__Sjedista__SalaID__4F7CD00D");
        });

        modelBuilder.Entity<TipoviGledatelja>(entity =>
        {
            entity.HasKey(e => e.Idtipa).HasName("PK__TipoviGl__B872A7ED4BCE9C60");

            entity.ToTable("TipoviGledatelja");

            entity.Property(e => e.Idtipa).HasColumnName("IDtipa");
            entity.Property(e => e.NazivTipa).HasMaxLength(50);
        });

        modelBuilder.Entity<Zanrovi>(entity =>
        {
            entity.HasKey(e => e.Idzanra).HasName("PK__Zanrovi__4931E32F71952652");

            entity.ToTable("Zanrovi");

            entity.Property(e => e.Idzanra).HasColumnName("IDzanra");
            entity.Property(e => e.NazivZanra).HasMaxLength(50);
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
