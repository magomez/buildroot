################################################################################
#
# WPEFramework Plugins
#
################################################################################

WPEFRAMEWORK_PLUGINS_VERSION = 87bc5a391384a6a2ab60f2163ec7d7bc3dc75949
WPEFRAMEWORK_PLUGINS_SITE = $(call github,WebPlatformForEmbedded,WPEFrameworkPlugins,$(WPEFRAMEWORK_PLUGINS_VERSION))
WPEFRAMEWORK_PLUGINS_INSTALL_STAGING = YES
WPEFRAMEWORK_PLUGINS_DEPENDENCIES = wpeframework libpng

WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DBUILD_REFERENCE=${WPEFRAMEWORK_PLUGINS_VERSION}

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_DEBUG),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DCMAKE_BUILD_TYPE=Debug
endif

# libprovision

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_COMMANDER),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_COMMANDER=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_DEVICEINFO),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_DEVICEINFO=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_DSRESOLUTION),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_DSRESOLUTION=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_DHCPSERVER),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_DHCPSERVER=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_EGLTEST),y)
WPEFRAMEWORK_COMMON_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_EGLTEST=ON
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_LOCATIONSYNC),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_LOCATIONSYNC=ON
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_LOCATIONSYNC_URI=${BR2_PACKAGE_WPEFRAMEWORK_LOCATIONSYNC_URI}
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_MONITOR),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_MONITOR=ON
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_MONITOR_WEBKIT),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_WEBKITBROWSER_MEMORYLIMIT=${BR2_PACKAGE_WPEFRAMEWORK_MONITOR_WEBKIT}
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_MONITOR_YOUTUBE),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_YOUTUBE_MEMORYLIMIT=${BR2_PACKAGE_WPEFRAMEWORK_MONITOR_YOUTUBE}
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_MONITOR_UX),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_UX_MEMORYLIMIT=${BR2_PACKAGE_WPEFRAMEWORK_MONITOR_UX}
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_MONITOR_NETFLIX),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_NETFLIX=ON
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_NETFLIX_MEMORYLIMIT=${BR2_PACKAGE_WPEFRAMEWORK_MONITOR_NETFLIX}
endif
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_NETWORKCONTROL),y)
ifeq ($(BR2_TARGET_GENERIC_NETWORK),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DPLUGIN_NETWORKCONTROL_SYSTEM_NETWORK=ON
endif
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_NETWORKCONTROL=ON
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CDMI),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_OPENCDMI=ON
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_OPENCDMI_AUTOSTART=true
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_OPENCDMI_OOP=true
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CDMI_CLEARKEY),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DPLUGIN_OPENCDMI_CLEARKEY=ON
WPEFRAMEWORK_PLUGINS_DEPENDENCIES += wpeframework-cdmi-clearkey
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CDMI_PLAYREADY),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DPLUGIN_OPENCDMI_PLAYREADY=ON
WPEFRAMEWORK_PLUGINS_DEPENDENCIES += wpeframework-cdmi-playready
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CDMI_PLAYREADY_NEXUS),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DPLUGIN_OPENCDMI_PLAYREADY_NEXUS=ON
WPEFRAMEWORK_PLUGINS_DEPENDENCIES += wpeframework-cdmi-playready-nexus
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_CDMI_WIDEVINE),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DPLUGIN_OPENCDMI_WIDEVINE=ON
WPEFRAMEWORK_PLUGINS_DEPENDENCIES += wpeframework-cdmi-widevine
endif
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_BLUETOOTH),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_BLUETOOTH=ON
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_BLUETOOTH_AUTOSTART=true
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_BLUETOOTH_OOP=true
ifeq ($(BR2_PACKAGE_PLATFORM_RASPBERRY_PI),y)
WPEFRAMEWORK_PLUGINS_POST_INSTALL_TARGET_HOOKS += WPEFRAMEWORK_COMPOSITOR_POST_TARGET_INITD
define WPEFRAMEWORK_COMPOSITOR_POST_TARGET_INITD
    mkdir -p $(TARGET_DIR)/etc/init.d
    $(INSTALL) -D -m 0755 package/wpe/wpeframework-plugins/S35WPEFrameworkBluetooth $(TARGET_DIR)/etc/init.d
