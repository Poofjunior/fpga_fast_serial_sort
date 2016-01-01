# Arduino Makefile. Refer to https://github.com/sudar/Arduino-Makefile
# Teensy Only!
USB_TYPE = USB_SERIAL

# WARNING: Trailing whitespace will cause options to be read incorrectly.
BOARD_TAG    = teensy31

# Additional user-defined libraries may be added to this list
ARDUINO_LIBS += SPI

# Default user-defined libraries directory
#USER_LIB_PATH += ../../../teensy_lib

BRANCH := $(shell git branch | grep "*")
BUILD_DATE := $(shell date)
AUTHOR := $(shell whoami)

CPPFLAGS += -DBRANCH='"$(BUILD_VERSION_MAIN_GIT)"' \
            -DBUILD_DATE='"$(BUILD_DATE)"' \
            -DAUTHOR='"$(AUTHOR)"'

# Teensy explicitly requires Arduino 1.0.x as of Nov 2014
# ARDUINO_DIR should be defined in your Makefile. Otherwise, you may
# define it here.

# teensy3 and teensy31 explicitly require their own Makefile.
include $(ARDMK_DIR)/Teensy.mk
#include $(ARDMK_DIR)/Arduino.mk
