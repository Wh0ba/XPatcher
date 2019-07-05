ARCHS = arm64

#GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = iPatch



$(APPLICATION_NAME)_FILES = $(wildcard *.m) \
	 $(wildcard CC/*.m) \
	 $(wildcard MC/flips/*.c) \
	 $(wildcard MC/flips/*.cpp) \
	 $(wildcard MC/libppf/*.cc) \
	 $(wildcard MC/adapters/*.m*) \
	 $(wildcard Controllers/*.m) \
	 MC/xdelta/xdelta3.c \
	 CC/Toast/UIView+Toast.m




$(APPLICATION_NAME)_FRAMEWORKS = UIKit CoreGraphics QuartzCore MobileCoreServices




$(APPLICATION_NAME)_LIBRARIES = c++
$(APPLICATION_NAME)_CFLAGS = -fobjc-arc -Wno-unused-function



CCFLAGS += -std=c++11 

include $(THEOS_MAKE_PATH)/application.mk

package::
	packages/dab
