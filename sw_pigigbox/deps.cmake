# Module dependencies shared by all applications in sw_pigigbox.
#
# The versions below MUST match the git submodules checked out in the sandbox root
# (see ../.gitmodules and ../docs/dependencies.md). XCommon CMake never modifies a module
# that is already present in the sandbox; the versions are used only as a fallback to clone
# a missing module.
set(APP_DEPENDENT_MODULES "lib_xua(5.2.0)"
                          "lib_i2c(6.4.0)"
                          "lib_i2s(6.0.1)"
                          "lib_board_support(1.3.0)")
