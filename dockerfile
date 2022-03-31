FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
#EXPOSE 5000
ENV ASPNETCORE_URLS=http://+:5000
#RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
#USER appuser
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["bankTest.csproj", "./"]
RUN dotnet restore "bankTest.csproj"
COPY . .
#WORKDIR "/src/."
RUN dotnet build "bankTest.csproj" -c Release -o /app/build
FROM build AS publish
RUN dotnet publish "bankTest.csproj" -c Release -o /app/publish
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "bankTest.dll"]
