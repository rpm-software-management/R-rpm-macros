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

# Print a dependency on the R-core package, specifying a version if one is in
# the metadata, unless the version is a Subversion revision, which we don't
# have.
print_R_dep <- function(pkg_deps) {
  R_deps <- na.omit(pkg_deps$R$version)
  # Skip any versions that specify a Subversion revision.
  R_deps <- R_deps[!grepl("r", R_deps, fixed = TRUE)]
  if (length(R_deps) > 0) {
    cat(paste("R-core", R_deps, sep = " "), sep = "\n")
  } else {
    cat("R-core\n")
  }
}

# Print out a package dependency, using the standard name, and optionally a
# version constraint if provided.
print_package_dep <- function(pkg_dep) {
  name <- paste0("R(", pkg_dep$package[1], ")", sep = "")
  versions <- na.omit(pkg_dep$version)
  if (length(versions) == 0) {
    # No versions specified.
    cat(name, "\n")
  } else {
    cat(paste(name, versions, sep = " "), sep = "\n")
  }
}

# Generate R(ABI) dependency from R major and R minor (but not R patch rev)
print_abi_dep <- function() {
   ABI_major <- R.version$major
   ABI_minor <- sub("\\..*", "", R.version$minor)
   cat("R(ABI) = ", ABI_major, ".", ABI_minor, "\n", sep = "")
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

    if (any(types == "Depends")) {
      # Always add R-core dependency.
      print_R_dep(pkg_deps)
      # Always add R(ABI) dependency.
      print_abi_dep()
    }
    pkg_deps$R <- NULL

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
