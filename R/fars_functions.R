# Define global variables to satisfy R CMD check
if(getRversion() >= "2.15.1")  utils::globalVariables(c("STATE", "MONTH", "year", "n"))
#' Read FARS data file
#'
#' Read in the desired data file from FARS.
#'
#' @param filename Path of the file you want to read in. Can be a csv or zipped csv.
#'
#' @returns A tibble containing your dataset.
#'
#' @section Errors:
#' This function will throw an error if:
#' \itemize{
#'  \item \code{filename} is not a valid path or does not exist.
#'  \item \code{filename} is not a valid input type.}
#'
#' @importFrom readr read_csv
#' @importFrom tibble as_tibble
fars_read <- function(filename) {
  if(!file.exists(filename)) {
    filename <- system.file("extdata", filename, package = "fars")

    if(filename == "" || !file.exists(filename)) {
      stop("file '", filename, "' does not exist")
    }
  }
  data <- suppressMessages({
    readr::read_csv(filename, progress = FALSE)
  })
  tibble::as_tibble(data)
}

#' Create uniform file directory names by year
#'
#' This function creates standardized file names based on year.
#'
#' @param year 4-digit number representing the year.
#'
#' @returns Character string of the form 'accident_[year]_csv.bz2'
#'
#' @section Errors:
#' This function will throw an error if input value cannot be converted to an integer year.
make_filename <- function(year) {
  year <- as.integer(year)
  sprintf("accident_%d.csv.bz2", year)
}

#' fars_read_years Generate tibbles for each year of data needed.
#'
#' @param years A vector of years for which data is desired.
#'
#' @returns A list of tibbles with the data for each of the years provided.
#'
#' @section Errors:
#' This function will throw an error if an unavailable or invalid year is encountered.
#'
#' @importFrom dplyr mutate
#' @importFrom magrittr '%>%'
#' @importFrom dplyr select
#'
#' @export
#'
#' @examples
#' #Basic usage:
#' fars_read_years(years = c(2013, 2014, 2015))
fars_read_years <- function(years) {
  lapply(years, function(year) {
    file <- make_filename(year)
    tryCatch({
      dat <- fars_read(file)
      dplyr::mutate(dat, year = year) %>%
        dplyr::select(MONTH, year)
    }, error = function(e) {
      warning("invalid year: ", year)
      return(NULL)
    })
  })
}

#' Generate a summary of the available data.
#'
#' @param years A vector of years for which data is desired.
#'
#' @returns A single tibble summarizing the available data for each of the months in the provided vector of years
#'
#' @section Errors:
#' This function will throw an error if an unavailable or invalid year is encountered.
#'
#' @importFrom dplyr bind_rows
#' @importFrom magrittr %>%
#' @importFrom dplyr group_by
#' @importFrom dplyr summarize
#' @importFrom dplyr n
#' @importFrom tidyr spread
#'
#' @export
#'
#' @examples
#' #Basic usage:
#' fars_summarize_years(years = c(2013, 2014, 2015))
fars_summarize_years <- function(years) {
  dat_list <- fars_read_years(years)
  dplyr::bind_rows(dat_list) %>%
    dplyr::group_by(year, MONTH) %>%
    dplyr::summarize(n = n()) %>%
    tidyr::spread(year, n)
}

#' Generate a map of fatalities for a given state and year.
#'
#' @param state.num A number corresponding with the desired state.
#' @param year A vector of years for which data is desired.
#'
#' @returns A map of fatalities for a given state and year.
#'
#' @section Errors:
#' \itemize{
#'  \item \code{state.num} is not a valid STATE number.
#'  \item \code{years} There are no fatalities in the given state and year.}
#'
#' @importFrom dplyr filter
#' @importFrom maps map
#' @importFrom graphics points
#'
#' @export
#'
#' @examples
#' #Basic usage:
#' fars_map_state(1, 2013)
fars_map_state <- function(state.num, year) {
  filename <- make_filename(year)
  data <- fars_read(filename)
  state.num <- as.integer(state.num)

  if(!(state.num %in% unique(data$STATE)))
    stop("invalid STATE number: ", state.num)
  data.sub <- dplyr::filter(data, STATE == state.num)
  if(nrow(data.sub) == 0L) {
    message("no accidents to plot")
    return(invisible(NULL))
  }
  is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
  is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
  with(data.sub, {
    maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
              xlim = range(LONGITUD, na.rm = TRUE))
    graphics::points(LONGITUD, LATITUDE, pch = 46)
  })
}
