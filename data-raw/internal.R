
base_url <- "https://frost.met.no"
user_agent <- "frostr2 (riksrevisjonen.github.io/frostr2)"

usethis::use_data(base_url,
                  user_agent,
                  internal = TRUE,
                  overwrite = TRUE)