endef
endif
endif

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_REMOTECONTROL),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_REMOTECONTROL=ON
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_REMOTECONTROL_DEVINPUT),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_REMOTECONTROL_DEVINPUT=ON
WPEFRAMEWORK_PLUGINS_DEPENDENCIES += udev
ifneq ($(BR2_PACKAGE_WPEFRAMEWORK_REMOTECONTROL_DEVINPUT_KEYMAP),)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_REMOTECONTROL_DEVINPUT_KEYMAP="$(call qstrip,$(BR2_PACKAGE_WPEFRAMEWORK_REMOTECONTROL_DEVINPUT_KEYMAP))"
endif
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_REMOTECONTROL_IR),y)
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_REMOTECONTROL_IRNEXUS),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_REMOTECONTROL_IRNEXUS=ON
ifneq ($(BR2_PACKAGE_WPEFRAMEWORK_REMOTECONTROL_IRNEXUS_MODE),)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_REMOTECONTROL_IRMODE="$(call qstrip,$(BR2_PACKAGE_WPEFRAMEWORK_REMOTECONTROL_IRNEXUS_MODE))"
endif
ifneq ($(BR2_PACKAGE_WPEFRAMEWORK_REMOTECONTROL_IRNEXUS_CODEMASK),)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_REMOTECONTROL_CODEMASK="$(call qstrip,$(BR2_PACKAGE_WPEFRAMEWORK_REMOTECONTROL_IRNEXUS_CODEMASK))"
endif
endif
endif
ifneq ($(BR2_TARGET_GENERIC_HOSTNAME),"buildroot")
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_REMOTECONTROL_HOST="$(call qstrip,$(BR2_TARGET_GENERIC_HOSTNAME))"
endif
ifneq ($(BR2_PACKAGE_WPEFRAMEWORK_REMOTECONTROL_KEYMAP),)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_REMOTECONTROL_KEYMAP="$(call qstrip,$(BR2_PACKAGE_WPEFRAMEWORK_REMOTECONTROL_KEYMAP))"
endif
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_SNAPSHOT),y)
WPEFRAMEWORK_PLUGINS_DEPENDENCIES += libpng
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_SNAPSHOT=ON
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_TIMESYNC),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_TIMESYNC=ON
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_TRACECONTROL),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_TRACECONTROL=ON
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_WEBKITBROWSER),y)
WPEFRAMEWORK_PLUGINS_DEPENDENCIES += wpewebkit
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_WEBKITBROWSER=ON
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_WEBKITBROWSER_AUTOSTART),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_WEBKITBROWSER_AUTOSTART=true
else
WPEFRAMEWORK_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_WEBKITBROWSER_AUTOSTART=false
endif
ifneq ($(BR2_PACKAGE_WPEFRAMEWORK_WEBKITBROWSER_STARTURL),)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_WEBKITBROWSER_STARTURL=$(BR2_PACKAGE_WPEFRAMEWORK_WEBKITBROWSER_STARTURL)
endif
ifneq ($(BR2_PACKAGE_WPEFRAMEWORK_WEBKITBROWSER_USERAGENT),)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_WEBKITBROWSER_USERAGENT=$(BR2_PACKAGE_WPEFRAMEWORK_WEBKITBROWSER_USERAGENT)
endif
ifneq ($(BR2_PACKAGE_WPEFRAMEWORK_WEBKITBROWSER_MEMORYPROFILE),)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_WEBKITBROWSER_MEMORYPROFILE=$(BR2_PACKAGE_WPEFRAMEWORK_WEBKITBROWSER_MEMORYPROFILE)
endif
ifneq ($(BR2_PACKAGE_WPEFRAMEWORK_WEBKITBROWSER_MEMORYPRESSURE),)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_WEBKITBROWSER_MEMORYPRESSURE=$(BR2_PACKAGE_WPEFRAMEWORK_WEBKITBROWSER_MEMORYPRESSURE)
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_WEBKITBROWSER_MEDIADISKCACHE),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_WEBKITBROWSER_MEDIADISKCACHE=true
endif
ifneq ($(BR2_PACKAGE_WPEFRAMEWORK_WEBKITBROWSER_DISKCACHE),)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_WEBKITBROWSER_DISKCACHE=$(BR2_PACKAGE_WPEFRAMEWORK_WEBKITBROWSER_DISKCACHE)
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_WEBKITBROWSER_XHRCACHE),)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_WEBKITBROWSER_XHRCACHE=false
endif
ifneq ($(BR2_PACKAGE_WPEFRAMEWORK_WEBKITBROWSER_CLIENTIDENTIFIER),)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_WEBKITBROWSER_CLIENTIDENTIFIER=$(BR2_PACKAGE_WPEFRAMEWORK_WEBKITBROWSER_CLIENTIDENTIFIER)
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_WEBKITBROWSER_TRANSPARENT),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_WEBKITBROWSER_TRANSPARENT=true
else
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_WEBKITBROWSER_TRANSPARENT=false
endif
ifneq ($(BR2_PACKAGE_WPEFRAMEWORK_WEBKITBROWSER_THREADEDPAINTING),)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_WEBKITBROWSER_THREADEDPAINTING=$(BR2_PACKAGE_WPEFRAMEWORK_WEBKITBROWSER_THREADEDPAINTING)
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_YOUTUBE),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_WEBKITBROWSER_YOUTUBE=ON
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_UX),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_WEBKITBROWSER_UX=ON
endif
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_WEBPROXY),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_WEBPROXY=ON
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_WEBSERVER),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_WEBSERVER=ON
ifneq ($(BR2_PACKAGE_WPEFRAMEWORK_WEBSERVER_PATH),)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_WEBSERVER_PATH=$(BR2_PACKAGE_WPEFRAMEWORK_WEBSERVER_PATH)
endif
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_WEBSHELL),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_WEBSHELL=ON
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_WIFICONTROL),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_WIFICONTROL=ON
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_TVCONTROL),y)
WPEFRAMEWORK_PLUGINS_DEPENDENCIES += sqlite
ifeq ($(BR2_PACKAGE_RPI_FIRMWARE), y)
WPEFRAMEWORK_PLUGINS_DEPENDENCIES += dvb-apps
endif
ifeq ($(BR2_PACKAGE_TVPLATFORM_BCM), y)
WPEFRAMEWORK_PLUGINS_DEPENDENCIES += wpetvplatform-bcm
else ifeq ($(BR2_PACKAGE_TVPLATFORM_LINUXTV), y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DPLUGIN_TVCONTROL_LINUXTV=ON
endif
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_TVCONTROL=ON
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGINS_TVCONTROL_FREQUENCY_LIST=$(call qstrip,$(BR2_PACKAGE_WPEFRAMEWORK_PLUGINS_TVCONTROL_FREQUENCY_LIST))

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_TVCONTROL_DVB),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_TVCONTROL_DVB=true
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGINS_TVCONTROL_COUNTRY_CODE=$(call qstrip,$(BR2_PACKAGE_WPEFRAMEWORK_PLUGINS_TVCONTROL_COUNTRY_CODE))
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGINS_TVCONTROL_COUNTRY_REGION_ID=$(call qstrip,$(BR2_PACKAGE_WPEFRAMEWORK_PLUGINS_TVCONTROL_COUNTRY_REGION_ID))

ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_TVCONTROL_ENABLE_BOUQUET_PARSING), y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_TVCONTROL_ENABLE_BOUQUET_PARSING=true
endif

