#' Clean and Reshape All CDC Vital Statistics Sections
#'
#' Applies section-specific cleaning and reshaping to each element of the raw
#' scraped data list. Each section has unique quirks that require custom handling
#' before the data can be combined into a lookup table.
#'
#' @param datas A named list of raw tibbles as returned by
#'   \code{\link{scrape_all_sections}}.
#' @param url_pdf URL to the CDC mortality public use data page, used to scrape
#'   mortality user guide links separately.
#'
#' @return The same named list with each element cleaned and pivoted to wide
#'   format, with one row per year and columns for each subsection's URL,
#'   file size, and file type.
#'
#' @details Section-specific handling:
#'   \describe{
#'     \item{Births}{Addenda filtered out; user guide URL forward-filled for
#'       years without a dedicated guide.}
#'     \item{Period Linked}{Rows with no U.S. Data URL are dropped.}
#'     \item{Matched Multiple}{Redundant 1995-1997 file dropped in favour of
#'       the superseding 1995-2000 file.}
#'     \item{Mortality Multiple}{User guides are hosted on a separate page and
#'       scraped independently. 1997 and 1998 require a further dedicated scrape
#'       to extract the Detail Record Layout PDF. User guide URL is
#'       forward-filled for years without a dedicated guide.}
#'     \item{Fetal Death}{For 2014 and 2015, the plain U.S. Data and U.S.
#'       Territories files are dropped in favour of the richer
#'       "with cause of death" versions.}
#'   }
#'
#' @seealso \code{\link{scrape_all_sections}}, \code{\link{build_link_lookup}},
#'   \code{\link{scrape_mortality_user_guide}},
#'   \code{\link{scrape_mortality_user_guide_specific}}
#'
#' @export
clean_all_sections <- function(datas, url_pdf) {
    # 1 Births - filter addenda, fill user guide forward for years without one
    datas[[1]] <- datas[[1]] %>%
        dplyr::filter(!stringr::str_detect(link_text, "Addendum")) %>%
        dplyr::select(section, year, subsection, url, file_size, file_type) %>%
        tidyr::pivot_wider(
            names_from  = subsection,
            values_from = c(url, file_size, file_type),
            names_glue  = "{subsection}_{.value}"
        ) %>%
        dplyr::arrange(year) %>%
        tidyr::fill(`User Guide_url`, `User Guide_file_size`, `User Guide_file_type`, .direction = "down") %>%
        dplyr::arrange(dplyr::desc(year))

    # 2 Period Cohort
    datas[[2]] <- datas[[2]] %>%
        dplyr::select(section, year, subsection, url, file_size, file_type) %>%
        tidyr::pivot_wider(
            names_from  = subsection,
            values_from = c(url, file_size, file_type),
            names_glue  = "{subsection}_{.value}"
        )

    # 3 Period Linked - drop rows with no U.S. Data
    datas[[3]] <- datas[[3]] %>%
        dplyr::select(section, year, subsection, url, file_size, file_type) %>%
        tidyr::pivot_wider(
            names_from  = subsection,
            values_from = c(url, file_size, file_type),
            names_glue  = "{subsection}_{.value}"
        ) %>%
        dplyr::filter(!is.na(`U.S. Data_url`))

    # 4 Birth Cohort
    datas[[4]] <- datas[[4]] %>%
        dplyr::select(section, year, subsection, url, file_size, file_type) %>%
        tidyr::pivot_wider(
            names_from  = subsection,
            values_from = c(url, file_size, file_type),
            names_glue  = "{subsection}_{.value}"
        )

    # 5 Matched Multiple - drop redundant 1995-1997 file (superseded by 1995-2000)
    datas[[5]] <- datas[[5]] %>%
        dplyr::filter(!stringr::str_detect(link_text, "1995-1997")) %>%
        dplyr::select(section, year, subsection, url, file_size, file_type) %>%
        tidyr::pivot_wider(
            names_from  = subsection,
            values_from = c(url, file_size, file_type),
            names_glue  = "{subsection}_{.value}"
        )

    # 6 Mortality Multiple - user guides live on a separate page
    # 1997 and 1998 have their own pages with multiple PDFs; we grab Detail Record Layout specifically
    extra <- scrape_mortality_user_guide(url_pdf) %>%
        dplyr::filter(stringr::str_detect(link_text, "^\\d{4}"))

    mortality_1997 <- scrape_mortality_user_guide_specific("https://www.cdc.gov/nchs/nvss/mcd/1997mcd.htm", 1997)
    mortality_1998 <- scrape_mortality_user_guide_specific("https://www.cdc.gov/nchs/nvss/mcd/1998mcd.htm", 1998)

    extra <- extra %>%
        dplyr::filter(!year %in% c(1997, 1998)) %>%
        dplyr::bind_rows(mortality_1997, mortality_1998)

    datas[[6]] <- datas[[6]] %>%
        dplyr::filter(subsection != "User Guide") %>%
        dplyr::filter(!stringr::str_detect(link_text, "Detailed Underlying Cause")) %>%
        dplyr::bind_rows(extra) %>%
        dplyr::select(section, year, subsection, url, file_size, file_type) %>%
        tidyr::pivot_wider(
            names_from  = subsection,
            values_from = c(url, file_size, file_type),
            names_glue  = "{subsection}_{.value}"
        ) %>%
        dplyr::arrange(year) %>%
        tidyr::fill(`User Guide_url`, `User Guide_file_size`, `User Guide_file_type`, .direction = "down")

    # 7 Fetal Death - 2014 and 2015 have both plain and "with cause of death" versions
    # keep the richer "with cause of death" for U.S. Data and U.S. Territories
    datas[[7]] <- datas[[7]] %>%
        dplyr::filter(!(subsection %in% c("U.S. Data", "U.S. Territories") & year %in% c(2014, 2015) & !stringr::str_detect(link_text, "with cause of death"))) %>%
        dplyr::select(section, year, subsection, url, file_size, file_type) %>%
        tidyr::pivot_wider(
            names_from  = subsection,
            values_from = c(url, file_size, file_type),
            names_glue  = "{subsection}_{.value}"
        )

    datas
}
