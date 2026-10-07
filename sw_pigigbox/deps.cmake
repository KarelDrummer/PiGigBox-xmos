# Module dependencies shared by all applications in sw_pigigbox.
#
# The versions below MUST match the git submodules checked out in the sandbox root
# (see ../.gitmodules and ../docs/dependencies.md). XCommon CMake never modifies a module
# that is already present in the sandbox; the versions are used only as a fallback to clone
# a missing module.
#
# lib_sw_pll and lib_xassert are deliberately held back from their newest release, see docs/dependencies.md.
set(APP_DEPENDENT_MODULES "lib_xua(5.5.0)"
                          "lib_i2c(6.4.1)"
                          "lib_i2s(6.0.1)"
                          "lib_board_support(1.5.0)"
                          "lib_sw_pll(2.4.1)"
                          "lib_xassert(4.3.2)")