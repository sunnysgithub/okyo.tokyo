FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["okyo.tokyo.webapi/okyo.tokyo.webapi.csproj", "okyo.tokyo.webapi/"]
RUN dotnet restore "okyo.tokyo.webapi/okyo.tokyo.webapi.csproj"
COPY . .
WORKDIR "/src/okyo.tokyo.webapi"
RUN dotnet build "okyo.tokyo.webapi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "okyo.tokyo.webapi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "okyo.tokyo.webapi.dll"]
