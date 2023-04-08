var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

var app = builder.Build();

app.UseFileServer();

app.UseRouting();

app.Run();
