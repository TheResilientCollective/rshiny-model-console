test_that("defaults NOT created when called with with data object", {
  with_local_project({
    data_dir <- usethis::proj_path("output")
    options(resilient.data=data_dir)
    fpath <- file.path(data_dir, "test_file.rds")
    expect_false(file.exists(fpath))
    persistent_data_watcher("test_file.rds", "fake data", value1=1, value2="two")
    expect_false(file.exists(fpath))
  })
})

test_that("defaults created when called with with no data object", {
  with_local_project({
    data_dir <- usethis::proj_path("output")
    options(resilient.data=data_dir)
    fpath <- file.path(data_dir, "test_file.rds")
    expect_false(file.exists(fpath))
    persistent_data_watcher("test_file.rds", NULL, value1=1, value2="two")
    expect_true(file.exists(fpath))
    dat <- readRDS(fpath)
    expect_equal(dat, list(value1=1, value2="two"))
  })
})
