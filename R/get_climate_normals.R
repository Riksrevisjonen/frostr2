#' Get climate normals
#'
#' Get climate normals.
#'
#' @inheritParams get_observations
#' @param period character: The validity period, e.g. '1931/1960'.
#'
#' @export
#' @examples
#' \dontrun{
#' df <- get_climate_normals("SN100")
#' }
get_climate_normals <- function(sources,
                                elements = NULL,
                                period = NULL,
                                format = "jsonld",
                                version = "v0",
                                client = get_frost_client(),
                                auth_type = c("basic", "oauth"),
                                simplify = TRUE,
                                return_response = FALSE) {

  # Match args
  version <- match.arg(version)
  format <- match.arg(format)

  # Create query
  req <- create_query(
    endpoint = "climatenormals",
    client = client,
    auth_type = auth_type,
    sources = sources,
    elements = elements,
    period = period,
    version = version,
    format = format
  )

  # Send query
  resp <- send_query(req)

  # Parse response
  out <- parse_response(resp, simplify, return_response)

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
#' \dontrun{
#' df <- get_available_climate_normals()
#' }
get_available_climate_normals <-
  function(sources = NULL,
           elements = NULL,
           period = NULL,
           fields = NULL,
           format = "jsonld",
           version = "v0",
           client = get_frost_client(),
           auth_type = c("basic", "oauth"),
           simplify = TRUE,
           return_response = FALSE) {

    # Match args
    version <- match.arg(version)
    format <- match.arg(format)

    # Create query
    req <- create_query(
      endpoint = "climatenormals/available",
      client = client,
      auth_type = auth_type,
      sources = sources,
      elements = elements,
      period = period,
      fields = fields,
      version = version,
      format = format
    )

    # Send query
    resp <- send_query(req)

    # Parse response
    out <- parse_response(resp, simplify, return_response)

    return(out)
  }
