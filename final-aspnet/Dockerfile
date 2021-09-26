# Use dotnet runtime deps to gather all dependencies
FROM mcr.microsoft.com/dotnet/aspnet:5.0.10-alpine3.14-amd64 as base

# Cleanup /lib
RUN find /lib -type d -empty -delete && \
    rm -r /lib/apk && \
    rm -r /lib/sysctl.d

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . .
RUN dotnet publish \
    -c Release \
    -o out

# Create runtime image
FROM scratch
COPY --from=base /lib/ /lib
COPY --from=base /usr/lib /usr/lib
COPY --from=base /usr/share/dotnet /usr/share/dotnet
COPY --from=base /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

# chmod hack: extract tmp.tar file with correct flags
# see https://github.com/GoogleContainerTools/distroless/blob/main/base/tmp.tar
ADD tmp.tar .

ENV ASPNETCORE_URLS=http://+:8080 \
    DOTNET_RUNNING_IN_CONTAINER=true \
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true \
    COMPlus_EnableDiagnostics=0

WORKDIR /app
COPY --from=build-env --chown=1111:1111 /app/out ./
USER 1111:1111
EXPOSE 8080

# Use the full path to dotnet command as there's no symlink
ENTRYPOINT ["/usr/share/dotnet/dotnet", "staticfiles.dll"]
