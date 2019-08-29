################################################################################
#
# Common variables for the gcc-initial and gcc-final packages.
#
################################################################################

#
# Version, site and source
#

WPEWEBKIT_GCC_VERSION = 6.4.0
WPEWEBKIT_GCC_SITE = $(BR2_GNU_MIRROR:/=)/gcc/gcc-$(WPEWEBKIT_GCC_VERSION)
WPEWEBKIT_GCC_SOURCE = gcc-$(WPEWEBKIT_GCC_VERSION).tar.xz

#
# Xtensa special hook
#

HOST_WPEWEBKIT_GCC_XTENSA_OVERLAY_TAR = $(BR2_XTENSA_OVERLAY_DIR)/xtensa_$(call qstrip,$(BR2_XTENSA_CORE_NAME)).tar

define HOST_WPEWEBKIT_GCC_XTENSA_OVERLAY_EXTRACT
	tar xf $(HOST_WPEWEBKIT_GCC_XTENSA_OVERLAY_TAR) -C $(@D) --strip-components=1 gcc
endef

#
# Apply patches
#

ifeq ($(ARCH),powerpc)
ifneq ($(BR2_SOFT_FLOAT),)
define HOST_WPEWEBKIT_GCC_APPLY_POWERPC_PATCH
	$(APPLY_PATCHES) $(@D) package/gcc/$(WPEWEBKIT_GCC_VERSION) 1000-powerpc-link-with-math-lib.patch.conditional
endef
endif
endif

# gcc is a special package, not named gcc, but gcc-initial and
# gcc-final, but patches are nonetheless stored in package/gcc in the
# tree, and potentially in BR2_GLOBAL_PATCH_DIR directories as well.
define HOST_WPEWEBKIT_GCC_APPLY_PATCHES
	for patchdir in \
	    package/gcc/$(WPEWEBKIT_GCC_VERSION) \
	    $(addsuffix /gcc/$(WPEWEBKIT_GCC_VERSION),$(call qstrip,$(BR2_GLOBAL_PATCH_DIR))) \
	    $(addsuffix /gcc,$(call qstrip,$(BR2_GLOBAL_PATCH_DIR))) ; do \
		if test -d $${patchdir}; then \
			$(APPLY_PATCHES) $(@D) $${patchdir} \*.patch || exit 1; \
		fi; \
	done
	$(HOST_WPEWEBKIT_GCC_APPLY_POWERPC_PATCH)
endef

