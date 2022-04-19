#' Authentication method
#'
#' Select authentication method.
#'
#' @param req A httr2 request
#' @inheritParams get_observations
#' @keywords internal
auth <- function(req, client, auth_type = c("basic", "oauth")) {
  auth_type <- match.arg(auth_type)
  if (auth_type == "basic") {
    req %>%
      req_auth_basic(
        username = client$id,
        password = "")
  } else {
    token <- create_token(client = client)
    req %>%
      req_auth_bearer_token(token$access_token)
  }
}

#' Create token
#'
#' Create a FROST API token.
#'
#' @inheritParams get_observations
#' @return list
#' @keywords internal
#' @examples
#' \dontrun{
#' # Generate token
#' create_token()
#' }
create_token <- function(client, return_response = FALSE) {

  q <- sprintf(
    "client_id=%s&client_secret=%s&grant_type=client_credentials",
    client$id, client$secrect)

  req <- request(base_url) %>%
    req_url_path_append("auth/accessToken") %>%
    req_body_raw(q, type = "application/x-www-form-urlencoded")

  send_query(req) %>%
    parse_response(flatten = FALSE, return_response)

}

#' Get Frost API Client
#'
#' Get Frost API client info from R environment variables.
#'
#' @export
#' @examples
#' \dontrun{
#' get_frost_client()
#' }
get_frost_client <- function() {
  id <- Sys.getenv("MET_FROST_ID")
  secret <- Sys.getenv("MET_FROST_SECRET")
  if (identical(id, "")) {
    stop("No client id found, please supply with `client` argument or with MET_FROST_ID env var")
  }
  if (identical(secret, "")) {
    stop("No client secret found, please supply with `client` argument or with MET_FROST_SECRET env var")
  }
  return(list(id = id, secrect = secret))

  if (is_testing()) {
    return(testing_key())
  } else {
    stop("No key found. Check your .Renviron")
  }
}

#' Set Frost API Client
#'
#' Helper function to set the correct environmental variables to work with
#' `{frostr2}`.
#'
#' In order to generate your credentials you will need to register a user with
#' the [FROST API service](https://frost.met.no/index.html).
#'
#' You can use these credentials to store a set of environmental variables
#' (MET_FROST_ID and MET_FROST_SECRET) that will be automatically picked up by
#' `{frostr2}`.
#'
#' The environmental variables can be set at either a session, project or user
#' level. Must users will typically benefit from setting environmental variables
#' at the user level. Please note that specifying a `scope` of "project" or
#' "user" will modify your relevant .Renviron file, so be mindful when you do
#' this.
#'
#' @param id character: Client id
#' @param secret character: Client secret
#' @param scope character: Scope for environmental variables. See details.
#' @export
#' @examples
#' \dontrun{
#' # Set client for this user session
#' set_frost_client()
#'
#' # Edit .Renviron for current working directory
#' set_frost_client(scope = "project")
#'
#' # Edit user .Renviron
#' set_frost_client(scope = "user")
#' }
set_frost_client <- function(id = NULL, secret = NULL,
                             scope = c("session", "project", "user")) {
  scope <- match.arg(scope)

  # Ask for user input
  if (is.null(id)) {
    id <- askpass::askpass("Please enter your client id")
  }
  if (is.null(secret)) {
    secret <- askpass::askpass("Please enter your client secret")
  }

  # Edit env variables
  if (scope == "session") {
    Sys.setenv("MET_FROST_ID" = id)
    Sys.setenv("MET_FROST_SECRET" = secret)
  } else {
    if (scope == "project")  f <- ".Renviron"
    if (scope == "user")  f <- sprintf("%s/.Renviron", Sys.getenv("R_USER")) # "~/.Renviron"
    if (file.exists(f)) {
      current <- readLines(f)
    } else {
      file.create(f)
    }
    if (!any(grepl("MET_FROST_ID|MET_FROST_SECRET", current))){
      txt1 <- sprintf("MET_FROST_ID = '%s'", id)
      txt2 <- sprintf("MET_FROST_SECRET = '%s'", secret)
      writeLines(c(txt1, txt2), f)
      message("The MET FROST API enviromental variables have been set. Restart R for the changes to take effect.")
    } else {
      stop("Looks like your MET FROST API environment variables are already defined. Check your .Renviron.",
           call. = FALSE)
    }
  }
}

#' is_testing
#' @noRd
is_testing <- function() {
  identical(Sys.getenv("TESTTHAT"), "true")
}

#' testing_key
#' @noRd
testing_key <- function() {
  list(
    id = secret_decrypt("VLAE_MPyNN646r6nXqpwj5Z8SF-ED4y64BOk3cI-NIZGAHCDQ7abvt3xe2-7wq3yhe-8ng",
                        "FROSTR2_KEY"),
    secret = secret_decrypt("BKLCSNzUFjIHdmkkSZsu1faLcUjvd86ZmgVNbyLkqUYE2JjgJNJNR2wqWXvCpIvSi9SEeA",
                            "FROSTR2_KEY")
  )
}

