XEN_ROOT = $(CURDIR)/../..

include $(XEN_ROOT)/Config.mk

SRC_CODE += ./include/tiny_private.h

OBJS=main.o ./tiny-vmi/tiny_test.o
# SRC_CODE += main.c ./tiny-vmi/tiny_test.c
# OBJS += ./tiny-vmi/driver/xen/tiny_xen.o 
OBJS += ./tiny-vmi/tiny_cache.o ./tiny-vmi/mem_cache.o

OBJS += ./tiny-vmi/accessors.o  

OBJS += ./tiny-vmi/tiny_kv2p.o  

OBJS += ./tiny-vmi/tiny_vmi_init.o 

OBJS += ./tiny-vmi/tiny_read.o 
OBJS += ./tiny-vmi/read.o 

OBJS += ./tiny-vmi/tiny_GetVaOfVetorInIDT.o

OB_drivers = ./tiny-vmi/driver/driver_interface.o 

OBJS += $(OB_drivers)


OB_xc = ./tiny-vmi/driver/xen/libxc_wrapper.o
OB_xs = ./tiny-vmi/driver/xen/libxs_wrapper.o
OB_xen = ./tiny-vmi/driver/xen/xen.o

OB_arch = ./tiny-vmi/arch/arch_interface.o
OB_arch += ./tiny-vmi/arch/amd64.o
OB_arch += ./tiny-vmi/arch/arm_aarch32.o
OB_arch += ./tiny-vmi/arch/arm_aarch64.o
OB_arch += ./tiny-vmi/arch/intel.o


OB_arch += ./tiny-vmi/os/linux/core.o
OB_arch += ./tiny-vmi/os/linux/memory.o
OB_arch += ./tiny-vmi/os/linux/symbols.o


# OB_arch += ./tiny-vmi/os/windows/core.o
# OB_arch += ./tiny-vmi/os/windows/kdbg.o
# OB_arch += ./tiny-vmi/os/windows/memory.o
# OB_arch += ./tiny-vmi/os/windows/preparse.o
# OB_arch += ./tiny-vmi/os/windows/process.o
# OB_arch += ./tiny-vmi/os/windows/symbols.o
# OB_arch += ./tiny-vmi/os/windows/unicode.o

OB_config += ./tiny-vmi/config/grammar.o


OBJS += $(OB_xc) $(OB_xs) $(OB_xen) $(OB_arch) $(OB_config)

OBJS += ./tiny-vmi/driver/file/file.o

OBJS += ./tiny-vmi/memory.o
OBJS += ./tiny-vmi/tiny_core.o
OBJS += ./tiny-vmi/convenience.o

OB_glib += ./tiny-vmi/tiny_glib/hash.o
OB_glib += ./tiny-vmi/tiny_glib/list.o
OB_glib += ./tiny-vmi/tiny_glib/slist.o
OB_glib += ./tiny-vmi/tiny_glib/hashtable.o
# OB_glib += ./tiny-vmi/tiny_glib.o

OBJS += $(OB_glib)

OBJS += ./tiny-vmi/tiny_test.o

# CFLAGS += -I /usr/include	# for <fnmatch.h>

CFLAGS += -I../libxc-$(XEN_TARGET_ARCH)/include 
CFLAGS += -I../libs-$(XEN_TARGET_ARCH)/call/include
CFLAGS += -I../libs-$(XEN_TARGET_ARCH)/devicemodel/include
CFLAGS += -I../libs-$(XEN_TARGET_ARCH)/evtchn/include
CFLAGS += -I../libs-$(XEN_TARGET_ARCH)/foreignmemory/include
CFLAGS += -I../libs-$(XEN_TARGET_ARCH)/gnttab/include
CFLAGS += -I../libs-$(XEN_TARGET_ARCH)/toollog/include
CFLAGS += -I$(CURDIR)/include
CFLAGS += -I$(CURDIR)/tiny-vmi
# CFLAGS += -I$(CROSS_PREFIX)/$(GNU_TARGET_ARCH)-xen-elf/include 