HOST_WPEWEBKIT_GCC_EXCLUDES = \
	libjava/* libgo/* \
	gcc/testsuite/* libstdc++-v3/testsuite/*

define HOST_WPEWEBKIT_GCC_FAKE_TESTSUITE
	mkdir -p $(@D)/libstdc++-v3/testsuite/
	echo "all:" > $(@D)/libstdc++-v3/testsuite/Makefile.in
	echo "install:" >> $(@D)/libstdc++-v3/testsuite/Makefile.in
endef

#
# Create 'build' directory and configure symlink
#

define HOST_WPEWEBKIT_GCC_CONFIGURE_SYMLINK
	mkdir -p $(@D)/build
	ln -sf ../configure $(@D)/build/configure
endef

#
# Common configuration options
#

HOST_WPEWEBKIT_GCC_COMMON_DEPENDENCIES = \
	host-binutils \
	host-gmp \
	host-mpc \
	host-mpfr \
	$(if $(BR2_BINFMT_FLAT),host-elf2flt)

HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS = \
	--prefix=$(HOST_DIR)/opt \
	--target=$(GNU_TARGET_NAME) \
	--with-sysroot=$(STAGING_DIR) \
	--disable-__cxa_atexit \
	--with-gnu-ld \
	--disable-libssp \
	--disable-multilib \
	--with-gmp=$(HOST_DIR)/opt \
	--with-mpc=$(HOST_DIR)/opt \
	--with-mpfr=$(HOST_DIR)/opt \
	--with-pkgversion="Buildroot $(BR2_VERSION_FULL)" \
	--with-bugurl="http://bugs.buildroot.net/"

# Don't build documentation. It takes up extra space / build time,
# and sometimes needs specific makeinfo versions to work
HOST_WPEWEBKIT_GCC_COMMON_CONF_ENV = \
	MAKEINFO=missing

WPEWEBKIT_GCC_COMMON_TARGET_CFLAGS = $(TARGET_CFLAGS)
WPEWEBKIT_GCC_COMMON_TARGET_CXXFLAGS = $(TARGET_CXXFLAGS)

# Propagate options used for target software building to GCC target libs
HOST_WPEWEBKIT_GCC_COMMON_CONF_ENV += CFLAGS_FOR_TARGET="$(WPEWEBKIT_GCC_COMMON_TARGET_CFLAGS)"
HOST_WPEWEBKIT_GCC_COMMON_CONF_ENV += CXXFLAGS_FOR_TARGET="$(WPEWEBKIT_GCC_COMMON_TARGET_CXXFLAGS)"

# libitm needs sparc V9+
ifeq ($(BR2_sparc_v8)$(BR2_sparc_leon3),y)
HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS += --disable-libitm
endif

# libmpx uses secure_getenv and struct _libc_fpstate not present in musl
ifeq ($(BR2_TOOLCHAIN_BUILDROOT_MUSL)$(BR2_TOOLCHAIN_GCC_AT_LEAST_6),yy)
HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS += --disable-libmpx
endif

# quadmath support requires wchar
ifeq ($(BR2_USE_WCHAR)$(BR2_TOOLCHAIN_HAS_LIBQUADMATH),yy)
HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS += --enable-libquadmath
else
HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS += --disable-libquadmath
endif

# libsanitizer requires wordexp, not in default uClibc config. Also
# doesn't build properly with musl.
ifeq ($(BR2_TOOLCHAIN_BUILDROOT_UCLIBC)$(BR2_TOOLCHAIN_BUILDROOT_MUSL),y)
HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS += --disable-libsanitizer
endif

# libsanitizer is broken for SPARC
# https://bugs.busybox.net/show_bug.cgi?id=7951
ifeq ($(BR2_sparc)$(BR2_sparc64),y)
HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS += --disable-libsanitizer
endif

# TLS support is not needed on uClibc/no-thread and
# uClibc/linux-threads, otherwise, for all other situations (glibc,
# musl and uClibc/NPTL), we need it.
ifeq ($(BR2_TOOLCHAIN_BUILDROOT_UCLIBC)$(BR2_PTHREADS)$(BR2_PTHREADS_NONE),yy)
HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS += --disable-tls
else
HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS += --enable-tls
endif

ifeq ($(BR2_GCC_ENABLE_LTO),y)
HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS += --enable-plugins --enable-lto
endif

ifeq ($(BR2_GCC_ENABLE_LIBMUDFLAP),y)
HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS += --enable-libmudflap
else
HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS += --disable-libmudflap
endif

ifeq ($(BR2_PTHREADS_NONE),y)
HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS += \
	--disable-threads \
	--disable-libitm \
	--disable-libatomic
else
HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS += --enable-threads
endif

ifeq ($(BR2_GCC_ENABLE_GRAPHITE),y)
HOST_WPEWEBKIT_GCC_COMMON_DEPENDENCIES += host-isl
HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS += --with-isl=$(HOST_DIR)/usr
else
HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS += --without-isl --without-cloog
endif

ifeq ($(BR2_SOFT_FLOAT),y)
# only mips*-*-*, arm*-*-* and sparc*-*-* accept --with-float
# powerpc seems to be needing it as well
ifeq ($(BR2_arm)$(BR2_armeb)$(BR2_mips)$(BR2_mipsel)$(BR2_mips64)$(BR2_mips64el)$(BR2_powerpc)$(BR2_sparc),y)
HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS += --with-float=soft
endif
endif

ifeq ($(BR2_GCC_SUPPORTS_FINEGRAINEDMTUNE),y)
HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS += --disable-decimal-float
endif

# Determine arch/tune/abi/cpu options
ifeq ($(BR2_GCC_ARCH_HAS_CONFIGURABLE_DEFAULTS),y)
ifneq ($(call qstrip,$(BR2_GCC_TARGET_ARCH)),)
HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS += --with-arch=$(BR2_GCC_TARGET_ARCH)
endif
ifneq ($(call qstrip,$(BR2_GCC_TARGET_ABI)),)
HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS += --with-abi=$(BR2_GCC_TARGET_ABI)
endif
ifneq ($(call qstrip,$(BR2_GCC_TARGET_CPU)),)
ifneq ($(call qstrip,$(BR2_GCC_TARGET_CPU_REVISION)),)
HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS += --with-cpu=$(call qstrip,$(BR2_GCC_TARGET_CPU)-$(BR2_GCC_TARGET_CPU_REVISION))
else
HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS += --with-cpu=$(call qstrip,$(BR2_GCC_TARGET_CPU))
endif
endif

WPEWEBKIT_GCC_TARGET_FPU = $(call qstrip,$(BR2_GCC_TARGET_FPU))
ifneq ($(WPEWEBKIT_GCC_TARGET_FPU),)
HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS += --with-fpu=$(WPEWEBKIT_GCC_TARGET_FPU)
endif

WPEWEBKIT_GCC_TARGET_FLOAT_ABI = $(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))
ifneq ($(WPEWEBKIT_GCC_TARGET_FLOAT_ABI),)
HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS += --with-float=$(WPEWEBKIT_GCC_TARGET_FLOAT_ABI)
endif

WPEWEBKIT_GCC_TARGET_MODE = $(call qstrip,$(BR2_GCC_TARGET_MODE))
ifneq ($(WPEWEBKIT_GCC_TARGET_MODE),)
HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS += --with-mode=$(WPEWEBKIT_GCC_TARGET_MODE)
endif
endif # BR2_GCC_ARCH_HAS_CONFIGURABLE_DEFAULTS

# Enable proper double/long double for SPE ABI
ifeq ($(BR2_powerpc_SPE),y)
HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS += \
	--enable-e500_double \
	--with-long-double-128
endif

# PowerPC64 big endian by default uses the elfv1 ABI, and PowerPC 64
# little endian by default uses the elfv2 ABI. However, musl has
# decided to use the elfv2 ABI for both, so we force the elfv2 ABI for
# Power64 big endian when the selected C library is musl.
ifeq ($(BR2_TOOLCHAIN_USES_MUSL)$(BR2_powerpc64),yy)
HOST_WPEWEBKIT_GCC_COMMON_CONF_OPTS += \
	--with-abi=elfv2 \
	--without-long-double-128
endif

HOST_WPEWEBKIT_GCC_COMMON_TOOLCHAIN_WRAPPER_ARGS += -DBR_CROSS_PATH_SUFFIX='".br_real"'
ifeq ($(BR2_GCC_ARCH_HAS_CONFIGURABLE_DEFAULTS),)
ifeq ($(call qstrip,$(BR2_GCC_TARGET_CPU_REVISION)),)
HOST_WPEWEBKIT_GCC_COMMON_WRAPPER_TARGET_CPU := $(call qstrip,$(BR2_GCC_TARGET_CPU))
else
HOST_WPEWEBKIT_GCC_COMMON_WRAPPER_TARGET_CPU := $(call qstrip,$(BR2_GCC_TARGET_CPU)-$(BR2_GCC_TARGET_CPU_REVISION))
endif
HOST_WPEWEBKIT_GCC_COMMON_WRAPPER_TARGET_ARCH := $(call qstrip,$(BR2_GCC_TARGET_ARCH))
HOST_WPEWEBKIT_GCC_COMMON_WRAPPER_TARGET_ABI := $(call qstrip,$(BR2_GCC_TARGET_ABI))
HOST_WPEWEBKIT_GCC_COMMON_WRAPPER_TARGET_FPU := $(call qstrip,$(BR2_GCC_TARGET_FPU))
HOST_WPEWEBKIT_GCC_COMMON_WRAPPER_TARGET_FLOAT_ABI := $(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))
HOST_WPEWEBKIT_GCC_COMMON_WRAPPER_TARGET_MODE := $(call qstrip,$(BR2_GCC_TARGET_MODE))

ifneq ($(HOST_WPEWEBKIT_GCC_COMMON_WRAPPER_TARGET_ARCH),)
HOST_WPEWEBKIT_GCC_COMMON_TOOLCHAIN_WRAPPER_ARGS += -DBR_ARCH='"$(HOST_WPEWEBKIT_GCC_COMMON_WRAPPER_TARGET_ARCH)"'
endif
ifneq ($(HOST_WPEWEBKIT_GCC_COMMON_WRAPPER_TARGET_CPU),)
HOST_WPEWEBKIT_GCC_COMMON_TOOLCHAIN_WRAPPER_ARGS += -DBR_CPU='"$(HOST_WPEWEBKIT_GCC_COMMON_WRAPPER_TARGET_CPU)"'
endif
ifneq ($(HOST_WPEWEBKIT_GCC_COMMON_WRAPPER_TARGET_ABI),)
HOST_WPEWEBKIT_GCC_COMMON_TOOLCHAIN_WRAPPER_ARGS += -DBR_ABI='"$(HOST_WPEWEBKIT_GCC_COMMON_WRAPPER_TARGET_ABI)"'
endif
ifneq ($(HOST_WPEWEBKIT_GCC_COMMON_WRAPPER_TARGET_FPU),)
HOST_WPEWEBKIT_GCC_COMMON_TOOLCHAIN_WRAPPER_ARGS += -DBR_FPU='"$(HOST_WPEWEBKIT_GCC_COMMON_WRAPPER_TARGET_FPU)"'
endif
ifneq ($(HOST_WPEWEBKIT_GCC_COMMON_WRAPPER_TARGET_FLOATABI_),)
HOST_WPEWEBKIT_GCC_COMMON_TOOLCHAIN_WRAPPER_ARGS += -DBR_FLOAT_ABI='"$(HOST_WPEWEBKIT_GCC_COMMON_WRAPPER_TARGET_FLOATABI_)"'
endif
ifneq ($(HOST_WPEWEBKIT_GCC_COMMON_WRAPPER_TARGET_MODE),)
HOST_WPEWEBKIT_GCC_COMMON_TOOLCHAIN_WRAPPER_ARGS += -DBR_MODE='"$(HOST_WPEWEBKIT_GCC_COMMON_WRAPPER_TARGET_MODE)"'
endif
endif # !BR2_GCC_ARCH_HAS_CONFIGURABLE_DEFAULTS

# For gcc-initial, we need to tell gcc that the C library will be
# providing the ssp support, as it can't guess it since the C library
# hasn't been built yet.
#
# For gcc-final, the gcc logic to detect whether SSP support is
# available or not in the C library is not working properly for
# uClibc, so let's be explicit as well.
HOST_WPEWEBKIT_GCC_COMMON_MAKE_OPTS = \
	gcc_cv_libc_provides_ssp=$(if $(BR2_TOOLCHAIN_HAS_SSP),yes,no)

ifeq ($(BR2_CCACHE),y)
HOST_WPEWEBKIT_GCC_COMMON_CCACHE_HASH_FILES += $(DL_DIR)/$(GCC_SOURCE)

# Cfr. PATCH_BASE_DIRS in .stamp_patched, but we catch both versioned
# and unversioned patches unconditionally. Moreover, to facilitate the
# addition of gcc patches in BR2_GLOBAL_PATCH_DIR, we allow them to be
# stored in a sub-directory called 'gcc' even if it's not technically
# the name of the package.
HOST_WPEWEBKIT_GCC_COMMON_CCACHE_HASH_FILES += \
	$(sort $(wildcard \
		package/wpewebkit-gcc/$(WPEWEBKIT_GCC_VERSION)/*.patch \
		$(addsuffix /$($(PKG)_RAWNAME)/$(WPEWEBKIT_GCC_VERSION)/*.patch,$(call qstrip,$(BR2_GLOBAL_PATCH_DIR))) \
		$(addsuffix /$($(PKG)_RAWNAME)/*.patch,$(call qstrip,$(BR2_GLOBAL_PATCH_DIR))) \
		$(addsuffix /wpewebkit-gcc/$(WPEWEBKIT_GCC_VERSION)/*.patch,$(call qstrip,$(BR2_GLOBAL_PATCH_DIR))) \
		$(addsuffix /wpewebkit-gcc/*.patch,$(call qstrip,$(BR2_GLOBAL_PATCH_DIR)))))
ifeq ($(BR2_xtensa),y)
HOST_WPEWEBKIT_GCC_COMMON_CCACHE_HASH_FILES += $(HOST_GCC_XTENSA_OVERLAY_TAR)
endif
ifeq ($(ARCH),powerpc)
ifneq ($(BR2_SOFT_FLOAT),)
HOST_WPEWEBKIT_GCC_COMMON_CCACHE_HASH_FILES += package/wpewebkit-gcc/$(WPEWEBKIT_GCC_VERSION)/1000-powerpc-link-with-math-lib.patch.conditional
endif
endif

# _CONF_OPTS contains some references to the absolute path of $(HOST_DIR)
# and a reference to the Buildroot git revision (BR2_VERSION_FULL),
# so substitute those away.
HOST_WPEWEBKIT_GCC_COMMON_TOOLCHAIN_WRAPPER_ARGS += -DBR_CCACHE_HASH=\"`\
	printf '%s\n' $(subst $(HOST_DIR),@HOST_DIR@,\
		$(subst --with-pkgversion="Buildroot $(BR2_VERSION_FULL)",,$($(PKG)_CONF_OPTS))) \
		| sha256sum - $(HOST_WPEWEBKIT_GCC_COMMON_CCACHE_HASH_FILES) \
		| cut -c -64 | tr -d '\n'`\"
endif # BR2_CCACHE

# The LTO support in gcc creates wrappers for ar, ranlib and nm which load
# the lto plugin. These wrappers are called *-gcc-ar, *-gcc-ranlib, and
# *-gcc-nm and should be used instead of the real programs when -flto is
# used. However, we should not add the toolchain wrapper for them, and they
# match the *cc-* pattern. Therefore, an additional case is added for *-ar,
# *-ranlib and *-nm.
# According to gfortran manpage, it supports all options supported by gcc, so
# add gfortran to the list of the program called via the Buildroot wrapper.
# Avoid that a .br_real is symlinked a second time.
# Also create <arch>-linux-<tool> symlinks.
define HOST_WPEWEBKIT_GCC_INSTALL_WRAPPER_AND_SIMPLE_SYMLINKS
	$(Q)cd $(HOST_DIR)/opt/bin; \
	for i in $(GNU_TARGET_NAME)-*; do \
		case "$$i" in \
		*.br_real) \
			;; \
		*-ar|*-ranlib|*-nm) \
			ln -snf $$i $(ARCH)-linux$${i##$(GNU_TARGET_NAME)}; \
			;; \
		*cc|*cc-*|*++|*++-*|*cpp|*-gfortran) \
			rm -f $$i.br_real; \
			mv $$i $$i.br_real; \
			ln -sf toolchain-wrapper $$i; \
			ln -sf toolchain-wrapper $(ARCH)-linux$${i##$(GNU_TARGET_NAME)}; \
			ln -snf $$i.br_real $(ARCH)-linux$${i##$(GNU_TARGET_NAME)}.br_real; \
			;; \
		*) \
			ln -snf $$i $(ARCH)-linux$${i##$(GNU_TARGET_NAME)}; \
			;; \
		esac; \
	done

endef

