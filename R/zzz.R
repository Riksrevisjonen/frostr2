.onLoad <- function(libname, pkgname) {
  if (!Sys.getenv("FROSTR2_DISABLE_CACHING") == "TRUE") {
    cm <- cachem::cache_mem(max_size = 512 * 1024^2, evict = "lru")
    get_observations <<- memoise::memoise(get_observations, cache = cm)
    get_rainfall <<- memoise::memoise(get_rainfall, cache = cm)
    get_climate_normals <<- memoise::memoise(get_climate_normals, cache = cm)
    get_sources <<- memoise::memoise(get_sources, cache = cm)
    get_locations <<- memoise::memoise(get_locations, cache = cm)
    get_elements <<- memoise::memoise(get_elements, cache = cm)
    get_code_tables <<- memoise::memoise(get_code_tables, cache = cm)
    get_observations_ts <<-
      memoise::memoise(get_observations_ts, cache = cm)
    get_available_climate_normals <<-
      memoise::memoise(get_climate_normals, cache = cm)

  }
}

.onAttach <- function(libname, pkgname) {
  if (!Sys.getenv("FROSTR2_DISABLE_CACHING") == "TRUE") {
    packageStartupMessage("Info: Session based caching is enabled.")
  }
}
