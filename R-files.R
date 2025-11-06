#!/usr/bin/Rscript
# SPDX-License-Identifier: MIT

file_globs <- list(
  license = c("LICENSE*", "LICENCE*", "COPYING*", "NOTICE*", "AUTHORS*"),
  doc = c("doc", "html", "README*", "NEWS*", "ChangeLog*", "TODO*", "announce", "bib")
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
pkg_files <- lapply(file_globs, sapply, function(glob) 
  list.files(file.path(buildroot, pkg_path), pattern = glob)) |>
  lapply(unlist, use.names = FALSE)
pkg_files[[length(pkg_files)+1]] <- setdiff(all_files, unlist(pkg_files))

cat("%dir", pkg_path, fill = TRUE)
for (i in seq_along(pkg_files)) for (file in pkg_files[[i]]) {
  type <- names(pkg_files)[i]
  type <- if (nchar(type)) paste0("%", type, " ") else NULL
  cat(paste0(type, file.path(pkg_path, file)), fill = TRUE)
}