ifeq ($(BR2_PACKAGE_BCM_REFSW), y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGINS_TVCONTROL_TUNE_PARAM=$(call qstrip,$(BR2_PACKAGE_WPEFRAMEWORK_PLUGINS_TVCONTROL_TUNE_PARAM))
endif
else
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_TVCONTROL_DVB=false
endif
ifneq ($(BR2_PACKAGE_WPEFRAMEWORK_TVCONTROL_DVB),y)
WPEFRAMEWORK_PLUGINS_DEPENDENCIES += dvb-apps
endif
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_RPCLINK),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_RPCLINK=ON
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_COMPOSITOR),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_COMPOSITOR=ON
ifeq ($(BR2_PACKAGE_WESTEROS),y)
WPEFRAMEWORK_PLUGINS_DEPENDENCIES += westeros
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_COMPOSITOR_IMPLEMENTATION=Wayland
else ifeq  ($(BR2_PACKAGE_BCM_REFSW),y)
WPEFRAMEWORK_PLUGINS_DEPENDENCIES += bcm-refsw
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_COMPOSITOR_IMPLEMENTATION=Nexus
else
$(error Missing a compositor implemtation, please introduce one or disable WPEFRAMEWORK_PLUGIN_COMPOSITOR)
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_COMPOSITOR_OUTOFPROCESS),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_COMPOSITOR_OUTOFPROCESS=true
else
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_COMPOSITOR_OUTOFPROCESS=false
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_COMPOSITOR_AUTOSTART),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_COMPOSITOR_AUTOSTART=true
else
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_COMPOSITOR_AUTOSTART=false
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_COMPOSITOR_NEXUS_SERVER),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_COMPOSITOR_NXSERVER=ON
ifneq ($(BR2_PACKAGE_WPEFRAMEWORK_COMPOSITOR_BOXMODE),)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_COMPOSITOR_BOXMODE="$(call qstrip,$(BR2_PACKAGE_WPEFRAMEWORK_COMPOSITOR_BOXMODE))"
endif
ifneq ($(BR2_PACKAGE_WPEFRAMEWORK_COMPOSITOR_GRAPHICS_HEAP_SIZE),)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_COMPOSITOR_GRAPHICS_HEAP_SIZE="$(call qstrip,$(BR2_PACKAGE_WPEFRAMEWORK_COMPOSITOR_GRAPHICS_HEAP_SIZE))"
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_COMPOSITOR_ALLOW_UNAUTHENTICATED_CLIENTS),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_COMPOSITOR_ALLOW_UNAUTHENTICATED_CLIENTS=false
else
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_COMPOSITOR_ALLOW_UNAUTHENTICATED_CLIENTS=true
endif
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_VIRTUALINPUT),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_COMPOSITOR_VIRTUALINPUT=ON
endif
ifeq ($(BR2_PACKAGE_WPEFRAMEWORK_REMOTECONTROL_IRNEXUS),y)
WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_COMPOSITOR_IRNEXUS_MODE=${BR2_PACKAGE_WPEFRAMEWORK_REMOTECONTROL_IRNEXUS_MODE}
endif

WPEFRAMEWORK_PLUGINS_CONF_OPTS += -DWPEFRAMEWORK_PLUGIN_COMPOSITOR_HARDWAREREADY=${BR2_PACKAGE_WPEFRAMEWORK_COMPOSITOR_HARDWAREREADY}

define WPEFRAMEWORK_COMPOSITOR_POST_TARGET_REMOVE_HEADERS
    rm -rf $(TARGET_DIR)/usr/include/WPEFramework
endef

ifneq ($(BR2_PACKAGE_WPEFRAMEWORK_INSTALL_HEADERS),y)
WPEFRAMEWORK_PLUGINS_POST_INSTALL_TARGET_HOOKS += WPEFRAMEWORK_COMPOSITOR_POST_TARGET_REMOVE_HEADERS
endif

endif

$(eval $(cmake-package))
