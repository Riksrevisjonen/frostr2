#' Get climate normals
#'
#' Get climate normals.
#'
#' @inheritParams get_observations
#' @param period character: The validity period, e.g. '1931/1960'.
#'
#' @export
#' @examples
#' df <- get_climate_normals("SN100")
get_climate_normals <- function(sources,
                                elements = NULL,
                                period = NULL,
                                format = "jsonld",
                                version = "v0",
                                client = get_api_client(),
                                flatten = TRUE,
                                return_response = FALSE) {

  # Match args
  version <- match.arg(version)
  format <- match.arg(format)

  # Create query
  req <- create_query(
    endpoint = "climatenormals",
    sources = sources,
    elements = elements,
    period = period,
    client = client,
    version = version,
    format = format
  )

  # Send query
  resp <- send_query(req)

  # Parse response
  out <- parse_response(resp, flatten, return_response)

  return(out)
}


#' Get available climate normals
#'
#' Get available combinations of sources, elements, and periods for climate normals.
#'
#' @inheritParams get_observations
#' @inheritParams get_climate_normals
#' @export
#' @examples
#' df <- get_available_climate_normals()
get_available_climate_normals <-
  function(sources = NULL,
           elements = NULL,
           period = NULL,
           fields = NULL,
           format = "jsonld",
           version = "v0",
           client = get_api_client(),
           flatten = TRUE,
           return_response = FALSE) {

    # Match args
    version <- match.arg(version)
    format <- match.arg(format)

    # Create query
    req <- create_query(
      endpoint = "climatenormals/available",
      sources = sources,
      elements = elements,
      period = period,
      fields = fields,
      client = client,
      version = version,
      format = format
    )

    # Send query
    resp <- send_query(req)

    # Parse response
    out <- parse_response(resp, flatten, return_response)

    return(out)
  }
