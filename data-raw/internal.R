
base_url <- "https://frost.met.no"
user_agent <- "frostr2 (http://my.package.web.site)"

usethis::use_data(base_url,
                  user_agent,
                  internal = TRUE,
                  overwrite = TRUE)
