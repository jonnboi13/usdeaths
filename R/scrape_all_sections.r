# Tell R CMD check these are column names to avoid notes
utils::globalVariables(c(
    ".", "link_text", "subsection", "year", "file_size", "file_type",
    "section", "file_size_mb", "url", "user_guide_url", "user_guide_size",
    "us_data_url", "us_data_size",
    "User Guide_url", "User Guide_file_size", "User Guide_file_type",
    "U.S. Data_url", "U.S. Data_file_size"
))
#' Scrape All CDC Vital Statistics Sections
#'
#' Scrapes all seven CDC vital statistics data sections from the Vital Statistics
#' Online page and returns them as a named list of tibbles in long format.
#'
#' @param url URL to the CDC Vital Statistics Online page. Defaults to the
#'   current CDC page.
#'
#' @return A named list of seven tibbles, one per section, each containing
#'   columns: \code{section}, \code{subsection}, \code{link_text}, \code{year},
#'   \code{file_size}, \code{url}, \code{file_type}, and \code{file_size_mb}.
#'
#' @seealso \code{\link{clean_all_sections}}, \code{\link{build_cdc_lookup}}
#'
#' @export
scrape_all_sections <- function(url) {
    page <- get_html_page(url)

    clean_section <- function(df) {
        df %>%
            dplyr::mutate(dplyr::across(dplyr::everything(), as.character)) %>%
            mutate(
                file_size    = stringr::str_replace(file_size, "([\\d]+\\.[\\d]+)\\.", "\\1 "),
                year         = stringr::str_sub(year, 1, 4) %>% as.integer(),
                file_size_mb = parse_file_size_mb(file_size)
            )
    }

    births <- scrape_cdc_section(page, "Births", "births", c("User Guide", "U.S. Data", "U.S. Territories")) %>% clean_section()
    period_cohort <- scrape_cdc_section(page, "Period_cohort", "period_cohort", c("User Guide", "U.S. Data", "U.S. Territories")) %>% clean_section()
    period_linked <- scrape_cdc_section(page, "Period_Linked", "period_linked", c("User Guide", "U.S. Data", "U.S. Territories")) %>% clean_section()
    birth_cohort <- scrape_cdc_section(page, "Birth_Cohort", "birth_cohort", c("User Guide", "U.S. Data", "U.S. Territories")) %>% clean_section()
    matched_multiple <- scrape_cdc_section(page, "matched-multiple", "matched-multiple", c("User Guide", "U.S. Data")) %>% clean_section()
    mortality_mult <- scrape_cdc_section(page, "Mortality_Multiple", "mortality_multiple", c("User Guide", "U.S. Data", "U.S. Territories")) %>% clean_section()
    fetal_death <- scrape_cdc_section(page, "Fetal_Death", "fetal_death", c("User Guide", "U.S. Data", "U.S. Territories")) %>% clean_section()

    list(
        births           = births,
        period_cohort    = period_cohort,
        period_linked    = period_linked,
        birth_cohort     = birth_cohort,
        matched_multiple = matched_multiple,
        mortality_mult   = mortality_mult,
        fetal_death      = fetal_death
    )
}
