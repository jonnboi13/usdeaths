#' Scrape CDC Mortality Multiple Cause User Guides
#'
#' Scrapes user guide PDF links from the CDC mortality public use data page.
#' Note that 1997 and 1998 link to dedicated pages with multiple PDFs rather
#' than a single user guide — use \code{\link{scrape_mortality_user_guide_specific}}
#' for those years.
#'
#' @param url URL to the CDC mortality public use data page.
#'
#' @return A tibble with columns: \code{section}, \code{subsection},
#'   \code{link_text}, \code{year}, \code{file_size}, \code{url},
#'   \code{file_type}, \code{file_size_mb}.
#'
#' @seealso \code{\link{scrape_mortality_user_guide_specific}},
#'   \code{\link{clean_all_sections}}
#'
#' @export
scrape_mortality_user_guide <- function(url) {
    page <- get_html_page(url)

    links <- page %>% rvest::html_elements(".cdc-textblock li a[href]")

    tibble::tibble(
        link_text = rvest::html_text2(links),
        url       = rvest::html_attr(links, "href")
    ) %>%
        dplyr::filter(!is.na(url)) %>%
        dplyr::mutate(
            url = xml2::url_absolute(url, "https://www.cdc.gov"),
            file_type = stringr::str_extract(url, "\\.[a-zA-Z0-9]+$"),
            file_size = stringr::str_extract(link_text, "\\[PDF \\u2013 ([^]]+)\\]") %>% stringr::str_remove_all("\\[PDF \\u2013 |\\]"),
            year = as.integer(stringr::str_extract(link_text, "\\d{4}")),
            file_size_mb = parse_file_size_mb(file_size),
            section = "mortality_multiple",
            subsection = "User Guide"
        ) %>%
        tidyr::fill(year, .direction = "down") %>%
        dplyr::select(section, subsection, link_text, year, file_size, url, file_type, file_size_mb)
}


#' Scrape CDC Mortality User Guide for a Specific Year
#'
#' For years where the CDC hosts multiple PDFs on a dedicated page rather than
#' a single user guide (currently 1997 and 1998), this function scrapes the
#' Detail Record Layout PDF link specifically, as that is the file needed to
#' parse the fixed-width data files.
#'
#' @param url URL to the year-specific CDC mortality documentation page.
#' @param year Integer. The data year corresponding to the page.
#'
#' @return A single-row tibble with columns: \code{section}, \code{subsection},
#'   \code{link_text}, \code{year}, \code{file_size}, \code{url},
#'   \code{file_type}, \code{file_size_mb}.
#'
#' @seealso \code{\link{scrape_mortality_user_guide}},
#'   \code{\link{clean_all_sections}}
#'
#' @export
scrape_mortality_user_guide_specific <- function(url, year) {
    page <- get_html_page(url)
    link <- page %>%
        rvest::html_elements("a") %>%
        purrr::keep(~ stringr::str_detect(rvest::html_text2(.x), "Detail Record Layout")) %>%
        .[[1]]

    tibble::tibble(
        section = "mortality_multiple",
        subsection = "User Guide",
        link_text = rvest::html_text2(link),
        year = year,
        file_size = rvest::html_text2(link) %>% stringr::str_extract("\\[PDF \\u2013 ([^\\]]+)\\]", group = 1),
        url = xml2::url_absolute(rvest::html_attr(link, "href"), "https://www.cdc.gov"),
        file_type = ".pdf",
        file_size_mb = parse_file_size_mb(file_size)
    )
}
