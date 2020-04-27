################################################################################
#
# cog
#
################################################################################

COG_VERSION = 0.6.0
COG_SITE = https://wpewebkit.org/releases
COG_SOURCE = cog-$(COG_VERSION).tar.xz
COG_INSTALL_STAGING = YES
COG_DEPENDENCIES = dbus wpewebkit libinput
COG_LICENSE = MIT
COG_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
COG_DEPENDENCIES += wpebackend-rdk
COG_CONF_OPTS = \
	-DCOG_BUILD_PROGRAMS=ON \
	-DCOG_PLATFORM_FDO=OFF \
	-DCOG_PLATFORM_DRM=OFF \
	-DCOG_HOME_URI='$(call qstrip,$(BR2_PACKAGE_COG_PROGRAMS_HOME_URI))'
define COG_LAUNCHER
	$(INSTALL) -D -m 0755 package/cog/wpe-rpi3 $(TARGET_DIR)/usr/bin/wpe
	$(INSTALL) -D -m 0644 package/cog/websettings.cfg $(TARGET_DIR)/root
endef
else
COG_DEPENDENCIES += wpebackend-fdo
COG_CONF_OPTS = \
	-DCOG_BUILD_PROGRAMS=ON \
	-DCOG_PLATFORM_FDO=OFF \
	-DCOG_PLATFORM_DRM=ON \
	-DCOG_HOME_URI='$(call qstrip,$(BR2_PACKAGE_COG_PROGRAMS_HOME_URI))'
define COG_LAUNCHER
	$(INSTALL) -D -m 0755 package/cog/wpe-rpi4 $(TARGET_DIR)/usr/bin/wpe
	$(INSTALL) -D -m 0644 package/cog/websettings.cfg $(TARGET_DIR)/root
endef
endif


COG_POST_INSTALL_TARGET_HOOKS += COG_LAUNCHER

$(eval $(cmake-package))
