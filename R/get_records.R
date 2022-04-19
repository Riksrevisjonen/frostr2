#' Get county extremes
#'
#' Use the default query parameters to retrieve all values.
#'
#' @inheritParams get_observations
#' @param sourcenames character: Source names.
#' @param months character: Months to get records for as integers or integer
#'   ranges between 1 and 12, e.g. '1,5,8-12'.
#' @param counties character: Counties
#' @param municipalities character: Municipalities
#'
#' @return tibble or list
#' @export
#'
#' @examples
#' \dontrun{
#' # Get all sources
#' df <- get_county_extremes()
#' }
get_county_extremes <- function(sources = NULL,
                                sourcenames = NULL,
                                counties = NULL,
                                municipalities = NULL,
                                elements = NULL,
                                months = NULL,
                                fields = NULL,
                                version = "v0",
                                format = "jsonld",
                                client = get_frost_client(),
                                auth_type = c("basic", "oauth"),
                                flatten = TRUE,
                                return_response = FALSE
                                ) {


  # Match args
  version <- match.arg(version)
  format <- match.arg(format)

  # Create query
  req <- create_query(
    endpoint = "records/countyExtremes",
    client = client,
    auth_type = auth_type,
    version = version,
    format = format,
    sources = sources,
    sourcenames = sourcenames,
    counties = counties,
    municipalities = municipalities,
    elements = elements,
    months = months,
    fields = fields
  )

  # Send query
  resp <- send_query(req)

  # Parse response
  out <- parse_response(resp, flatten, return_response)

  return(out)


}
