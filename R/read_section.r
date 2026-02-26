#' Read a CDC vital statistics fixed-width file using a metadata table
#'
#' Reads an unzipped CDC vital statistics fixed-width file into a tibble,
#' using a metadata table from this package to define the column positions,
#' widths, and names. All columns are read as character to avoid silent
#' coercion of coded numeric fields.
#'
#' @param data_file Path to the unzipped fixed-width data file downloaded
#'   from the CDC vital statistics FTP server.
#' @param meta A metadata tibble with columns \code{start}, \code{end}, and
#'   \code{name} defining the fixed-width layout, such as
#'   \code{data_multiple_mortality_1969}.
#'
#' @return A tibble with one row per death record and one column per field
#'   defined in \code{meta}. All columns are character type — use
#'   \code{decode_preview()} to decode coded fields into human-readable labels.
#'
#' @examples
#' \dontrun{
#' meta <- data_multiple_mortality_1969
#' mort1969 <- read_section(data_file, meta)
#' }
#' @export
read_section <- function(data_file, meta) {
    read_fwf(
        data_file,
        col_positions = fwf_positions(
            start     = meta$start,
            end       = meta$end,
            col_names = meta$name
        ),
        col_types = paste(rep("c", nrow(meta)), collapse = "")
    )
}
