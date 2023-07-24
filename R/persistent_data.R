#' Path to storage file for persistent data.
#' 
#' Persistent data file goes in project's "output" directory, create if needed.
#' 
#' @family Shared Data Methods
#' 
#' @param fname Name of the file.
#' @returns Path to the file.  Still may not exist, but directory should.
persistent_data_path <- function(fname) {
  output_dir = usethis::proj_path("output")
  if (!dir.exists(output_dir)) {
    dir.create(output_dir)
  }
  file.path(output_dir, fname)
}

#' Write an object to persistent data file.
#' 
#' WARNING!  Completely overwrites the file.
#' 
#' @family Shared Data Methods
#' 
#' @param fname Name of the file.
#' @param data_obj Data to write.  No enforcement of correctness here.
persistent_data_write <- function(fname, data_obj) {
  fpath = persistent_data_path(fname)
  readr::write_rds(data_obj, fpath)
}

#' Reactive RData file reader with a default
#'
#' This wrapper for reactiveFileReader provides default data if no file exists.
#' Variable args (defaults) written as list to the file on function call if the
#' file does not exist.
#'
#' We also automatically place the file in the packages "output" directory.
#' 
#' NOTE: we do NOT compress the file (expecting small files and speed is good)
#'
#' @family Shared Data Methods
#' 
#' @param fname Name of file to watch
#' @param reactive_override If not NULL, override file watch with this object
#' @param ... Other args written as default if file does not exist.
#' @returns Reactive file reader for the file, or the reactive override.
persistent_data_watcher <- function(fname, reactive_override, ...) {
  if (!all(is.null(reactive_override))) {
    return(reactive_override)
  }

  fpath = persistent_data_path(fname)
  if (!file.exists(fpath)) {
    readr::write_rds(list(...), fpath)
  }

  shiny::reactiveFileReader(
    1000,
    NULL,
    fpath,
    readr::read_rds
  )
}
