###############################################################################
#
# WPELauncher
#
################################################################################

WPELAUNCHER_VERSION = d453fb9c610888e9d89e37306406344aa63432ee
WPELAUNCHER_SITE = $(call github,magomez,WPEWebKitLauncher,$(WPELAUNCHER_VERSION))

WPELAUNCHER_DEPENDENCIES = wpewebkit

define WPELAUNCHER_BINS
	$(INSTALL) -D -m 0755 package/wpe/wpelauncher/wpe $(TARGET_DIR)/usr/bin
endef

define WPELAUNCHER_AUTOSTART
	$(INSTALL) -D -m 0755 package/wpe/wpelauncher/S90wpe $(TARGET_DIR)/etc/init.d
endef

WPELAUNCHER_POST_INSTALL_TARGET_HOOKS += WPELAUNCHER_BINS

ifeq ($(BR2_PACKAGE_PLUGIN_WEBKITBROWSER),)
WPELAUNCHER_POST_INSTALL_TARGET_HOOKS += WPELAUNCHER_AUTOSTART
endif

$(eval $(cmake-package))
