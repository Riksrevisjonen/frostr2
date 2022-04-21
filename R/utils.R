#' @import httr2
NULL

#' send_query
#' @param req A httr2 request
#' @param max_tries Maximum number of retries
#' @param throttle_rate Max number of requests per second
#' @noRd
send_query <- function(req, max_tries = 3, throttle_rate = 1) {
  resp <- req %>%
    req_user_agent(user_agent) %>%
    req_headers("Accept-Encoding" = "gzip") %>%
    req_retry(
      is_transient = ~ resp_status(.x) %in% c(429, 503), # include 500 ?
      max_tries = max_tries,
      # max_seconds = 10,
      # backoff = ~ 2
    ) %>%
    req_throttle(rate = throttle_rate) %>% #
    req_error(is_error = function(resp) FALSE) %>%
    req_perform()
  resp
}

#' parse_response
#' @param resp A httr2 response
#' @inheritParams get_observations
#' @noRd
parse_response <- function(resp, simplify, return_response) {

  # Special parser if the response failed
  resp_error <- resp_is_error(resp)
  if (resp_error) {
    if (resp$status_code %in% c(414, 503)) {
      parsed <- rawToChar(resp$body)
    } else {
      parsed <- jsonlite::fromJSON(rawToChar(resp$body))$error$reason
    }
  } else {
    # Parse response based on content type
    type <- resp_content_type(resp)
    if (type == "application/json") {
      parsed <- resp_body_json(resp, simplifyVector = TRUE)
    } else if (format == "text/plain") {
      parsed <- suppressMessages(
        readr::read_csv(rawToChar(resp_body_raw(resp)))
      )
    }
    # Convert to a single (unnested) tibble
    if (simplify) parsed <- simplify_response(parsed)
  }

  if (!return_response) {
    msg <- sprintf("The API returned an error (%s):\n* %s", resp$status_code, parsed)
    attempt::stop_if(resp_error, msg = msg)
    return(parsed)
  } else {
    structure(
      list(
        url = resp$url,
        status = resp$status_code,
        content = parsed,
        response = resp
      ),
      class = "frost_api"
    )
  }
}

#' flatten_response
#' @param df A data.frame
#' @noRd
flatten_response <- function(df) {

  # Convert to nested tibble
  df <- tibble::as_tibble(df)

  # Rename and unnest
  # df <- rename_cols(df)
  if ("data" %in% names(df)) {
    df$data <- rename_cols(df$data, "data")
    df <- tidyr::unnest(df, cols = "data")
  }
  if ("data.observations" %in% names(df)) {
    df$data.observations <- lapply(df$data.observations, function(x) {
      rename_cols(x, "data.observations")
    })
    df <- tidyr::unnest(df, cols = "data.observations")
  }
  if ("data.observations.level" %in% names(df)) {
    df$data.observations.level <- rename_cols(
      df$data.observations.level, "data.observations.level")
    df <- tidyr::unnest(df, cols = "data.observations.level")
  }
  if ("data.values" %in% names(df)) {
    df$data.values <- lapply(df$data.values, function(x) {
      rename_cols(x, "data.values")
    })
    df <- tidyr::unnest(df, cols = "data.values")
  }
  if (any(grepl("data.geometry", names(df)))) {
    df$data.geometry <- rename_cols(df$data.geometry, "data.geometry")
    df <- tidyr::unnest(df, cols = "data.geometry")
  }
  if (any(grepl("data.calculationMethod", names(df)))) {
    df$data.calculationMethod <- rename_cols(df$data.calculationMethod, "data.calculationMethod")
    df <- tidyr::unnest(df, cols = "data.calculationMethod")
  }
  if (any(grepl("data.cfConvention", names(df)))) {
    df$data.cfConvention <- rename_cols(df$data.oldConvention, "data.cfConvention")
    df <- tidyr::unnest(df, cols = "data.cfConvention")
  }
  if (any(grepl("data.oldConvention", names(df)))) {
    df$data.oldConvention <- rename_cols(df$data.oldConvention, "data.oldConvention")
    df <- tidyr::unnest(df, cols = "data.oldConvention")
  }
  if (any(grepl("data.timeOffsets", names(df)))) {
    df$data.timeOffsets <- rename_cols(df$data.timeOffsets, "data.timeOffsets")
    df <- tidyr::unnest(df, cols = "data.timeOffsets")
  }
  if (any(grepl("data.sensorLevels", names(df)))) {
    df$data.sensorLevels <- rename_cols(df$data.sensorLevels, "data.sensorLevels")
    df <- tidyr::unnest(df, cols = "data.sensorLevels")
  }

  return(df)
}

#' simplify_response
#' @param parsed Parsed response
#' @noRd
simplify_response <- function(parsed) {
  df <- flatten_response(parsed)
  df <- df[grepl('data', names(df))]
  df <- clean_names(df)
  df
}

#' rename_cols
#' @param df A data.frame
#' @param prefix A prefix for the columns to rename. Optional
#' @noRd
rename_cols <- function(df, prefix = NULL) {
  if (!is.null(prefix)) {
    names(df) <- paste0(prefix, ".", names(df))
  }
  df
}
#' rename_cols
#' @param df A data.frame
#' @noRd
clean_names <- function(df) {
  names(df) <- sub("[@]", "", names(df))
  names(df) <- sub("^data[.]", "", names(df))
  names(df) <- sub("^observations[.]", "", names(df))
  names(df) <- sub("level[.]levelType", "levelType", names(df))
  names(df) <- snakecase::to_snake_case(names(df))
  df
}

#' collapse_to_string
#' @param x A vector
#' @noRd
collapse_to_string <- function(x){
  if (!is.null(x)) {
    x <- paste0(x, collapse = ",")
  }
  x
}

#' frost_api print method
#' @importFrom utils str
#' @noRd
print.frost_api <- function(x, ...) {
  cat("<FROST API ", x$url, ">\n", sep = "")
  str(x$content)
  invisible(x)
}
