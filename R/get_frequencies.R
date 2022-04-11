#' Get rainfall
#'
#' Get rainfall IDF data.
#'
#' @inheritParams get_observations
#' @param location character: Geographic position from which to get IDF data, in the
#'   following format "POINT(<longitude degrees> <latitude degrees>)".
#' @param durations character: IDF duration(s), in minutes.
#' @param frequencies character: IDF frequencies, in years.
#' @param unit character: Unit of measure for the intensity, either 'mm' or 'lsha'.
#'
#' @return tibble or list
#' @export
#' @examples
#' df <- get_rainfall()
get_rainfall <- function(sources = NULL,
                         location = NULL,
                         durations = NULL,
                         frequencies = NULL,
                         unit = c("lsha", "mm"),
                         fields = NULL,
                         version = "v0",
                         format = c("jsonld", "csv"),
                         client = get_api_client(),
                         flatten = TRUE,
                         return_response = FALSE) {

  # Match args
  unit <- match.arg(unit)
  version <- match.arg(version)
  format <- match.arg(format)

  # Create query
  req <- create_query(
    endpoint = "frequencies/rainfall",
    sources = sources,
    location = location,
    frequencies = frequencies,
    unit = unit,
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
