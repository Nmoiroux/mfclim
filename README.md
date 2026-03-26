
# mfclim

<!-- badges: start -->
<!-- badges: end -->

`mfclim` is an R package to download archived meteorological data from Météo-France using the 'Données Climatologiques' [API](https://portail-api.meteofrance.fr/web/en/api/DonneesPubliquesClimatologie). It provides functions to authenticate, list stations, retrieve station metadata, request climate data, download files, and import data directly into R. 
`mfclim` has also a function to download SYNOP WMO open data archives from [meteo.data.gouv.fr](https://meteo.data.gouv.fr/datasets/686f8595b351c06a3a790867).  

The package is primarily designed as a lightweight wrapper around the Météo-France API.

## Installation

You can install the development version of `mfclim` from [GitHub](https://github.com/) with:

```R 
# install.packages("devtools")
devtools::install_github("Nmoiroux/mfclim")
``` 

## Météo-France API access

To use the API, you need credentials from the Météo-France API portal:

1. Register to the portal and subscribe to the API
- Create an account on the [Météo-France API portal](https://portail-api.meteofrance.fr/web/fr/) and log in.
- Navigate to the '[Climatological data API page](https://portail-api.meteofrance.fr/web/en/api/DonneesPubliquesClimatologie)' and click 'Subscribe to the API for free'.

2. Get your personal identifier
- Click account button ("Hello first-name family-name", top right) 
- Go to: My API → Climatological data → Generate Token

At the bottom, there is a code block as below:

`curl -k -X POST https://portail-api.meteofrance.fr/token -d "grant_type=client_credentials" -H "Authorization: Basic 1nSHsOA5tKHea6IFAKE1ga8pOMcpLSTAooJfnOpgtErsJxwftUmlLFAKE6cM86efz5pAf00Pj1pv"`

Copy the string that appears after "Authorization: Basic" and paste it in R as follow:

`client_auth <- "1nSHsOA5tKHea6IFAKE1ga8pOMcpLSTAooJfnOpgtErsJxwftUmlLFAKE6cM86efz5pAf00Pj1pv"`

`client_auth` is your unique identifier to the API portal, it is used to request an access token required to query the API.


### Main functions
| Function                 | Description                                   |
| ------------------------ | --------------------------------------------- |
| `mfclim_get_token()`     | Get API access token                          |
| `mfclim_list_stations()` | List stations by department                   |
| `mfclim_info_station()`  | Get metadata for a station                    |
| `mfclim_get_data()`      | Download data using the API                   |
| `mfclim_synop()`         | Download SYNOP open data archive              |

### Example – List stations in a department
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

### Example – Get station information
``` r
# want informations on station 34154001 (MONTPELLIER-AEROPORT)
?mfclim_info_station

info_mpl_airport <- mfclim_info_station(token = token,
                                           station = 34154001)
                                           
info_mpl_airport$nom        # station name
info_mpl_airport$positions  # coordinates
info_mpl_airport$parametres # parameters recorded with corresponding dates
```

### Example – Download daily data
```r
?mfclim_get_data

data <- mfclim_get_data(
  token = token,
  station = "34154001",
  step = "1h",
  date_deb = "2018-11-29T01:00:00Z",
  date_fin = "2018-12-30T01:00:00Z",
  file = "meteo_data.csv"
)

head(data)
```
### Notes 
The Météo-France API uses asynchronous requests: data must first be ordered, then downloaded. Large requests may take several minutes before the file is available.

Dates must be provided in ISO 8601 UTC format: YYYY-MM-DDTHH:MM:SSZ.

Documentation (metadata) for the downloaded data are available on the Météo-France [Wiki](https://confluence-meteofrance.atlassian.net/wiki/x/AYALJQ).



## SYNOP data (open data)

The package also allows downloading SYNOP surface observation data from the Météo-France open data portal.

SYNOP data include surface meteorological observations transmitted through the World Meteorological Organization (WMO) Global Telecommunication System. Observations typically include temperature, humidity, wind speed and direction, atmospheric pressure, precipitation, cloud cover, visibility, and present weather. Data are available every 3 hours for mainland France and overseas territories.

Please take a look to the [list of stations](https://www.data.gouv.fr/api/1/datasets/r/d82625f7-091c-40c5-a4e7-313a2ba5d3ef) and [metadata](https://www.data.gouv.fr/api/1/datasets/r/d129bc15-f72f-4825-a124-9c4b3747c156).

### Example
```r
# download SYNOP data for year 2020
synop2020 <- mfclim_synop(2020)
head(synop2020)
```

## License 
This package is released under the [GPL-3 License](https://www.gnu.org/licenses/gpl-3.0.html). 
