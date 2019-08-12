#!/usr/bin/Rscript

# This is an RPM generator script for R dependencies.
#
# This file is under the MIT license.
#
# Parts of this file were taken from the `desc` package, also under the MIT
# license, Copyright 2015-2018, Gábor Csárdi, RStudio Inc
#
# From the RPM docs:
#   A generator is just an executable that reads file name(s) from stdin and
#   writes out Provides: or Requires: on stdout. This way the generator can be
#   implemented in whatever language is preferred and can use e.g. language
#   specific libraries or tools. Generators get called once for each file with
#   matching attributes.

# str_trim is from `desc`:R/utils.R
str_trim <- function(x) {
  sub("^\\s+", "", sub("\\s+$", "", x))
}

# parse_deps is from `desc`:R/deps.R, but without 'type', and some tweaks for
# empty input and whitespace cleanup.
parse_deps <- function(deps) {
  if (is.null(deps)) {
    deps <- ""
  }
  deps <- gsub("\n", " ", deps)
  deps <- str_trim(strsplit(deps, ",")[[1]])
  deps <- lapply(strsplit(deps, "\\("), str_trim)
  deps <- lapply(deps, sub, pattern = "\\)$", replacement = "")
  res <- data.frame(
    stringsAsFactors = FALSE,
    package = vapply(deps, "[", "", 1),
    version = vapply(deps, "[", "", 2)
  )
  res
}

# Print out a package dependency, using the standard name, and optionally a
# version constraint if provided.
print_package_dep <- function(pkg_deps) {
  name <- paste0("R(", pkg_deps$package[1], ")", sep = "")
  versions <- na.omit(pkg_deps$version)
  if (length(versions) == 0) {
    # No versions specified.
    cat(name, "\n")
  } else {
    cat(paste(name, versions, sep = " "), sep = "\n")
  }
}

# Given a path to a package DESCRIPTION file, and a list of dependency types,
# print those out in standard RPM format.
generate_package_deps <- function(path, types) {
  pkgpath <- dirname(path)  # Drop DESCRIPTION; point to package path instead.
  desc <- packageDescription(basename(pkgpath), lib.loc = dirname(pkgpath))
  if (all(types == "Provides")) {
    cat("R(", desc$Package, ") = ", desc$Version, "\n", sep = "")
  } else {
    deps <- lapply(types, function(t) parse_deps(desc[[t]]))
    deps <- do.call(rbind, deps)
    pkg_deps <- split(deps, deps$package)
    pkg_deps$R <- NULL  # Skip any R dependencies, which allow weird versioning.
    lapply(pkg_deps, print_package_dep)
  }
}

types <- commandArgs(trailingOnly = TRUE)
nprovides <- sum(types == "Provides")
if (0 < nprovides && nprovides < length(types)) {
  cat("Specifying Provides and any other type is invalid.\n")
  quit(status = 1)
}

con <- file("stdin")
while (TRUE) {
  fn <- readLines(con = con, n = 1)
  if (length(fn) == 0) {
    break
  }
  generate_package_deps(fn, types)
}
close(con)
