ARCHS = arm64

#GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = XPatcher


FLIPS_SRC := $(wildcard MC/Flips/*.cpp)
NONEIOS = MC/Flips/flips-cli.cpp 
FLIPS_SRC := $(filter-out $(NONEIOS), $(FLIPS_SRC)) 

$(APPLICATION_NAME)_FILES = $(wildcard *.m) \
	 $(wildcard CC/*.m) \
	 $(wildcard MC/Flips/*.c) \
	 $(FLIPS_SRC) \
	 $(wildcard MC/libppf/*.cc) \
	 $(wildcard MC/adapters/*.m*) \
	 $(wildcard Controllers/*.m) \
	 MC/xdelta/xdelta3.c \
	 CC/Toast/UIView+Toast.m \
	 $(wildcard MC/adapters/librup/*.c) \
	 MC/patched_flips_cli.cpp


$(APPLICATION_NAME)_FRAMEWORKS = UIKit CoreGraphics QuartzCore MobileCoreServices




$(APPLICATION_NAME)_LIBRARIES = c++
$(APPLICATION_NAME)_CFLAGS = -fobjc-arc -Wno-unused-function 



CCFLAGS += -std=c++11 

include $(THEOS_MAKE_PATH)/application.mk

package::
	packages/deb2ipa.sh
