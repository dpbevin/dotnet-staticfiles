var hostBuilder = Host.CreateDefaultBuilder(args)
    .ConfigureWebHostDefaults(webBuilder =>
    {
        webBuilder.Configure((ctx, app) => 
        {
            app.UseStaticFiles();
            app.UseRouting();
        });
    }); 

hostBuilder.Build().Run();
