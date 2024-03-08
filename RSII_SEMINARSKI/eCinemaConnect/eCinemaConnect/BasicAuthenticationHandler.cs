using eCinemaConnect.Model.InsertRequests;
using eCinemaConnect.Services.Database;
using eCinemaConnect.Services.Interface;
using eCinemaConnect.Services.Service;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using System.Text.Encodings.Web;

namespace eCinemaConnect
{
    public class BasicAuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
    {
        protected readonly IKorisnici _korisniciService;
        public BasicAuthenticationHandler(IOptionsMonitor<AuthenticationSchemeOptions> options, ILoggerFactory logger, UrlEncoder encoder, ISystemClock clock, IKorisnici korisnici) : base(options, logger, encoder, clock)
        {
            _korisniciService= korisnici;
        }

        protected override async Task<AuthenticateResult> HandleAuthenticateAsync()
        {
            if (!Request.Headers.ContainsKey("Authorization"))
            {
                return AuthenticateResult.Fail("Missing header");
            }

            Model.ViewRequests.KorisniciView korisnik = null;
            KorisniciLogin podaciZaPrijavu = new KorisniciLogin();

            try
            {
                var authHeader = AuthenticationHeaderValue.Parse(Request.Headers["Authorization"]);
                var credentialsBytes = Convert.FromBase64String(authHeader.Parameter);
                var credentials = Encoding.UTF8.GetString(credentialsBytes).Split(':');

                var username = credentials[0];
                var password = credentials[1];

                podaciZaPrijavu.KorisnickoIme = username;
                podaciZaPrijavu.Lozinka = password;

                korisnik = await _korisniciService.Login(podaciZaPrijavu);

                if (korisnik == null)
                {
                    return AuthenticateResult.Fail("Incorrect username or password");
                }

                var claims = new List<Claim>
        {
            new Claim(ClaimTypes.NameIdentifier, korisnik.KorisnickoIme),
            new Claim(ClaimTypes.Name, korisnik.Ime),
            new Claim(ClaimTypes.Role, korisnik.Tip.NazivTipa) // Assuming "sve" is a default role
        };

                var identity = new ClaimsIdentity(claims, Scheme.Name);
                var principal = new ClaimsPrincipal(identity);
                var ticket = new AuthenticationTicket(principal, Scheme.Name);
                return AuthenticateResult.Success(ticket);
            }
            catch (FormatException)
            {
                return AuthenticateResult.Fail("Invalid authorization header format");
            }
            catch (Exception)
            {
                return AuthenticateResult.Fail("An error occurred while authenticating");
            }
        }

    }
}
