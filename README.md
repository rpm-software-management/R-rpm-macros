R-rpm-macros
============

This repository contains files intended to improve packaging of R libraries. At
this time, it contains an attribute file that triggers the automated dependency
generator.

The automated dependency generator parses the `DESCRIPTION` file and produces
`Provides` of the form `R(packageName) = version` and `Requires`, `Suggests`
and `Enhances` of the form `R(packageName)`, `R(packageName) >= version`, etc.

Currently, this setup is used in Fedora Rawhide (31).
