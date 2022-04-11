#' @import httr2
NULL

#' get_api_client
#' @noRd
get_api_client <- function() {
  id <- Sys.getenv("MET_FROST_ID")
  # secret <- Sys.getenv("MET_FROST_SECRET")
  if (identical(id, "")) {
    stop("No client id found, please supply with `client` argument or with MET_FROST_ID env var")
  }
  # if (identical(secret, "")) {
  #   stop("No client secret found, please supply with `client` argument or with MET_FROST_SECRET env var")
  # }
  # list(id = id, secrect = secret)
  list(id = id)
}

#' send_query
#' @param req A httr2 request
#' @noRd
send_query <- function(req) {
  resp <- req %>%
    req_user_agent(user_agent) %>%
    req_retry(
      is_transient = ~ resp_status(.x) %in% c(429, 503), # include 500 ?
      max_tries = 3,
      # max_seconds = 10,
      # backoff = ~ 2
    ) %>%
    req_error(is_error = function(resp) FALSE) %>%
    req_perform()
  resp
}

#' parse_response
#' @param resp A httr2 response
#' @inheritParams get_observations
#' @noRd
parse_response <- function(resp, flatten, return_response) {

  # Special parser if the response failed
  resp_error <- resp_is_error(resp)
  if (resp_error) {
    if (resp$status_code == 414) {
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
    if (flatten) parsed <- flatten_response(parsed)
  }

  if (!return_response) {
    msg <- sprintf("The API returned an error (%s):\n *%s", resp$status_code, parsed)
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
#' @param parsed Parsed response
#' @noRd
flatten_response <- function(parsed) {

  # Convert to nested tibble
  df <- tibble::as_tibble(parsed)

  # Rename and unnest
  df <- rename_cols(df)
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

  # Select data columns
  df <- df[grepl('data', names(df))]

  return(df)
}

#' rename_cols
#' @param df A data.frame
#' @param prefix A prefix for the columns to rename. Optional
#' @noRd
rename_cols <- function(df, prefix = NULL) {
  names(df) <- gsub("[@]", "", names(df))
  if (!is.null(prefix)) {
    names(df) <- paste0(prefix, ".", names(df))
  }
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