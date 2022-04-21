#' Get sources
#'
#' Get metadata for the source entities.
#'
#' Use the default query parameters to retrieve all sources.
#'
#' @param ids character: Source ID(s).
#' @param types character: Source type. Either "SensorSystem",
#'   "InterpolatedDataset", or "RegionDataset".
#' @param geometry character: Sources defined by a specified geometry.
#'   Geometries are specified as either nearest(POINT(...)) or POLYGON(...)
#'   using well-known text representation for geometry (WKT).
#' @param nearest_max_count character: A string with the maximum number of
#'   sources returned when using "nearest(POINT(...))" for `geometry`. Defaults
#'   to 1.
#' @param valid_time character: If specified, only sources that have been, or
#'   still are, valid/applicable during some part of this interval may be
#'   included in the result.pecify <date>/<date>, <date>/now, <date>, or now,
#'   where <date> is of the form YYYY-MM-DD, e.g. 2017-03-06. The default is
#'   'now', i.e. only currently valid/applicable sources are included.
#' @param name character: If specified, only sources whose 'name' attribute
#'   matches the search filter be included in the result.
#' @param country character: Country. If specified, only sources whose 'country'
#'   or 'countryCode' attribute matches the search filter may be included in the
#'   result.
#' @param county character: County. If specified, only sources whose 'county' or
#'   'countyId' attribute matches the search filter may be included in the
#'   result.
#' @param municipality character: Municipality. If specified, only sources whose
#'   'municipality' or 'municipalityId' attribute matches the search filter may
#'   be included in the result.
#' @param wmo_id character: WMO ID. If specified, only sources whose 'wmoId'
#'   attribute matches the search filter  may be included in the result.
#' @param station_holder character: Station holder. If specified, only sources
#'   whose 'stationHolders' attribute contains at least one name that matches
#'   the search filter may be included in the result.
#' @param external_ids character: External id. If specified, only sources whose
#'   'externalIds' attribute contains at least one value that matches any of the
#'   specified, comma-separated list of search filters may be included in the
#'   result.
#' @param icao_code character: ICAO code.
#' @param ship_code character: Ship code. If specified, only sources whose
#'   'shipCodes' attribute contains at least one name that matches this search
#'   filter may be included in the result.
#' @param wigos_id character: WIGOS ID. If specified, only sources whose
#'   'wigosId' attribute matches the search filter may be included in the
#'   result.
#' @inheritParams get_observations
#'
#' @return tibble or list
#' @export
#'
#' @examples
#' \dontrun{
#' # Get all sources
#' df <- get_sources()
#' }
get_sources <- function(ids = NULL,
                        types = NULL,
                        elements = NULL,
                        geometry = NULL,
                        nearest_max_count = NULL,
                        valid_time = NULL,
                        name = NULL,
                        country = NULL,
                        county = NULL,
                        municipality = NULL,
                        wmo_id = NULL,
                        station_holder = NULL,
                        external_ids = NULL,
                        icao_code = NULL,
                        ship_code = NULL,
                        wigos_id = NULL,
                        fields = NULL,
                        version = "v0",
                        format = c("jsonld", "csv"),
                        client = get_frost_client(),
                        auth_type = c("basic", "oauth"),
                        simplify = TRUE,
                        return_response = FALSE) {

  if (!is.null(types))
    match.arg(types,  c("SensorSystem", "InterpolatedDataset", "RegionDataset"))
  version <- match.arg(version)
  format <- match.arg(format)

  # Create query
  req <- create_query(
    endpoint <- "sources",
    client = client,
    auth_type = auth_type,
    version = version,
    format = format,
    ids = ids,
    types = types,
    elements = elements,
    geometry = geometry,
    nearest_max_count = nearest_max_count,
    valid_time = valid_time,
    name = name,
    country = country,
    county = county,
    municipality = municipality,
    wmo_id = wmo_id,
    station_holder = station_holder,
    external_ids = external_ids,
    icao_code = icao_code,
    ship_code = ship_code,
    wigos_id = wigos_id,
    fields = fields
  )

  # Send query
  resp <- send_query(req)

  # Parse response
  out <- parse_response(resp, simplify, return_response)

  return(out)
}
