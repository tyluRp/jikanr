#' @title Anime of the specified day
#'
#' @description Anime schedule of the week or specified day. Note: If you don't pass the day parameter, it'll return the schedule for all days of the week.
#'
#' @param day Monday through Friday. Defaults to NULL and returns a little of all days.
#'
#' @examples
#' schedule("monday")
#'
#' @export
schedule <- function(day=NULL) {

  url_string <- paste("https://api.jikan.moe/v3/schedule", day, sep = "/")
  response <- httr::GET(url_string)
  dat <- jsonlite::fromJSON(httr::content(response, type = "text", encoding = "UTF-8"), simplifyDataFrame = TRUE)

  if (is.null(day)) {
    dat <- list(
      monday = dat$monday,
      tuesday = dat$tuesday,
      wednesday = dat$wednesday,
      thursday = dat$thursday,
      friday = dat$friday,
      saturday = dat$saturday,
      other = dat$other,
      unknown = dat$unknown
    )

    dat <- lapply(dat, tibble::as_tibble)
    dat <- lapply(dat, readr::type_convert)
  } else {
    dat <- dat[[day]]

    dat <- tibble::as_tibble(dat)
    dat <- readr::type_convert(dat)
  }

  return(dat)
}

