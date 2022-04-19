#' Get elements
#'
#' Get metadata about the weather and climate elements.
#'
#' Use the default query parameters to retrieve all elements.
#'
#' @inheritParams get_sources
#' @inheritParams get_locations
#' @inheritParams get_observations
#' @param categories character: Categories
#' @param descriptions character: Descriptions
#' @param statuses character: Statuses
#' @param code_tables character: Code tables
#' @param cf_standard_names character: CF standard names
#' @param cf_cell_methods character: CF cell methods
#' @param cf_units character: CF units
#' @param cf_versions character: CF versions
#' @param sensor_levels character: Sensor levels
#' @param calculation_method character: Calculation method
#' @param units character: Units
#' @param lang character: ISO language/locale to be used for search filters and
#'   return values
#' @return tibble or list
#' @export
#' @examples
#' \dontrun{
#' # Get all elements
#' df <- get_elements()
#' }
get_elements <- function(ids = NULL,
                         names = NULL,
                         descriptions = NULL,
                         units = NULL,
                         code_tables = NULL,
                         statuses = NULL,
                         calculation_method = NULL,
                         categories = NULL,
                         time_offsets = NULL,
                         sensor_levels = NULL,
                         cf_standard_names = NULL,
                         cf_cell_methods = NULL,
                         cf_units = NULL,
                         cf_versions = NULL,
                         fields = NULL,
                         lang = c("en-US", "nb-NO", "nn-NO"),
                         version = "v0",
                         format = c("jsonld"),
                         client = get_frost_client(),
                         auth_type = c("basic", "oauth"),
                         flatten = TRUE,
                         return_response = FALSE) {

  # Match args
  lang <- match.arg(lang)
  version <- match.arg(version)
  format <- match.arg(format)

  # Create query
  req <- create_query(
    endpoint = "elements",
    ids = ids,
    names = names,
    descriptions = descriptions,
    units = units,
    code_tables = code_tables,
    statuses = statuses,
    calculation_method = calculation_method,
    categories = categories,
    time_offsets = time_offsets,
    sensor_levels = sensor_levels,
    cf_standard_names = cf_standard_names,
    cf_cell_methods = cf_cell_methods,
    cf_units = cf_units,
    cf_versions = cf_versions,
    lang = lang,
    fields = fields,
    client = client,
    auth_type = auth_type,
    version = version,
    format = format
  )

  # Send query
  resp <- send_query(req)
  if (return_response) {
    return(resp)
  }

  # Parse response
  out <- parse_response(resp, flatten, return_response)

  return(out)
}


#' Get code tables
#'
#' Get metadata about the code tables.
#'
#' Use the default query parameters to retrieve all code tables.
#'
#' @inheritParams get_elements
#' @inheritParams get_observations
#' @export
#' @examples
#' \dontrun{
#' # Get all code tables
#' df <- get_code_tables()
#' }
get_code_tables <- function(ids = NULL,
                            fields = NULL,
                            lang = c("en-US", "nb-NO", "nn-NO"),
                            version = "v0",
                            format = "jsonld",
                            client = get_frost_client(),
                            auth_type = c("basic", "oauth"),
                            flatten = TRUE,
                            return_response = FALSE) {

  # Match args
  lang <- match.arg(lang)
  version <- match.arg(version)
  format <- match.arg(format)

  # Create query
  req <- create_query(
    endpoint = "elements/codeTables",
    client = client,
    auth_type = auth_type,
    ids = ids,
    lang = lang,
    fields = fields,
    version = version,
    format = format
  )

  # Send query
  resp <- send_query(req)

  # Parse response
  out <- parse_response(resp, flatten, return_response)

  return(out)
}
