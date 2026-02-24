test_that("parse_file_size_mb converts KB correctly", {
    expect_equal(parse_file_size_mb("512 KB"), round(512 / 1024, 5))
    expect_equal(parse_file_size_mb("1 MB"), 1)
    expect_true(is.na(parse_file_size_mb(NA)))
})
