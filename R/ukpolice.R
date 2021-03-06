#' @export
build_ukpolice <- function(force = FALSE) {
  tictoc::tic()
  message("Building `ukpolice`")

  base_files <- paste0(
    "../ukpolice/",
    list.files(
      path = "../ukpolice",
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

  web_files <- paste0("ukpolice/", list.files(path = "ukpolice", recursive = TRUE))

  y <- lapply(web_files, file.info)

  web_modified <- purrr::map(y, "mtime") %>%
    purrr::map(as.character) %>%
    unlist() %>%
    as.POSIXct()

  if (max(web_modified) <= max(base_modified) || force == TRUE) {
    pkgdown::build_site(
      pkg = "../ukpolice",
      preview = FALSE
    )

    ukpolice_doc_files <- list.files(
      "../ukpolice/docs",
      all.files = TRUE, full.names = TRUE,
      recursive = FALSE, ignore.case = TRUE,
      include.dirs = TRUE, no.. = TRUE
    )

    unlink("ukpolice", recursive = TRUE)
    dir.create("ukpolice")

    file.copy(ukpolice_doc_files,
      "../docs/ukpolice",
      recursive = TRUE
    )
  } else {
    message("Up to date!")
  }
  tictoc::toc()
  message(
    emo::ji("british"),
    sample(c(rep(emo::ji("police"), 4), emo::ji("pig")), 1)
  )
}