# CFLAGS += -DENABLE_XEN=1 

# TARGET_CPPFLAGS += -isystem $(CURDIR)/libxc-$(XEN_TARGET_ARCH)/include #added 2018.03.05, lele
# TARGET_CPPFLAGS += -isystem $(CURDIR)/libs-$(XEN_TARGET_ARCH)/call/include #added 2018.03.05, lele
# TARGET_CPPFLAGS += -isystem $(CURDIR)/libs-$(XEN_TARGET_ARCH)/devicemodel/include #added 2018.03.05, lele
# TARGET_CPPFLAGS += -isystem $(CURDIR)/libs-$(XEN_TARGET_ARCH)/evtchn/include #added 2018.03.05, lele
# TARGET_CPPFLAGS += -isystem $(CURDIR)/libs-$(XEN_TARGET_ARCH)/foreignmemory/include #added 2018.03.05, lele
# TARGET_CPPFLAGS += -isystem $(CURDIR)/libs-$(XEN_TARGET_ARCH)/gnttab/include #added 2018.03.05, lele
# TARGET_CPPFLAGS += -isystem $(CURDIR)/libs-$(XEN_TARGET_ARCH)/toollog/include #added 2018.03.05, lele

# TARGET_CPPFLAGS += -I$(CURDIR)/tinyvmi/include #added 2014.10.27, lele
# TARGET_CPPFLAGS += -I$(CROSS_PREFIX)/$(GNU_TARGET_ARCH)-xen-elf/include  # added 2014.10.27

# LDFLAGS += -nostdlib -L$(CROSS_PREFIX)/$(GNU_TARGET_ARCH)-xen-elf/lib -L$(CURDIR)/xenstore -lxenstore


all: main.a 

$(OB_config): $(OB_glib)

$(OB_xen): $(OB_xc) $(OB_xs)

tiny_read.o: $(OB_xen)

$(OBJS): $(SRC_CODE)

#main.a: main.o ./tiny-vmi/tiny_test.o ./tiny-vmi/driver/xen/tiny_xen.o ./tiny-vmi/tiny_cache.o ./tiny-vmi/mem_cache.o ./tiny-vmi/tiny_kv2p.o  ./tiny-vmi/tiny_vmi_init.o ./tiny-vmi/tiny_read.o ./tiny-vmi/tiny_GetVaOfVetorInIDT.o
main.a: $(OBJS)
	$(AR) cr $@ $^

clean:
	rm -f *.a *.o *~ $(OBJS)
	make clean -C tiny-vmi
	make clean -C include









