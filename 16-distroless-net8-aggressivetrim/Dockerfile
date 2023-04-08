FROM mcr.microsoft.com/dotnet/sdk:8.0.100-preview.2-alpine3.17-amd64 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
COPY global.json ./
RUN dotnet restore

# Copy everything else and build
COPY . .
RUN dotnet publish \
    --runtime alpine-x64 \
    --self-contained true \
    /p:PublishSingleFile=true \
    -c Release \
    -o out

# Use dotnet runtime deps to gather all dependencies
FROM mcr.microsoft.com/dotnet/runtime-deps:8.0.0-preview.2-alpine3.17-amd64 as base

# Cleanup /lib
RUN find /lib -type d -empty -delete && \
    rm -r /lib/apk && \
    rm -r /lib/sysctl.d

# Create runtime image
FROM scratch
COPY --from=base /lib/ /lib
COPY --from=base /usr/lib /usr/lib
COPY --from=base /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=base /tmp/ /tmp

ENV \
    # Configure web servers to bind to port 8080 when present
    ASPNETCORE_HTTP_PORTS=8080 \
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true \
    # Set the invariant mode since ICU package isn't included (see https://github.com/dotnet/announcements/issues/20)
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true

WORKDIR /app
COPY --from=build-env --chown=1111:1111 /app/out ./

EXPOSE 8080
ENTRYPOINT ["./staticfiles"]
