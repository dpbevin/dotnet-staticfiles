FROM mcr.microsoft.com/dotnet/sdk:7.0-alpine-amd64 AS build-env
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

# Create runtime image
FROM dpb-alpine-chiseled

WORKDIR /app
COPY --from=build-env --chown=1111:1111 /app/out ./

EXPOSE 80
ENTRYPOINT ["./staticfiles"]