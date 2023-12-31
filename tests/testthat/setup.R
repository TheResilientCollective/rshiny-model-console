# Copied from
# https://community.rstudio.com/t/how-to-test-functions-that-operate-on-projects-without-cluttering-test-output/113283/4

# We don't want usethis printing messages during testing because it clutters the console. See
# https://community.rstudio.com/t/how-to-test-functions-that-operate-on-projects-without-cluttering-test-output/113283/2?u=lewinfox
# for the background
options(usethis.quiet = TRUE)


# Pinched from https://github.com/jimhester/usethis/blob/de8aa116820a8e54f2f952b341039985d78d0352/tests/testthat/helper.R#L28-L68
# See https://github.com/r-lib/devtools/blob/78b4cabcba47e328e255fffa39e9edcad302f8a0/tests/testthat/test-build-readme.R
# for an example of how to use.

create_local_thing <- function(dir = fs::file_temp(),
                               env = parent.frame(),
                               rstudio = FALSE,
                               thing = c("package", "project")) {
  
  if (!requireNamespace("fs", quietly = TRUE)) {
    rlang::abort("Package `fs` is required but not installed.")
  }
  
  thing <- match.arg(thing)
  if (dir.exists(dir)) {
    usethis::ui_stop("Target {usethis::ui_code('dir')} {usethis::ui_path(dir)} already exists.")
  }
  
  # I ran into an issue with R CMD check where the old_project (tests/testthat/ in the temporary
  # folder) was not a project so this `proj_get()` call failed with an error. Wrapping this in a
  # `try()` allows us to A: stop those tests failing and B: check for the existence of an old
  # project before trying to switch back to it.
  old_project <- try(usethis::proj_get(), silent = TRUE)
  has_old_project <- !inherits(old_project, "try-error")
  old_wd <- getwd()          # not necessarily same as `old_project`

  withr::defer(
    {
      fs::dir_delete(dir)
    },
    envir = env
  )
  
  switch(
    thing,
    package = usethis::create_package(dir, rstudio = rstudio, open = FALSE, check_name = FALSE),
    project = usethis::create_project(dir, rstudio = rstudio, open = FALSE)
  )
  
  if (has_old_project) {
    withr::defer(usethis::proj_set(old_project, force = TRUE), envir = env)
  }
  usethis::proj_set(dir)
  
  withr::defer(
    {
      setwd(old_wd)
    },
    envir = env
  )
  
  setwd(usethis::proj_get())
  invisible(usethis::proj_get())
}

# Helper function to create a local project, run tests and clean up afterwards
# e.g.
#
# test_that("foo is barred correctly", {
#   with_local_project({
#     bar(foo)
#     expect_true(is.barred(foo))
#   })
# })
#
with_local_project <- function(code) {
  create_local_thing(thing = "project")
  # If you need to do anything else to set up your test project, do it here
  force(code)
}

with_local_package <- function(code) {
  create_local_thing(thing = "package")
  # If you need to do anything else to set up your test project, do it here
  force(code)
}
