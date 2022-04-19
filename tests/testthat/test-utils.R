library(tibble)

test_that("collapse_to_string() works", {
  x <- collapse_to_string(c("A", "B", "C"))
  expect_identical(x, "A,B,C")
  x <- collapse_to_string(NULL)
  expect_true(is.null(x))
})

test_that("rename_cols() works", {
  df <- tibble(`@test` = 1, `test2` = 2)
  df <- rename_cols(df)
  expect_equal(names(df), c("test", "test2"))
  dl <- list(test = 1, data = data.frame(x = 1, x2 = 2))
  df <- as_tibble(dl)
  df$data <- rename_cols(df$data, prefix = 'data')
  expect_identical(names(df), c("test", "data"))
  expect_identical(names(df$data), c("data.x" , "data.x2"))
})

test_that("send_query() works", {
  # 200
  u <- request("http://httpbin.org/status/200")
  tmp <- bench::system_time(send_query(u, max_tries = 3, throttle_rate = 1))
  expect_lte(tmp[2], .5)
  # 400
  u <- request("http://httpbin.org/status/400")
  tmp <- bench::system_time(send_query(u, max_tries = 3, throttle_rate = 1))
  expect_lte(tmp[2], .5)
  # 429 (should retry)
  u <- request("http://httpbin.org/status/429")
  tmp <- bench::system_time(send_query(u, max_tries = 1, throttle_rate = 1))
  expect_lte(tmp[2], .5)
  tmp <- bench::system_time(send_query(u, max_tries = 3, throttle_rate = 1))
  expect_gte(tmp[2], 3)
    # 503 (should retry)
  u <- request("http://httpbin.org/status/503")
  tmp <- bench::system_time(send_query(u, max_tries = 1, throttle_rate = 1))
  expect_lte(tmp[2], .5)
  tmp <- bench::system_time(send_query(u, max_tries = 3, throttle_rate = 1))
  expect_gte(tmp[2], 3)

  # TO DO: Test throttle rate

})
