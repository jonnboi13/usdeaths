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

#' @rdname mortality_layouts
#' @note Geographic identifiers are present: positions 21–60 contain state,
#'   county, and city of both occurrence and residence, PMSA/MSA, CMSA, and
#'   place of birth. This detail was removed from public-use files from 2005
#'   onward per NCHS data access policy.
#' @note Both 1989 and 2003 education revision fields are present alongside an
#'   \code{education_reporting_flag} indicating which revision was used.
#' @note \code{record_type} is present at position 19. \code{marital_status}
#'   includes code \code{N} (not on certificate). Occupation and industry fields
#'   are absent.
"data_multiple_mortality_2003"

#' @rdname mortality_layouts
#' @note Layout is structurally identical to 2003, retaining full geographic
#'   detail in positions 21–60 and dual education revision fields.
#' @note \code{record_type} is present at position 19. \code{marital_status}
#'   includes code \code{N} (not on certificate). Occupation and industry fields
#'   are absent.
"data_multiple_mortality_2004"

#' @rdname mortality_layouts
#' @note Geographic identifiers were removed from the public-use file this year
#'   per a new NCHS data access policy. Positions 1–19 and 21–60 are reserved
#'   (blank). The \code{record_type} field is absent from 2005 onward.
#' @note \code{marital_status} code \code{N} (not on certificate) is removed.
#'   Both 1989 and 2003 education revision fields are retained. Occupation and
#'   industry fields are absent.
"data_multiple_mortality_2005"

#' @rdname mortality_layouts
#' @note Layout is structurally identical to 2005. Geographic identifiers remain
#'   excluded per NCHS data access policy.
#' @note Both education revision fields are present. Occupation and industry
#'   fields are absent.
"data_multiple_mortality_2006"

#' @rdname mortality_layouts
#' @note Layout is structurally identical to 2005–2006. Geographic identifiers
#'   remain excluded per NCHS data access policy.
#' @note Both education revision fields are present. Occupation and industry
#'   fields are absent.
"data_multiple_mortality_2007"

#' @rdname mortality_layouts
#' @note Layout is structurally identical to 2005–2007. Geographic identifiers
#'   remain excluded per NCHS data access policy.
#' @note Both education revision fields are present. Occupation and industry
#'   fields are absent.
"data_multiple_mortality_2008"

#' @rdname mortality_layouts
#' @note Layout is structurally identical to 2005–2008. Geographic identifiers
#'   remain excluded per NCHS data access policy.
#' @note Both education revision fields are present. Occupation and industry
#'   fields are absent.
"data_multiple_mortality_2009"
