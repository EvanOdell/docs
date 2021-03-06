#' @export
build_threesixtygiving <- function(force = FALSE) {
  tictoc::tic()
  message("Building `threesixtygiving`")

  base_files <- paste0(
    "../threesixtygiving/",
    list.files(
      path = "../threesixtygiving",
      recursive = TRUE
    )
  )

  base_files <- base_files[!grepl("docs", base_files)]
  base_files <- base_files[!grepl("data-raw", base_files)]
  base_files <- base_files[!grepl("tests", base_files)]

  x <- lapply(base_files, file.info)

  base_modified <- purrr::map(x, "mtime") %>%
    purrr::map(as.character) %>%
    unlist() %>%
    as.POSIXct()

  web_files <- paste0("threesixtygiving/", list.files(path = "threesixtygiving", recursive = TRUE))

  y <- lapply(web_files, file.info)

  web_modified <- purrr::map(y, "mtime") %>%
    purrr::map(as.character) %>%
    unlist() %>%
    as.POSIXct()

  if (is.na(web_modified) || max(web_modified) <= max(base_modified) || force == TRUE) {
    pkgdown::build_site(
      pkg = "../threesixtygiving",
      preview = FALSE
    )

    threesixtygiving_doc_files <- list.files(
      "../threesixtygiving/docs",
      all.files = TRUE, full.names = TRUE,
      recursive = FALSE, ignore.case = TRUE,
      include.dirs = TRUE, no.. = TRUE
    )

    unlink("threesixtygiving", recursive = TRUE)
    dir.create("threesixtygiving")

    file.copy(threesixtygiving_doc_files,
      "../docs/threesixtygiving",
      recursive = TRUE
    )
  } else {
    message("Up to date!")
  }
  tictoc::toc()
  message(emo::ji("money"))
}
