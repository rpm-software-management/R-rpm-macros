#!/usr/bin/Rscript
# SPDX-License-Identifier: MIT

file_patterns <- list(
  license = c("^license.*", "^licence.*", "^copying.*", "^copyright.*",
              "^notice.*", "^authors.*"),
  doc = c("^doc$", "^html$", "^readme.*", "^news.*", "^changelog.*", "^todo.*",
          "^announce.*", "^bib$"),
  dir = "^po$"
)

args <- commandArgs(trailingOnly = TRUE)
args_present <- all(c("-b", "-p") %in% args)
args_ordered <- all(which(args %in% c("-b", "-p")) %% 2 == 1)
if (length(args) != 4 || !args_present || !args_ordered) {
  cat("Usage: R-files.R -b <buildroot> -p <pkg_path>.\n")
  quit(status = 1)
}

buildroot <- args[which(args == "-b") + 1]
pkg_path <- args[which(args == "-p") + 1]

all_files <- list.files(file.path(buildroot, pkg_path))
pkg_files <- lapply(file_patterns, sapply, function(pat)
  list.files(file.path(buildroot, pkg_path), pattern=pat, ignore.case=TRUE)) |>
  lapply(unlist, use.names = FALSE)
pkg_files[[length(pkg_files)+1]] <- setdiff(all_files, unlist(pkg_files))

cat("%dir", pkg_path, fill = TRUE)
for (i in seq_along(pkg_files)) for (file in pkg_files[[i]]) {
  type <- names(pkg_files)[i]
  type <- if (nchar(type)) paste0("%", type, " ") else NULL
  cat(paste0(type, file.path(pkg_path, file)), fill = TRUE)
}

lng_files <- list.files(file.path(buildroot, pkg_path, "po"))
for (file in lng_files) {
  type <- paste0("%lang(", sub("@.*", "", file), ") ")
  cat(paste0(type, file.path(pkg_path, "po", file)), fill = TRUE)
}