# am__libvmi_la_SOURCES_DIST = libvmi.h libvmi_extra.h slat.h x86.h \
# 	shm.h events.h peparse.h private.h debug.h glib_compat.h \
# 	rekall.h arch/arch_interface.h arch/intel.h arch/amd64.h \
# 	arch/arm_aarch32.h arch/arm_aarch64.h os/os_interface.h \
# 	driver/driver_interface.h driver/driver_wrapper.h \
# 	driver/memory_cache.h driver/file/file.h \
# 	driver/file/file_private.h driver/file/file.c driver/kvm/kvm.h \
# 	driver/kvm/kvm_private.h driver/kvm/kvm.c \
# 	driver/kvm/libvirt_wrapper.c driver/kvm/libvirt_wrapper.h \
# 	driver/kvm/kvm_shm.h driver/xen/altp2m.c \
# 	driver/xen/altp2m_private.h driver/xen/xen.h \
# 	driver/xen/xen_private.h driver/xen/xen.c \
# 	driver/xen/xen_events.c driver/xen/xen_events.h \
# 	driver/xen/xen_events_private.h driver/xen/xen_events_46.c \
# 	driver/xen/xen_events_48.c driver/xen/xen_events_legacy.c \
# 	driver/xen/libxc_wrapper.c driver/xen/libxc_wrapper.h \
# 	driver/xen/libxs_wrapper.c driver/xen/libxs_wrapper.h \
# 	os/windows/windows.h os/windows/core.c os/windows/kdbg.c \
# 	os/windows/memory.c os/windows/peparse.c os/windows/process.c \
# 	os/windows/unicode.c os/linux/linux.h os/linux/core.c \
# 	os/linux/memory.c os/linux/symbols.c accessors.c convenience.c \
# 	core.c events.c performance.c pretty_print.c read.c slat.c \
# 	strmatch.c write.c memory.c arch/arch_interface.c arch/intel.c \
# 	arch/amd64.c arch/arm_aarch32.c arch/arm_aarch64.c \
# 	driver/driver_interface.c driver/memory_cache.c \
# 	os/os_interface.c cache.c rekall.c shm.c
# am__objects_1 =
# am__objects_2 = $(am__objects_1) $(am__objects_1) $(am__objects_1)
# am__dirstamp = $(am__leading_dot)dirstamp
# am__objects_3 = driver/file/libvmi_la-file.lo
# #am__objects_4 = driver/kvm/libvmi_la-kvm.lo \
# #	driver/kvm/libvmi_la-libvirt_wrapper.lo
# am__objects_5 = driver/xen/libvmi_la-altp2m.lo \
# 	driver/xen/libvmi_la-xen.lo \
# 	driver/xen/libvmi_la-xen_events.lo \
# 	driver/xen/libvmi_la-xen_events_46.lo \
# 	driver/xen/libvmi_la-xen_events_48.lo \
# 	driver/xen/libvmi_la-xen_events_legacy.lo \
# 	driver/xen/libvmi_la-libxc_wrapper.lo \
# 	driver/xen/libvmi_la-libxs_wrapper.lo
# am__objects_6 = $(am__objects_3) $(am__objects_4) $(am__objects_1) \
# 	$(am__objects_5)
# am__objects_7 = os/windows/libvmi_la-core.lo \
# 	os/windows/libvmi_la-kdbg.lo \
# 	os/windows/libvmi_la-memory.lo \
# 	os/windows/libvmi_la-peparse.lo \
# 	os/windows/libvmi_la-process.lo \
# 	os/windows/libvmi_la-unicode.lo
# am__objects_8 = os/linux/libvmi_la-core.lo \
# 	os/linux/libvmi_la-memory.lo \
# 	os/linux/libvmi_la-symbols.lo
# am__objects_9 = $(am__objects_7) $(am__objects_8)
# am__objects_10 = libvmi_la-cache.lo
# am__objects_11 = libvmi_la-rekall.lo
# #am__objects_12 = libvmi_la-shm.lo
# am__objects_13 = libvmi_la-accessors.lo libvmi_la-convenience.lo \
# 	libvmi_la-core.lo libvmi_la-events.lo libvmi_la-performance.lo \
# 	libvmi_la-pretty_print.lo libvmi_la-read.lo libvmi_la-slat.lo \
# 	libvmi_la-strmatch.lo libvmi_la-write.lo libvmi_la-memory.lo \
# 	arch/libvmi_la-arch_interface.lo arch/libvmi_la-intel.lo \
# 	arch/libvmi_la-amd64.lo arch/libvmi_la-arm_aarch32.lo \
# 	arch/libvmi_la-arm_aarch64.lo \
# 	driver/libvmi_la-driver_interface.lo \
# 	driver/libvmi_la-memory_cache.lo os/libvmi_la-os_interface.lo \
# 	$(am__objects_10) $(am__objects_11) $(am__objects_12)
# am_libvmi_la_OBJECTS = $(am__objects_2) $(am__objects_1) \
# 	$(am__objects_6) $(am__objects_9) $(am__objects_13)
# libvmi_la_OBJECTS = $(am_libvmi_la_OBJECTS)