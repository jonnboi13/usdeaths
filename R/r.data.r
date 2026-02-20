#' CDC Vital Statistics Link Lookup Table
#'
#' A lookup table of download URLs for CDC vital statistics data files,
#' scraped from the CDC Vital Statistics Online page.
#'
#' @format A tibble with 219 rows and 8 columns:
#' \describe{
#'   \item{section}{CDC data section name}
#'   \item{year}{Data year}
#'   \item{user_guide_url}{URL to the user guide PDF}
#'   \item{user_guide_size}{Raw file size string of the user guide}
#'   \item{us_data_url}{URL to the U.S. data zip file}
#'   \item{us_data_size}{Raw file size string of the U.S. data file}
#'   \item{user_guide_size_mb}{User guide file size in megabytes}
#'   \item{us_data_size_mb}{U.S. data file size in megabytes}
#' }
#' @source \url{https://www.cdc.gov/nchs/data_access/VitalStatsOnline.htm}
"cdc_link_lookup"
