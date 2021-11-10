var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}

app.UseFileServer();

app.UseRouting();

app.Run();
