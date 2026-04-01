with_mock_dir("station", {
  test_that("list stations", {
    stations <- mfclim_list_stations(
      token = "token",
      departement = "75",
      step = "1d"
    )

    expect_true(is.data.frame(stations))
  })
})


with_mock_dir("order", {
  test_that("order", {
    order <- mfclim_order(
      token = "token",
      station = "75114001",
      step = "1d",
      date_deb = "2020-01-01T00:00:00Z",
      date_fin = "2020-12-31T23:59:59Z"
    )
    expect_true(is.character(order))
  })
})


with_mock_dir("order", {
  test_that("order", {
    order <- mfclim_order(
      token = "token",
      station = "75114001",
      step = "1d",
      date_deb = "2020-01-01T00:00:00Z",
      date_fin = "2020-12-31T23:59:59Z"
    )
    expect_true(is.character(order))
  })
})
