################################################################################
#
# cog
#
################################################################################

#COG_VERSION = 0.4.0
#COG_SITE = https://wpewebkit.org/releases
#COG_SOURCE = cog-$(COG_VERSION).tar.xz
COG_VERSION = e7ff11cb31cbc8da315283670c1f2b4922e09331
COG_SITE = $(call github,igalia,cog,$(COG_VERSION))
COG_INSTALL_STAGING = YES
COG_DEPENDENCIES = dbus wpewebkit wpebackend-fdo libinput
COG_LICENSE = MIT
COG_LICENSE_FILES = COPYING
COG_CONF_OPTS = \
	-DCOG_BUILD_PROGRAMS=ON \
	-DCOG_PLATFORM_FDO=OFF \
	-DCOG_PLATFORM_DRM=ON \
	-DCOG_HOME_URI='$(call qstrip,$(BR2_PACKAGE_COG_PROGRAMS_HOME_URI))'

$(eval $(cmake-package))
