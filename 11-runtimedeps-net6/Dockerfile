FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
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

# Build runtime image
FROM mcr.microsoft.com/dotnet/runtime-deps:6.0-alpine3.13-amd64
WORKDIR /app
COPY --from=build-env /app/out .
ENV DOTNET_RUNNING_IN_CONTAINER=true \
  ASPNETCORE_URLS=http://+:80
EXPOSE 80
ENTRYPOINT ["./staticfiles"]