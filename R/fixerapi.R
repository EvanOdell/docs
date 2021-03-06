#' @export
build_fixerapi <- function(force = FALSE) {
  tictoc::tic()
  message("Building `fixerapi`")

  base_files <- paste0(
    "../fixerapi/",
    list.files(
      path = "../fixerapi",
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

  web_files <- paste0("fixerapi/", list.files(path = "fixerapi", recursive = TRUE))

  y <- lapply(web_files, file.info)

  web_modified <- purrr::map(y, "mtime") %>%
    purrr::map(as.character) %>%
    unlist() %>%
    as.POSIXct()

  if (max(web_modified) <= max(base_modified) || force == TRUE) {
    pkgdown::build_site(
      pkg = "../fixerapi",
      preview = FALSE
    )

    fixerapi_doc_files <- list.files(
      "../fixerapi/docs",
      all.files = TRUE, full.names = TRUE,
      recursive = FALSE, ignore.case = TRUE,
      include.dirs = TRUE, no.. = TRUE
    )

    unlink("fixerapi", recursive = TRUE)
    dir.create("fixerapi")

    file.copy(fixerapi_doc_files,
      "../docs/fixerapi",
      recursive = TRUE
    )
  } else {
    message("Up to date!")
  }
  tictoc::toc()
  message(emo::ji("currency"))
}
