#' Get observations
#'
#' Get weather observations.
#'
#' For possible input parameters see `get_sources()`, `get_elements()`,
#' and `get_observations_timeseries()`.
#'
#' @param sources character: Source (station) ID, e.g. 'SN18700'.
#' @param reference_time character: Time range to get observations for, in
#'   ISO-8601 format.
#' @param elements character: Elements. See `get_elements()` for available values.
#' @param max_age character: The maximum observation age as an ISO-8601 period.
#' @param limit integer: The maximum number of observation times to be returned
#'   for each source/element combination
#' @param time_offsets character: The time offsets to get observations for,
#'   specified as ISO-8601 periods.
#' @param time_resolutions character: The time resolutions to get observations
#'   for, specified as ISO-8601 periods.
#' @param time_series_ids integer: The internal time series IDs to get
#'   observations for. Defaults to 0.
#' @param performance_categories character: The performance categories to get
#'   observations, e.g "A", "B" etc.
#' @param exposure_categories integer: The exposure categories to get
#'   observations for, e.g. 1, 2 etc.
#' @param qualities integer: The qualities to get observations for, e.g. 1, 2
#'   etc.
#' @param levels numeric: The sensor levels to get observations for, e.g. 0.1,
#'   2, 10, 20.
#' @param include_extra integer: If 1 extra data is returned.
#' @param fields character: Fields to return in the response.
#' @param version character: API version.
#' @param format character: Response format.
#' @param client list: List with client id and secret.
#' @param flatten logical: If TRUE the response is transformed to an unnested
#'   table.
#' @param return_response logical: If TRUE a list of class `frost_api` is
#'   returned, including the raw `httr2_response`.
#'
#' @return tibble or list
#' @export
#' @examples
#' \dontrun{
#' # Example query
#' df <- get_observations(
#'   sources = c("SN18700", "SN90450"),
#'   reference_time = "2010-04-01/2010-04-03",
#'   elements = c(
#'     "mean(air_temperature P1D)",
#'     "sum(precipitation_amount P1D)",
#'     "mean(wind_speed P1D)"
#'   )
#' )
#' }
get_observations <- function(sources,
                             reference_time,
                             elements,
                             max_age = NULL,
                             limit = NULL,
                             time_offsets = NULL,
                             time_resolutions = NULL,
                             time_series_ids = NULL,
                             performance_categories = NULL,
                             exposure_categories = NULL,
                             qualities = NULL,
                             levels = NULL,
                             include_extra = NULL,
                             fields = NULL,
                             version = "v0",
                             format = c("jsonld", "csv"),
                             client = get_api_client(),
                             flatten = TRUE,
                             return_response = FALSE) {

  # Match args
  version <- match.arg(version)
  format <- match.arg(format)

  # Create query
  req <- create_query(
    endpoint = "observations",
    sources = sources,
    reference_time = reference_time,
    elements = elements,
    max_age = max_age,
    limit = limit,
    time_offsets = time_offsets,
    time_resolutions = time_resolutions,
    time_series_ids = time_series_ids,
    performance_categories = performance_categories,
    exposure_categories = exposure_categories,
    qualities = qualities,
    levels = levels,
    include_extra = include_extra,
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


#' Get observations time series
#'
#' Get available time series for observations.
#'
#' Use the default query parameters to retrieve all time series.
#'
#' @inheritParams get_observations
#' @param level_types character: Sensor level types
#' @param level_units character: Sensor level units
#' @export
#' @examples
#' \dontrun{
#' df <- get_observations_ts()
#' }
get_observations_ts <-
  function(sources = NULL,
           reference_time = NULL,
           elements = NULL,
           time_offsets = NULL,
           time_resolutions = NULL,
           time_series_ids = NULL,
           performance_categories = NULL,
           exposure_categories = NULL,
           qualities = NULL,
           levels = NULL,
           level_types = NULL,
           level_units = NULL,
           include_extra = NULL,
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
      endpoint = "observations/availableTimeSeries",
      sources = sources,
      reference_time = reference_time,
      elements = elements,
      time_offsets = time_offsets,
      time_resolutions = time_resolutions,
      time_series_ids = time_series_ids,
      performance_categories = performance_categories,
      exposure_categories = exposure_categories,
      qualities = qualities,
      levels = levels,
      level_types = level_types,
      level_units = level_units,
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
