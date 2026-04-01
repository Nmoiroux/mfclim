# mfclim

<!-- badges: start -->
[![R-multiverse status](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fcommunity.r-multiverse.org%2Fapi%2Fpackages%2Fmfclim&query=%24.Version&label=r-multiverse)](https://community.r-multiverse.org/mfclim)
<!-- badges: end -->

`mfclim` est un package R permettant de télécharger des données météorologiques archivées de Météo-France en utilisant l’[API Données Climatologiques](https://portail-api.meteofrance.fr/web/en/api/DonneesPubliquesClimatologie). Il fournit des fonctions pour s’authentifier, lister les stations, récupérer les métadonnées des stations, demander des données climatologiques, télécharger les fichiers et importer les données directement dans R.
`mfclim` permet également de télécharger directement les archives annuelles des [données ouvertes SYNOP OMM](https://meteo.data.gouv.fr/datasets/686f8595b351c06a3a790867) depuis [meteo.data.gouv.fr](https://meteo.data.gouv.fr).

Le package est principalement conçu comme une interface légère autour de l’API Météo-France.

1. [Installation](#installation)
2. [Fonctions principales](#main-functions)
3. [Télécharger des données via l’API Météo-France](#météo-france-api-access)
4. [Télécharger les données SYNOP OMM](#synop-data-open-data)

## Installation

Vous pouvez installer la version de développement de `mfclim` depuis [GitHub](https://github.com/) with:

```R 
# install.packages("devtools")
devtools::install_github("Nmoiroux/mfclim")
``` 

## Fonctions principales
| Fonction | Description |
| ------------------------ | --------------------------------------------- |
| `mfclim_get_token()` | Obtenir un jeton d’accès à l’API |
| `mfclim_list_stations()` | Lister les stations par département |
| `mfclim_info_station()` | Obtenir les métadonnées d’une station |
| `mfclim_get_data()` | Télécharger des données via l’API |
| `mfclim_synop()` | Télécharger les archives SYNOP open data |

## Accès à l’API Météo-France

Pour utiliser l’API, vous devez disposer d’identifiants du portail API Météo-France :

1. S’inscrire sur le portail et s’abonner à l’API
- Créez un compte sur le [portail API Météo-France](https://portail-api.meteofrance.fr/web/fr/), puis attendez les emails de confirmation et d’activation.
- Rendez-vous sur la page de l’[API Données Climatologiques](https://portail-api.meteofrance.fr/web/en/api/DonneesPubliquesClimatologie) et cliquez sur « Souscrire à l'API gratuitement ».
- **Connectez-vous** si ce n’est pas déjà fait (il peut être nécessaire de supprimer les cookies pour que cela fonctionne correctement).

2. Obtenir votre identifiant personnel
- Rendez-vous sur le [Tableau de bord](https://portail-api.meteofrance.fr/web/en/dashboard) (ou cliquez sur l’icône utilisateur en haut à droite puis → « Mon API »).
- Cliquez sur « Générer Token » dans le panneau « Données Climatologiques ».

En bas de la page, un bloc de code apparaît.

`curl -k -X POST https://portail-api.meteofrance.fr/token -d "grant_type=client_credentials" -H "Authorization: Basic 1nSHsOA5tKHea6IFAKE1ga8pOMcpLSTAooJfnOpgtErsJxwftUmlLFAKE6cM86efz5pAf00Pj1pv"`

Copiez la chaîne de charactères qui apparaît après « Authorization: Basic » et utilisez-la dans R :
```r 
client_auth <- "1nSHsOA5tKHea6IFAKE1ga8pOMcpLSTAooJfnOpgtErsJxwftUmlLFAKE6cM86efz5pAf00Pj1pv"
```

`client_auth` est votre identifiant unique pour le portail API ; il est utilisé pour demander un jeton d’accès nécessaire pour interroger l’API.

### Exemple – Lister les stations d’un département

```r
# load mfclim package
library(mfclim)

# you need your authentification string
client_auth <- "your_client_auth_string"

# get a token (1-hour validity)
?mfclim_get_token

token <- mfclim_get_token(client_auth)

# stations in department 34 (Hérault) with hourly data of precipitation recorded
?mfclim_list_stations

stations_34_daily <- mfclim_list_stations(
                  token = token,
                  departement = "34",
                  step = "1h",
                  parametre = "precipitation")
                  
head(stations_34_daily)
```

### Example – Obtenir les informations d’une station

``` r
# want informations on station 34154001 (MONTPELLIER-AEROPORT)
?mfclim_info_station

info_mpl_airport <- mfclim_info_station(token = token,
                                           station = 34154001)
                                           
info_mpl_airport$nom        # station name
info_mpl_airport$positions  # coordinates
info_mpl_airport$parametres # parameters recorded with corresponding dates
```

### Example – Télécharger des données journalières
```r
?mfclim_get_data

data <- mfclim_get_data(
  token = token,
  station = "34154001",
  step = "1d",
  date_deb = "2018-11-29T01:00:00Z",
  date_fin = "2018-12-30T01:00:00Z",
  file = "meteo_data.csv"
)

head(data)
```
### Notes
L’API Météo-France utilise des requêtes asynchrones : les données doivent d’abord être commandées, puis téléchargées. Les requêtes volumineuses peuvent prendre plusieurs minutes avant que le fichier soit disponible.

Les dates doivent être fournies au format ISO 8601 UTC : YYYY-MM-DDTHH:MM:SSZ.

La documentation (métadonnées) des données téléchargées est disponible sur le [Wiki Météo-France](https://confluence-meteofrance.atlassian.net/wiki/x/AYALJQ).



## Données SYNOP

Le package permet également de télécharger les données annuelles d’observations SYNOP de surface depuis le portail open data de Météo-France.

Les données SYNOP comprennent des observations météorologiques de surface transmises via le Système mondial de télécommunication de l’Organisation Météorologique Mondiale (OMM). Les observations incluent généralement la température, l’humidité, la vitesse et la direction du vent, la pression atmosphérique, les précipitations, la nébulosité, la visibilité et le temps présent. Les données sont enregistrées toutes les 3 heures et sont disponibles pour la France métropolitaine et les territoires d’outre-mer.

Veuillez consulter la [liste des stations](https://www.data.gouv.fr/api/1/datasets/r/d82625f7-091c-40c5-a4e7-313a2ba5d3ef) et les [metadonnées](https://www.data.gouv.fr/api/1/datasets/r/d129bc15-f72f-4825-a124-9c4b3747c156).

### Example
```r
# download SYNOP data for year 2020
synop2020 <- mfclim_synop(2020)
head(synop2020)
```

## License 
Ce package est distribué sous licence [GPL-3 License](https://www.gnu.org/licenses/gpl-3.0.html). 
