#' Build CDC Vital Statistics Link Lookup Table
#'
#' Combines cleaned CDC vital statistics sections into a single lookup table
#' containing user guide and U.S. data download URLs for each section and year.
#'
#' @param datas A named list of cleaned tibbles, one per CDC data section,
#'   as returned by \code{\link{clean_all_sections}}.
#'
#' @return A tibble with one row per section/year combination containing:
#'   \describe{
#'     \item{section}{CDC data section name}
#'     \item{year}{Data year}
#'     \item{user_guide_url}{URL to the user guide PDF}
#'     \item{user_guide_size}{Raw file size string of the user guide}
#'     \item{us_data_url}{URL to the U.S. data zip file}
#'     \item{us_data_size}{Raw file size string of the U.S. data file}
#'     \item{user_guide_size_mb}{User guide file size in megabytes}
#'     \item{us_data_size_mb}{U.S. data file size in megabytes}
#'   }
#'   Rows where either \code{user_guide_url} or \code{us_data_url} is missing
#'   are dropped.
#'
#' @seealso \code{\link{scrape_all_sections}}, \code{\link{clean_all_sections}},
#'   \code{\link{build_cdc_lookup}}
#'
#' @export
build_link_lookup <- function(datas) {
    dplyr::bind_rows(datas) %>%
        dplyr::arrange(section, year) %>%
        dplyr::select(
            section,
            year,
            user_guide_url  = `User Guide_url`,
            user_guide_size = `User Guide_file_size`,
            us_data_url     = `U.S. Data_url`,
            us_data_size    = `U.S. Data_file_size`
        ) %>%
        dplyr::filter(!is.na(user_guide_url) & !is.na(us_data_url)) %>%
        dplyr::mutate(
            user_guide_size_mb = parse_file_size_mb(user_guide_size),
            us_data_size_mb    = parse_file_size_mb(us_data_size)
        )
}
