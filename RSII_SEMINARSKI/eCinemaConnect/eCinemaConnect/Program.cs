using eCinemaConnect;
using eCinemaConnect.Model;
using eCinemaConnect.Services;
using eCinemaConnect.Services.Database;
using eCinemaConnect.Services.Interface;
using eCinemaConnect.Services.RabbitMQ;
using eCinemaConnect.Services.Service;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddTransient<ITipGledatelja, TipGledateljaService>();
builder.Services.AddTransient<IReziser, ReziseriService>();
builder.Services.AddTransient<IGlumci, GlumciService>();
builder.Services.AddTransient<IZanrovi, ZanroviService>();
builder.Services.AddTransient<IFilmovi, FilmoviService>();
builder.Services.AddTransient<ISale, SaleService>();
builder.Services.AddTransient<IMeniGrickalica, MeniGrickalicaService>();
builder.Services.AddTransient<IProjekcije, ProjekcijeService>();
builder.Services.AddTransient<IRepertoar, RepertoarService>();
builder.Services.AddTransient<IRecenzije, RecenzijeService>();
builder.Services.AddTransient<ISjediste, SjedisteService>();
builder.Services.AddTransient<IKorisnici, KorisniciService>();
builder.Services.AddTransient<IObavijesti, ObavijestiService>();
builder.Services.AddTransient<IOcijeni, OcijeniFilmService>();
builder.Services.AddTransient<IKomentariObavijesti, KomentariObavijestiService>();
builder.Services.AddTransient<IRezervacije, RezervacijeService>();
builder.Services.AddTransient<IRabbitMQProducer, RabbitMQProducer>();
















builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
    {
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference{Type = ReferenceType.SecurityScheme, Id = "basicAuth" }
            },
            new string[]{}
        }
    });
});



var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<CinemaContext>(options => options.UseSqlServer(connectionString));

builder.Services.AddAutoMapper(typeof(ITipGledatelja));
builder.Services.AddAutoMapper(typeof(IReziser));
builder.Services.AddAutoMapper(typeof(IGlumci));
builder.Services.AddAutoMapper(typeof(IZanrovi));
builder.Services.AddAutoMapper(typeof(IFilmovi));
builder.Services.AddAutoMapper(typeof(ISale));
builder.Services.AddAutoMapper(typeof(IMeniGrickalica));
builder.Services.AddAutoMapper(typeof(IProjekcije));
builder.Services.AddAutoMapper(typeof(IRepertoar));
builder.Services.AddAutoMapper(typeof(IRecenzije));
builder.Services.AddAutoMapper(typeof(ISjediste));
builder.Services.AddAutoMapper(typeof(IKorisnici));
builder.Services.AddAutoMapper(typeof(IObavijesti));
builder.Services.AddAutoMapper(typeof(IOcijeni));
builder.Services.AddAutoMapper(typeof(IKomentariObavijesti));
builder.Services.AddAutoMapper(typeof(IRezervacije));


builder.Services.AddAuthentication("BasicAuthentication").AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);















var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.UseCors(builder =>
{
    builder.AllowAnyOrigin()
           .AllowAnyHeader()
           .AllowAnyMethod();
});

app.MapControllers();

app.Run();