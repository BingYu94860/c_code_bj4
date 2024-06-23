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
libexpat_A_OBJS:=$(lib_DIR)/libexpat.a

libexpat_DIR:=./libexpat
libexpat_SRC:=$(libexpat_DIR)/lib
libexpat_INC:=-I$(libexpat_DIR) -I$(libexpat_SRC)

obj_DIR:=./obj
obj_libexpat_DIR:=$(obj_DIR)/libexpat
libexpat_OBJS:=$(obj_libexpat_DIR)/xmlparse.o \
		$(obj_libexpat_DIR)/xmlrole.o \
		$(obj_libexpat_DIR)/xmltok.o \
## "xmltok.o" or "xmltok_impl.o" or "xmltok_ns.o"
libexpat_DBJS=$(patsubst %.o,%.o.d,$(libexpat_OBJS))

ifdef OS
	FIX_libexpat_A_OBJS=$(subst /,\,$(libexpat_A_OBJS))
	FIX_libexpat_OBJS=$(subst /,\,$(libexpat_OBJS))
	FIX_libexpat_DBJS=$(subst /,\,$(libexpat_DBJS))
else ifeq ($(shell uname), Linux)
	FIX_libexpat_A_OBJS=$(libexpat_A_OBJS)
	FIX_libexpat_OBJS=$(libexpat_OBJS)
	FIX_libexpat_DBJS=$(libexpat_DBJS)
endif

libexpat_CFLAGS_I  :=$(libexpat_INC)
libexpat_CFLAGS_D  :=-DXML_POOR_ENTROPY
libexpat_LDFLAGS   :=
libexpat_LIBS      :=

CFLAGS +=$(libexpat_CFLAGS_I)
CFLAGS +=$(libexpat_CFLAGS_D)
LDFLAGS+=$(libexpat_LDFLAGS)
LIBS   +=$(libexpat_LIBS)

#----------#----------#----------#----------#----------#

all: download check_folder_dir $(libexpat_A_OBJS)
	@echo "==========|$@ END|==========";
.PHONY: all

check_folder_dir:
	@if [ ! -d "$(lib_DIR)" ]; then \
		mkdir -p $(lib_DIR) ; \
	fi;
	@if [ ! -d "$(obj_libexpat_DIR)" ]; then \
		mkdir -p $(obj_libexpat_DIR) ; \
	fi;
.PHONY: check_folder_dir

distclean: clean
	rm -rf $(libexpat_DIR)
	rm -rf $(obj_libexpat_DIR)
	@echo "==========|$@ END|==========";
.PHONY: distclean

clean:
	$(RM) $(FIX_libexpat_A_OBJS)
	$(RM) $(FIX_libexpat_OBJS)
	$(RM) $(FIX_libexpat_DBJS)
	@echo "==========|$@ END|==========";
.PHONY: clean

#----------#----------#----------#----------#----------#

$(libexpat_A_OBJS): check_folder_dir $(libexpat_OBJS)
	$(AR) cru $@ $(libexpat_OBJS)
	$(RANLIB) $@

$(obj_libexpat_DIR)/%.o: $(libexpat_SRC)/%.c
	$(CC) $(CFLAGS) -MD -MF $@.d  -c $< -o $@ $(LDFLAGS) $(LIBS)

#----------#----------#----------#----------#----------#

download: libexpat
	@echo "==========|$@ END|==========";
.PHONY: download

libexpat:
	@if [ ! -d "$(libexpat_DIR)" ]; then \
		wget https://github.com/libexpat/libexpat/releases/download/R_2_2_10/expat-2.2.10.tar.gz ; \
		tar zxvf expat-2.2.10.tar.gz ; \
		mv expat-2.2.10 libexpat ; \
		$(RM) expat-2.2.10.tar.gz ; \
		$(RM) libexpat/README.md ; \
		$(RM) libexpat/COPYING ; \
		$(RM) libexpat/ChangeLog ; \
	fi;
	@echo "==========|$@ END|==========";

configure: download
	@if [ ! -e $(libexpat_DIR)/Makefile ]; then \
		cd $(libexpat_DIR); mkdir -p m4; ACLOCAL_PATH=/usr/share/aclocal autoreconf -ivf; ./configure ; \
	fi;
	@echo "==========|$@ END|==========";
.PHONY: configure

build_configure: configure
	@if [ -e $(libexpat_DIR)/Makefile ]; then \
		cd $(libexpat_DIR); make ; \
	fi;
	@echo "==========|$@ END|==========";
.PHONY: build_configure

clean_configure:
	@if [ -e $(libexpat_DIR)/Makefile ]; then \
		cd $(libexpat_DIR); make clean; \
	fi;
	@echo "==========|$@ END|==========";
.PHONY: clean_configure

#----------#----------#----------#----------#----------#
