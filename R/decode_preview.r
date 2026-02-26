#' Preview decoded columns from a mortality dataset
#'
#' Decodes coded columns in a mortality dataset using a metadata table,
#' returning original and decoded columns side by side for inspection.
#' Useful for quickly verifying that codes are mapping correctly before
#' committing to a full decode.
#'
#' @param data A data frame of mortality records, typically loaded via
#'   \code{read_fwf()} using a metadata table from this package.
#' @param meta A metadata tibble with at minimum columns \code{name} and
#'   \code{codes}, such as \code{data_multiple_mortality_1969}.
#' @param first_n Integer. Number of coded columns to decode, starting from
#'   the first column in \code{meta} that has codes. Default is \code{5}.
#' @param numbers Integer vector. Additional column indices from \code{meta}
#'   to decode. Overlaps with \code{first_n} are silently deduplicated with
#'   a warning. Columns with no codes are skipped with a warning.
#' @param n_rows Integer. Number of rows to return. Default is \code{1000}.
#'   Use \code{nrow(data)} for a full decode.
#' @param all Logical. If \code{TRUE}, decodes all coded columns and returns
#'   all columns in metadata order with decoded values replaced in place.
#'   Overrides \code{first_n} and \code{numbers}. Default is \code{FALSE}.
#'
#' @return A tibble. When \code{all = FALSE}, returns only the selected
#'   columns with each original column immediately followed by its decoded
#'   \code{_label} counterpart. When \code{all = TRUE}, returns all columns
#'   in metadata order with coded columns decoded in place.
#'
#' @examples
#' \dontrun{
#' meta <- data_multiple_mortality_1969
#'
#' # first 5 coded columns, 1000 rows
#' decode_preview(mort1969, meta)
#'
#' # first 10 coded columns
#' decode_preview(mort1969, meta, first_n = 10)
#'
#' # first 5 coded + column 17
#' decode_preview(mort1969, meta, numbers = 17)
#'
#' # first 3 coded columns + columns 12 and 20 specifically
#' decode_preview(mort1969, meta, first_n = 3, numbers = c(12, 20))
#'
#' # decode everything, replace in place
#' decode_preview(mort1969, meta, all = TRUE)
#'
#' # full decode of entire dataset
#' mort1969_decoded <- decode_preview(mort1969, meta, all = TRUE, n_rows = nrow(mort1969))
#' }
#'
#' @export
decode_preview <- function(data, meta, first_n = 5, numbers = NULL, n_rows = 1000, all = FALSE) {
    if (all) {
        if (!is.null(numbers) || first_n != 5) {
            warning("all = TRUE takes precedence; first_n and numbers are ignored.")
        }

        cols <- meta$name[meta$codes != ""]

        return(
            data |>
                slice_head(n = n_rows) |>
                mutate(across(
                    all_of(cols),
                    ~ decode_column(., meta$codes[meta$name == cur_column()])
                )) |>
                select(all_of(meta$name))
        )
    }

    coded_indices <- which(meta$codes != "")
    first_n_indices <- coded_indices[1:min(first_n, length(coded_indices))]

    # warn about overlap but proceed anyway
    if (!is.null(numbers)) {
        overlap <- intersect(first_n_indices, numbers)
        if (length(overlap) > 0) {
            warning(paste(
                "Overlapping column indices between first_n and numbers:",
                paste(overlap, collapse = ", "), "- duplicates removed."
            ))
        }
    }

    selected_indices <- unique(c(first_n_indices, numbers))

    # warn and drop any explicitly requested columns that have no codes
    no_codes <- selected_indices[meta$codes[selected_indices] == ""]
    if (length(no_codes) > 0) {
        warning(paste(
            "The following column indices have no codes and will be skipped:",
            paste(no_codes, collapse = ", ")
        ))
        selected_indices <- selected_indices[meta$codes[selected_indices] != ""]
    }

    cols <- meta$name[selected_indices]

    # interleave original and label columns side by side
    interleaved <- c(rbind(cols, paste0(cols, "_label")))

    data |>
        slice_head(n = n_rows) |>
        mutate(across(
            all_of(cols),
            ~ decode_column(., meta$codes[meta$name == cur_column()]),
            .names = "{.col}_label"
        )) |>
        select(all_of(interleaved))
}
