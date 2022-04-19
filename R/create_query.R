#' Create query
#' @param endpoint Endpoint
#' @inheritParams get_observations
#' @inheritParams get_sources
#' @inheritParams get_elements
#' @inheritParams get_rainfall
#' @inheritParams get_locations
#' @inheritParams get_climate_normals
#' @inheritParams get_observations_ts
#' @return httr2_request
#' @keywords internal
create_query <-
  function(endpoint,
           client,
           format,
           version,
           auth_type,
           calculation_method = NULL,
           categories = NULL,
           cf_standard_names = NULL,
           cf_cell_methods = NULL,
           cf_units = NULL,
           cf_versions = NULL,
           code_tables = NULL,
           country = NULL,
           county = NULL,
           counties = NULL,
           descriptions = NULL,
           durations = NULL,
           elements = NULL,
           exposure_categories = NULL,
           external_ids = NULL,
           fields = NULL,
           frequencies = NULL,
           geometry = NULL,
           ids = NULL,
           icao_code = NULL,
           include_extra = NULL,
           lang = NULL,
           levels = NULL,
           level_units = NULL,
           level_types = NULL,
           limit = NULL,
           location = NULL,
           max_age = NULL,
           months = NULL,
           municipality = NULL,
           municipalities = NULL,
           name = NULL,
           names = NULL,
           nearest_max_count = NULL,
           period = NULL,
           performance_categories = NULL,
           qualities = NULL,
           reference_time = NULL,
           sensor_levels = NULL,
           ship_code = NULL,
           sources = NULL,
           sourcenames = NULL,
           station_holder = NULL,
           statuses = NULL,
           time_offsets = NULL,
           time_resolutions = NULL,
           time_series_ids = NULL,
           types = NULL,
           unit = NULL,
           units = NULL,
           valid_time = NULL,
           wigos_id = NULL,
           wmo_id = NULL) {

    # Collapse selected parameters to a single string
    cp <- list(
      categories = categories,
      cf_standard_names = cf_standard_names,
      cf_cell_methods = cf_cell_methods,
      cf_units = cf_units,
      cf_versions = cf_versions,
      code_tables = code_tables,
      counties = counties,
      descriptions = descriptions,
      durations = durations,
      elements = elements,
      exposure_categories = exposure_categories,
      fields = fields,
      frequencies = frequencies,
      levels = levels,
      level_types = level_types,
      level_units = level_units,
      months = months,
      municipalities = municipalities,
      names = names,
      period = period,
      performance_categories = performance_categories,
      qualities = qualities,
      sources = sources,
      sourcenames = sourcenames,
      statuses = statuses,
      time_offsets = time_offsets,
      time_resolutions = time_resolutions,
      time_series_ids = time_series_ids,
      unit = unit,
      units = units
    )
    cp <- lapply(cp, collapse_to_string)

    # Create query parameters
    params <- list(
      calculationMethod = calculation_method,
      categories = cp$categories,
      cfStandardNames = cp$cf_standard_names,
      cfCellMethods = cp$cf_cell_methods,
      cfUnits = cp$cf_units,
      cfVersions = cp$cf_versions,
      codeTables = cp$code_tables,
      country = country,
      county = county,
      counties = cp$counties,
      descriptions = cp$descriptions,
      durations = cp$durations,
      elements = cp$elements,
      exposurecategories = cp$exposure_categories,
      externalids = external_ids,
      fields = cp$fields,
      frequencies = cp$frequencies,
      geometry = geometry,
      ids = ids,
      icaocode = icao_code,
      includeextra = include_extra,
      lang = lang,
      levels = cp$levels,
      level_types = cp$level_types,
      level_units = cp$level_units,
      limit = limit,
      location = location,
      maxage = max_age,
      months = cp$months,
      municipality = municipality,
      municipalities = cp$municipalities,
      name = name,
      names = cp$names,
      nearestmaxcount = nearest_max_count,
      performancecategories = cp$performance_categories,
      qualities = cp$qualities,
      referencetime = reference_time,
      sources = cp$sources,
      sourcenames = cp$sourcenames,
      shipcode = ship_code,
      stationholder = station_holder,
      timeoffsets = cp$time_offsets,
      timeresolutions = cp$time_resolutions,
      timeseriesids = cp$time_series_ids,
      types = types,
      unit = cp$unit,
      units = cp$units,
      validtime = valid_time,
      wigosid = wigos_id,
      wmoid = wmo_id
    )

    # Create query
    req <- request(base_url) %>%
      auth(client, auth_type) %>%
      req_url_path_append(endpoint) %>%
      req_url_path_append(paste0(version, ".", format)) %>%
      req_url_query(!!!params)

    return(req)
  }
