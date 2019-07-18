################################################################################
#
# wpewebkit-gcc-initial
#
################################################################################

WPEWEBKIT_GCC_INITIAL_VERSION = $(WPEWEBKIT_GCC_VERSION)
WPEWEBKIT_GCC_INITIAL_SITE = $(WPEWEBKIT_GCC_SITE)
WPEWEBKIT_GCC_INITIAL_SOURCE = $(WPEWEBKIT_GCC_SOURCE)

HOST_WPEWEBKIT_GCC_INITIAL_DEPENDENCIES = $(HOST_WPEWEBKIT_GCC_COMMON_DEPENDENCIES)

HOST_WPEWEBKIT_GCC_INITIAL_EXCLUDES = $(HOST_WPEWEBKIT_GCC_EXCLUDES)
HOST_WPEWEBKIT_GCC_INITIAL_POST_EXTRACT_HOOKS += HOST_WPEWEBKIT_GCC_FAKE_TESTSUITE

ifneq ($(call qstrip, $(BR2_XTENSA_CORE_NAME)),)
HOST_WPEWEBKIT_GCC_INITIAL_POST_EXTRACT_HOOKS += HOST_WPEWEBKIT_GCC_XTENSA_OVERLAY_EXTRACT
endif

HOST_WPEWEBKIT_GCC_INITIAL_POST_PATCH_HOOKS += HOST_WPEWEBKIT_GCC_APPLY_PATCHES

# gcc doesn't support in-tree build, so we create a 'build'
# subdirectory in the gcc sources, and build from there.
HOST_WPEWEBKIT_GCC_INITIAL_SUBDIR = build

HOST_WPEWEBKIT_GCC_INITIAL_PRE_CONFIGURE_HOOKS += HOST_WPEWEBKIT_GCC_CONFIGURE_SYMLINK

HOST_WPEWEBKIT_GCC_INITIAL_CONF_OPTS = \
	$(HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS) \
	--enable-languages=c \
	--disable-shared \
	--without-headers \
	--disable-threads \
	--with-newlib \
	--disable-largefile \
	--disable-nls \
	$(call qstrip,$(BR2_EXTRA_GCC_CONFIG_OPTIONS))

HOST_WPEWEBKIT_GCC_INITIAL_CONF_ENV = \
	$(HOST_WPEWEBKIT_GCC_COMMON_CONF_ENV)

HOST_WPEWEBKIT_GCC_INITIAL_MAKE_OPTS = $(HOST_WPEWEBKIT_GCC_COMMON_MAKE_OPTS) all-gcc
HOST_WPEWEBKIT_GCC_INITIAL_INSTALL_OPTS = install-gcc

ifeq ($(BR2_GCC_SUPPORTS_FINEGRAINEDMTUNE),y)
HOST_WPEWEBKIT_GCC_INITIAL_MAKE_OPTS += all-target-libgcc
HOST_WPEWEBKIT_GCC_INITIAL_INSTALL_OPTS += install-target-libgcc
endif

HOST_WPEWEBKIT_GCC_INITIAL_TOOLCHAIN_WRAPPER_ARGS += $(HOST_WPEWEBKIT_GCC_COMMON_TOOLCHAIN_WRAPPER_ARGS)
HOST_WPEWEBKIT_GCC_INITIAL_POST_BUILD_HOOKS += TOOLCHAIN_WRAPPER_BUILD
HOST_WPEWEBKIT_GCC_INITIAL_POST_INSTALL_HOOKS += TOOLCHAIN_WRAPPER_INSTALL
HOST_WPEWEBKIT_GCC_INITIAL_POST_INSTALL_HOOKS += HOST_WPEWEBKIT_GCC_INSTALL_WRAPPER_AND_SIMPLE_SYMLINKS

$(eval $(host-autotools-package))
