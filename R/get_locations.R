#' Get locations
#'
#' Get metadata for location names.
#'
#' Use the default query parameters to retrieve all location names.
#'
#' @param names character: Location name(s)
#' @inheritParams get_sources
#' @inheritParams get_observations
get_locations <- function(names = NULL,
                          geometry = NULL,
                          fields = NULL,
                          version = "v0",
                          format = "jsonld",
                          client = get_api_client(),
                          flatten = TRUE,
                          return_response = FALSE) {

  # Match args
  version <- match.arg(version)
  format <- match.arg(format)

  # Create query
  req <- create_query(
    endpoint <- "locations",
    client = client,
    version = version,
    format = format,
    names = names,
    fields = fields,
    geometry = geometry
  )

  # Send query
  resp <- send_query(req)

  # Parse response
  out <- parse_response(resp, flatten, return_response)

  return(out)
}
