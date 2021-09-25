# Use dotnet runtime deps to gather all dependencies
FROM mcr.microsoft.com/dotnet/runtime-deps:5.0.5-alpine3.13-amd64 as base

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
    --runtime alpine-x64 \
    --self-contained true \
    /p:PublishTrimmed=true \
    /p:PublishSingleFile=true \
    -c Release \
    -o out

# Create runtime image
FROM scratch
COPY --from=base /lib/ /lib
COPY --from=base /usr/lib /usr/lib
COPY --from=base /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

# chmod hack: extract tmp.tar file with correct flags
# see https://github.com/GoogleContainerTools/distroless/blob/main/base/tmp.tar
ADD tmp.tar .

ENV ASPNETCORE_URLS=http://+:8080 \
    DOTNET_RUNNING_IN_CONTAINER=true \
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true

WORKDIR /app
COPY --from=build-env --chown=1111:1111 /app/out ./
USER 1111:1111
EXPOSE 8080
ENTRYPOINT ["./staticfiles"]
