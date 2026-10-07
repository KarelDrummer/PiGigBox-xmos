cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)

set(APP_INCLUDES src src/core src/extensions)

# The sandbox root is the repository root (sw_pigigbox/app_*/ -> ../..)
set(XMOS_SANDBOX_DIR ${CMAKE_CURRENT_LIST_DIR}/../..)
include(${CMAKE_CURRENT_LIST_DIR}/../deps.cmake)

set(APP_PCA_ENABLE ON)

set(PIGIGBOX_FLAGS ${EXTRA_BUILD_FLAGS} -O3
                                        -report
                                        -lquadflash
                                        -g
                                        -Wall
                                        -fxscope
                                        -DBOARD_SUPPORT_BOARD=XK_AUDIO_316_MC_AB
                                        -DADAT_TX_USE_SHARED_BUFF=1)

project(app_pigigbox_xk_316_mc)
set(APP_HW_TARGET xk-audio-316-mc.xn)

# Build config naming scheme (inherited from sw_usb_audio):
#
# Audio Class:   1 or 2
# Sync Mode      A(sync) or S(ync)
# I2S            M(aster) or S(lave)
# Input          enabled: i (channelcount)
# Output         enabled: o (channelcount)
# MIDI           enabled: m, disabled: x
# SPDIF in       enabled: s, disabled: x
# SPDIF out      enabled: s, disabled: x
# ADAT in        enabled: a, disabled: x
# ADAT out       enabled: a, disabled: x
# DSD out        enabled: d, disabled: x
#
# Additional tags may be added to the end of the build config name to indicate special features.

# Audio Class 2, Async, I2S Master, 16xInput, 16xOutput, ADAT Tx, ADAT Rx
set(APP_COMPILER_FLAGS_2AMi16o16xxxaax ${PIGIGBOX_FLAGS}   -DXUA_ADAT_RX_EN=1
                                                           -DXUA_ADAT_TX_EN=1)

XMOS_REGISTER_APP()
