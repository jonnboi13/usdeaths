#' Build CDC Vital Statistics Link Lookup Table
#'
#' Convenience wrapper that runs the full pipeline: scrapes all CDC vital
#' statistics sections, applies section-specific cleaning, and returns a
#' combined lookup table of user guide and U.S. data download URLs.
#'
#' @param url URL to the CDC Vital Statistics Online page. Defaults to the
#'   current CDC page.
#' @param url_pdf URL to the CDC mortality public use data page, used to scrape
#'   mortality user guide links separately. Defaults to the current CDC page.
#' @param save Logical. If \code{TRUE}, saves the lookup table to \code{path}
#'   as an \code{.rda} file. Defaults to \code{FALSE}.
#' @param path File path to save the lookup table to. Only used if
#'   \code{save = TRUE}. Defaults to \code{"data/lookup_final.rda"}.
#'
#' @return A tibble with 219 rows and 8 columns. See \code{\link{build_link_lookup}}
#'   for full column descriptions.
#'
#' @seealso \code{\link{scrape_all_sections}}, \code{\link{clean_all_sections}},
#'   \code{\link{build_link_lookup}}
#'
#' @export
build_cdc_lookup <- function(url = "https://www.cdc.gov/nchs/data_access/VitalStatsOnline.htm",
                             url_pdf = "https://www.cdc.gov/nchs/nvss/mortality_public_use_data.htm",
                             save = FALSE,
                             path = "data/lookup_final.rda") {
    datas <- scrape_all_sections(url)
    datas <- clean_all_sections(datas, url_pdf)
    lookup_final <- build_link_lookup(datas)

    if (save) save(lookup_final, file = path)

    lookup_final
}
