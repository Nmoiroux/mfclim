library(httptest)

set_requester(function (request) {
  gsub_request(request, "https\\://public-api.meteofrance.fr/public/DPClim/v1", "api/")
})
