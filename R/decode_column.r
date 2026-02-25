#' Decode a coded column using a pipe-delimited key=label string
#'
#' Takes a vector of coded values and a pipe-delimited string of key=label
#' pairs and returns a vector of human-readable labels. Automatically pads
#' values with leading zeros to match the width of the lookup keys.
#'
#' @param x A vector of coded values to decode. Can be integer, numeric, or character.
#' @param codes_str A pipe-delimited string of key=label pairs,
#'   e.g. \code{"1=Male|2=Female"} or \code{"01=January|02=February"}.
#'
#' @return A character vector of decoded labels. Values with no matching key
#'   are returned as \code{NA}.
#'
#' @examples
#' decode_column(c(1, 2, 1), "1=Male|2=Female")
#' decode_column(c(1, 12), "01=January|02=February|12=December")
#'
#' @export
decode_column <- function(x, codes_str) {
    pairs <- str_split(codes_str, "\\|")[[1]]
    codes <- str_split_fixed(pairs, "=", 2)
    lookup <- setNames(codes[, 2], codes[, 1])

    # always pad to match the width of the keys in the lookup
    key_width <- max(nchar(codes[, 1]))
    x <- str_pad(as.character(x), width = key_width, pad = "0")

    # named vector subsetting — unmatched values return NA
    lookup[x]
}
