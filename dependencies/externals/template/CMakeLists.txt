# =============================================================================
# Template: Add External Package
# =============================================================================
# This template shows how to add a new external package. To use it, copy this
# file to a new directory under 'dependencies/externals', rename the directory
# to your package name, and then uncomment and fill in the 'add_external_package'
# call below.

include(${CMAKE_SOURCE_DIR}/cmake/library/add_external_package.cmake)

# --- Example: Add External Package ---
# To add a new package, uncomment the following lines and replace the
# placeholder values.
#
# add_external_package(
#   REPOSITORY_URL "https://github.com/{username}/{repo}.git"
#   REPOSITORY_TAG "{tag}"
#   LIBRARIES {repo}::{repo}
#   COMPILE_DEFINITIONS "{compile_definitions}"
#   COMPILE_OPTIONS "{compile_options}"
# )

