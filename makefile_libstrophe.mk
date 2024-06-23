## Get the Makefile path of the current makefile
THIS_MAKEFILE_PATH:=$(abspath $(lastword $(MAKEFILE_LIST)))
$(info >>>>>>>>>>  $$THIS_MAKEFILE_PATH=$(THIS_MAKEFILE_PATH))
## Get the folder path of the current makefile
THIS_DIR:=$(patsubst %/,%,$(dir $(THIS_MAKEFILE_PATH)))
$(info >>>>>>>>>>  $$THIS_DIR=$(THIS_DIR))
## Get the folder name of the current makefile
THIS_FOLDER_NAME:=$(notdir $(THIS_DIR))
$(info >>>>>>>>>>  $$THIS_FOLDER_NAME=$(THIS_FOLDER_NAME))
#----------#----------#----------#----------#----------#

include makefile_cmd.mk

#----------#----------#----------#----------#----------#

lib_DIR:=./lib
libstrophe_A_OBJS:=$(lib_DIR)/libstrophe.a

libstrophe_DIR:=./libstrophe
libstrophe_SRC:=$(libstrophe_DIR)/src
libstrophe_INC:=-I$(libstrophe_DIR) -I$(libstrophe_SRC)

obj_DIR:=./obj
obj_libstrophe_DIR:=$(obj_DIR)/libstrophe
libstrophe_OBJS:=$(obj_libstrophe_DIR)/auth.o \
		$(obj_libstrophe_DIR)/conn.o \
		$(obj_libstrophe_DIR)/crypto.o \
		$(obj_libstrophe_DIR)/ctx.o \
		$(obj_libstrophe_DIR)/event.o \
		$(obj_libstrophe_DIR)/handler.o \
		$(obj_libstrophe_DIR)/hash.o \
		$(obj_libstrophe_DIR)/jid.o \
		$(obj_libstrophe_DIR)/md5.o \
		$(obj_libstrophe_DIR)/rand.o \
		$(obj_libstrophe_DIR)/resolver.o \
		$(obj_libstrophe_DIR)/sasl.o \
		$(obj_libstrophe_DIR)/scram.o \
		$(obj_libstrophe_DIR)/sha1.o \
		$(obj_libstrophe_DIR)/sha256.o \
		$(obj_libstrophe_DIR)/sha512.o \
		$(obj_libstrophe_DIR)/snprintf.o \
		$(obj_libstrophe_DIR)/sock.o \
		$(obj_libstrophe_DIR)/stanza.o \
		$(obj_libstrophe_DIR)/util.o \
		$(obj_libstrophe_DIR)/uuid.o \
		$(obj_libstrophe_DIR)/parser_libxml2.o \
		$(obj_libstrophe_DIR)/tls_openssl.o
## "parser_expat.o" or "parser_libxml2.o"
## "tls_openssl.o" or "tls_dummy.o" or "tls_gnutls.o" or "tls_schannel.o"
libstrophe_DBJS=$(patsubst %.o,%.o.d,$(libstrophe_OBJS))

ifdef OS
	FIX_libstrophe_A_OBJS=$(subst /,\,$(libstrophe_A_OBJS))
	FIX_libstrophe_OBJS=$(subst /,\,$(libstrophe_OBJS))
	FIX_libstrophe_DBJS=$(subst /,\,$(libstrophe_DBJS))
else ifeq ($(shell uname), Linux)
	FIX_libstrophe_A_OBJS=$(libstrophe_A_OBJS)
	FIX_libstrophe_OBJS=$(libstrophe_OBJS)
	FIX_libstrophe_DBJS=$(libstrophe_DBJS)
endif

libstrophe_CFLAGS_I  :=$(libstrophe_INC) -I/usr/include/libxml2
libstrophe_CFLAGS_D  := \
					-DPACKAGE_NAME=\"libstrophe\" \
					-DPACKAGE_TARNAME=\"libstrophe\" \
					-DPACKAGE_VERSION=\"0.10.1\" \
					-DPACKAGE_STRING=\"libstrophe\ 0.10.1\" \
					-DPACKAGE_BUGREPORT=\"jack@metajack.im\" \
					-DPACKAGE_URL=\"\" -DPACKAGE=\"libstrophe\" \
					-DVERSION=\"0.10.1\" \
					-DHAVE_STDIO_H=1 \
					-DHAVE_STDLIB_H=1 \
					-DHAVE_STRING_H=1 \
					-DHAVE_INTTYPES_H=1 \
					-DHAVE_STDINT_H=1 \
					-DHAVE_STRINGS_H=1 \
					-DHAVE_SYS_STAT_H=1 \
					-DHAVE_SYS_TYPES_H=1 \
					-DHAVE_UNISTD_H=1 \
					-DSTDC_HEADERS=1 \
					-DHAVE_DLFCN_H=1 \
					-DLT_OBJDIR=\".libs/\" \
					-DHAVE_SNPRINTF=1 \
					-DHAVE_VSNPRINTF=1 \
					-DHAVE_DECL_VA_COPY=1
