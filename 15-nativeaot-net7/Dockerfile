# Build image for Native AOT
FROM mcr.microsoft.com/dotnet/sdk:7.0-bullseye-slim AS build-env

# Ensure we install clang for Native AOT to work (there may be extra libraries being installed here but... it works and these never make it to the final image)
RUN apt-get update && \
    apt-get -y install clang zlib1g-dev

WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
COPY global.json ./
COPY ./nuget.config ./
RUN dotnet restore

# Copy everything else and build
COPY . .
RUN dotnet publish \
    --runtime linux-x64 \
    --self-contained true \
    -c Release \
    -o out

# Smallest distroless with the dependencies
FROM gcr.io/distroless/cc
COPY --from=build-env /lib/x86_64-linux-gnu/libz.so.1 /lib/x86_64-linux-gnu

# Add the NativeAOT application
ENV ASPNETCORE_URLS=http://+:80 \
    DOTNET_RUNNING_IN_CONTAINER=true \
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true

WORKDIR /app
COPY --from=build-env --chown=1111:1111 /app/out/staticfiles ./staticfiles
COPY --from=build-env --chown=1111:1111 /app/out/wwwroot ./wwwroot

EXPOSE 80
CMD ["./staticfiles"]
