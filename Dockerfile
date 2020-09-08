#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS runtime
WORKDIR /myworkingdirectory
EXPOSE 443
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["GRPCDocker.csproj", ""]
RUN dotnet restore "./GRPCDocker.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "GRPCDocker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "GRPCDocker.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /myworkingdirectory
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "GRPCDocker.dll"]