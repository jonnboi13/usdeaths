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




#' Mortality multiple cause data layouts
#'
#' Metadata tables describing the fixed-width file layout for US mortality
#' multiple cause datasets from the CDC NCHS. Each object covers one data year
#' and contains the column positions, types, and code mappings needed to parse
#' the corresponding fixed-width file.
#'
#' @format A tibble with 7 variables:
#' \describe{
#'   \item{name}{Column name}
#'   \item{start}{Start position in fixed-width file}
#'   \item{end}{End position in fixed-width file}
#'   \item{size}{Field width in characters}
#'   \item{type}{Data type: "int" or "str"}
#'   \item{description}{Human-readable field description}
#'   \item{codes}{Pipe-delimited key=label pairs for coded fields, empty string if none}
#' }
#' @source \url{https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/}
#' @name mortality_layouts
NULL

#' @rdname mortality_layouts
#' @note This is an early year with limited coding — several fields left blank.
"data_multiple_mortality_1969"

#' @rdname mortality_layouts
#' @note This year introduced a revised race classification schema.
#' @note Additional cause of death fields were added to the layout this year.
"data_multiple_mortality_2023"