libstrophe_LDFLAGS   :=
libstrophe_LIBS      :=-lxml2 -lssl -lcrypto

CFLAGS +=$(libstrophe_CFLAGS_I)
CFLAGS +=$(libstrophe_CFLAGS_D)
LDFLAGS+=$(libstrophe_LDFLAGS)
LIBS   +=$(libstrophe_LIBS)

#----------#----------#----------#----------#----------#

all: download check_folder_dir $(libstrophe_A_OBJS)
	@echo "==========|$@ END|==========";
.PHONY: all

check_folder_dir:
	@if [ ! -d "$(lib_DIR)" ]; then \
		mkdir -p $(lib_DIR) ; \
	fi;
	@if [ ! -d "$(obj_libstrophe_DIR)" ]; then \
		mkdir -p $(obj_libstrophe_DIR) ; \
	fi;
.PHONY: check_folder_dir

distclean: clean
	rm -rf $(libstrophe_DIR)
	rm -rf $(obj_libstrophe_DIR)
	@echo "==========|$@ END|==========";
.PHONY: distclean

clean:
	$(RM) $(FIX_libstrophe_A_OBJS)
	$(RM) $(FIX_libstrophe_OBJS)
	$(RM) $(FIX_libstrophe_DBJS)
	@echo "==========|$@ END|==========";
.PHONY: clean

#----------#----------#----------#----------#----------#

$(libstrophe_A_OBJS): check_folder_dir $(libstrophe_OBJS)
	$(AR) cru $@ $(libstrophe_OBJS)
	$(RANLIB) $@

$(obj_libstrophe_DIR)/%.o: $(libstrophe_SRC)/%.c
	$(CC) $(CFLAGS) -MD -MF $@.d  -c $< -o $@ $(LDFLAGS) $(LIBS)

#----------#----------#----------#----------#----------#

download: libstrophe
	@echo "==========|$@ END|==========";
.PHONY: download

libstrophe:
	@if [ ! -d "$(libstrophe_DIR)" ]; then \
		wget https://github.com/strophe/libstrophe/releases/download/0.10.1/libstrophe-0.10.1.tar.gz ; \
		tar zxvf libstrophe-0.10.1.tar.gz ; \
		mv libstrophe-0.10.1 libstrophe ; \
		patch -p0 < patch/libstrophe_sha_h.patch ; \
		patch -p0 < patch/libstrophe_configure_ac.patch ; \
		$(RM) libstrophe-0.10.1.tar.gz ; \
		$(RM) libstrophe/TODO ; \
		$(RM) libstrophe/NEWS ; \
		$(RM) libstrophe/README ; \
		$(RM) libstrophe/AUTHORS ; \
		$(RM) libstrophe/COPYING ; \
		$(RM) libstrophe/ChangeLog ; \
		$(RM) libstrophe/LICENSE.txt ; \
		$(RM) libstrophe/MIT-LICENSE.txt ; \
		$(RM) libstrophe/GPL-LICENSE.txt ; \
		$(RM) libstrophe/examples/README.md ; \
		$(RM) libstrophe/docs/footer.html ; \
		rm -rf libstrophe/docs/ ; \
	fi;
	@echo "==========|$@ END|==========";

configure: download
	@if [ ! -e $(libstrophe_DIR)/Makefile ]; then \
		cd $(libstrophe_DIR); mkdir -p m4; ACLOCAL_PATH=/usr/share/aclocal autoreconf -ivf; ./configure ; \
	fi;
	@echo "==========|$@ END|==========";
.PHONY: configure

build_configure: configure
	@if [ -e $(libstrophe_DIR)/Makefile ]; then \
		cd $(libstrophe_DIR); make -j4 ; \
	fi;
	@echo "==========|$@ END|==========";
.PHONY: build_configure

clean_configure:
	@if [ -e $(libstrophe_DIR)/Makefile ]; then \
		cd $(libstrophe_DIR); make clean; \
	fi;
	@echo "==========|$@ END|==========";
.PHONY: clean_configure

#----------#----------#----------#----------#----------#
