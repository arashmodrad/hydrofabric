msg <- function(..., startup = FALSE) {
  if (startup) {
    if (!isTRUE(getOption("hydrofabric.quiet"))) {
      packageStartupMessage(text_col(...))
    }
  } else {
    message(text_col(...))
  }
}

text_col <- function(x) {
  # If RStudio not available, messages already printed in black
  if (!rstudioapi::isAvailable()) {
    return(x)
  }
  
  if (!rstudioapi::hasFun("getThemeInfo")) {
    return(x)
  }
  
  theme <- rstudioapi::getThemeInfo()
  
  if (isTRUE(theme$dark)) crayon::white(x) else crayon::black(x)
  
}

#' List all packages in the hydrofabric
#'
#' @param include_self Include hydrofabric in the list?
#' @export
#' @examples
#' hydrofabric_packages()

hydrofabric_packages <- function(include_self = TRUE) {
  raw <- utils::packageDescription("hydrofabric")$Imports
  imports <- strsplit(raw, ",")[[1]]
  parsed <- gsub("^\\s+|\\s+$", "", imports)
  names <- vapply(strsplit(parsed, "\\s+"), "[[", 1, FUN.VALUE = character(1))
  
  names = names[! names %in% c("purrr", 'cli', 'crayon', 'rstudioapi' )]
  
  if (include_self) {
    names <- c(names, "hydrofabric")
  }
  
  names
}

invert <- function(x) {
  if (length(x) == 0) return()
  stacked <- utils::stack(x)
  tapply(as.character(stacked$ind), stacked$values, list)
}


style_grey <- function(level, ...) {
  crayon::style(
    paste0(...),
    crayon::make_style(grDevices::grey(level), grey = TRUE)
  )
}
