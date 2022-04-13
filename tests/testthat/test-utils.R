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
