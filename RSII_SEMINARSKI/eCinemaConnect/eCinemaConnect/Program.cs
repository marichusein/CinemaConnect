using eCinemaConnect.Model;
using eCinemaConnect.Services;
using eCinemaConnect.Services.Database;
using eCinemaConnect.Services.Interface;
using eCinemaConnect.Services.Service;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;


var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddTransient<ITipGledatelja, TipGledateljaService>();
builder.Services.AddTransient<IReziser, ReziseriService>();
builder.Services.AddTransient<IGlumci, GlumciService>();
builder.Services.AddTransient<IZanrovi, ZanroviService>();



builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<CinemaContext>(options => options.UseSqlServer(connectionString));

builder.Services.AddAutoMapper(typeof(ITipGledatelja));
builder.Services.AddAutoMapper(typeof(IReziser));
builder.Services.AddAutoMapper(typeof(IGlumci));
builder.Services.AddAutoMapper(typeof(IZanrovi));




var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.UseCors(builder =>
{
    builder.AllowAnyOrigin()
           .AllowAnyHeader()
           .AllowAnyMethod();
});

app.MapControllers();

app.Run();
