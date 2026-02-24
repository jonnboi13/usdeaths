#' Convert file size strings to megabytes
#'
#' Parses file size strings containing KB, MB, or GB units and converts
#' them to a numeric value in megabytes.
#'
#' @param file_size Character vector of file size strings (e.g. "531 KB", "1.8 MB").
#' @param rounding Integer giving the number of decimal places to round to. Default is 5.
#'
#' @return A numeric vector of file sizes in megabytes.
#'
#' @examples
#' parse_file_size_mb("531 KB")
#' parse_file_size_mb("1.8 MB")
#' parse_file_size_mb(c("90 KB", "2 MB", "1 GB"))
#'
#' @importFrom dplyr case_when
#' @importFrom stringr str_detect str_extract
#'
#' @export
parse_file_size_mb <- function(file_size, rounding = 5) {
    round(case_when(
        str_detect(file_size, "KB") ~ as.numeric(str_extract(file_size, "[\\d.]+")) / 1024,
        str_detect(file_size, "MB") ~ as.numeric(str_extract(file_size, "[\\d.]+")),
        str_detect(file_size, "GB") ~ as.numeric(str_extract(file_size, "[\\d.]+")) * 1024,
        TRUE ~ NA_real_
    ), rounding)
}
