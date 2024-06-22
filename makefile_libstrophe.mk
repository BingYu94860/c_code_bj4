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

libstrophe_A_OBJS:=./lib/libstrophe.a

libstrophe_DIR:=./libstrophe
libstrophe_SRC:=$(libstrophe_DIR)/src
libstrophe_INC:=-I$(libstrophe_DIR) -I$(libstrophe_SRC)
libstrophe_OBJS:=$(libstrophe_SRC)/auth.o \
				$(libstrophe_SRC)/conn.o \
				$(libstrophe_SRC)/crypto.o \
				$(libstrophe_SRC)/ctx.o \
				$(libstrophe_SRC)/event.o \
				$(libstrophe_SRC)/handler.o \
				$(libstrophe_SRC)/hash.o \
				$(libstrophe_SRC)/jid.o \
				$(libstrophe_SRC)/md5.o \
				$(libstrophe_SRC)/rand.o \
				$(libstrophe_SRC)/resolver.o \
				$(libstrophe_SRC)/sasl.o \
				$(libstrophe_SRC)/scram.o \
				$(libstrophe_SRC)/sha1.o \
				$(libstrophe_SRC)/sha256.o \
				$(libstrophe_SRC)/sha512.o \
				$(libstrophe_SRC)/snprintf.o \
				$(libstrophe_SRC)/sock.o \
				$(libstrophe_SRC)/stanza.o \
				$(libstrophe_SRC)/util.o \
				$(libstrophe_SRC)/uuid.o \
				$(libstrophe_SRC)/parser_libxml2.o \
				$(libstrophe_SRC)/tls_openssl.o
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
libstrophe_CFLAGS_D  :=
libstrophe_LDFLAGS   :=
libstrophe_LIBS      :=-lxml2 -lssl -lcrypto

CFLAGS +=$(libstrophe_CFLAGS_I)
CFLAGS +=$(libstrophe_CFLAGS_D)
LDFLAGS+=$(libstrophe_LDFLAGS)
LIBS   +=$(libstrophe_LIBS)

#----------#----------#----------#----------#----------#

all: libstrophe $(libstrophe_A_OBJS)
	@echo "==========|$@ END|==========";
.PHONY: all

distclean: clean
	rm -rf libstrophe/
	@echo "==========|$@ END|==========";
.PHONY: distclean

clean:
	$(RM) $(FIX_libstrophe_A_OBJS) $(FIX_libstrophe_OBJS) $(FIX_libstrophe_DBJS)
	@if [ -e $(libstrophe_DIR)/Makefile ]; then \
		cd $(libstrophe_DIR); make clean ; \
	fi;
	@echo "==========|$@ END|==========";
.PHONY: clean

#----------#----------#----------#----------#----------#

$(libstrophe_A_OBJS): $(libstrophe_OBJS)
	$(AR) cru $@ $(libstrophe_OBJS)
	$(RANLIB) $@

$(libstrophe_SRC)/%.o: $(libstrophe_SRC)/%.c
	$(CC) $(CFLAGS) -MD -MF $@.d  -c $< -o $@ $(LDFLAGS) $(LIBS)

#----------#----------#----------#----------#----------#

libstrophe:
	@if [ ! -d "libstrophe" ]; then \
		wget https://github.com/strophe/libstrophe/releases/download/0.10.1/libstrophe-0.10.1.tar.gz ; \
		tar zxvf libstrophe-0.10.1.tar.gz ; \
		mv libstrophe-0.10.1 libstrophe ; \
		patch -p0 < libstrophe_sha_h.patch ; \
		patch -p0 < libstrophe_configure_ac.patch ; \
		rm -rf libstrophe-0.10.1.tar.gz ; \
		rm -rf libstrophe/docs/ ; \
		rm -rf libstrophe/TODO ; \
		rm -rf libstrophe/NEWS ; \
		rm -rf libstrophe/README ; \
		rm -rf libstrophe/AUTHORS ; \
		rm -rf libstrophe/COPYING ; \
		rm -rf libstrophe/ChangeLog ; \
		rm -rf libstrophe/LICENSE.txt ; \
		rm -rf libstrophe/MIT-LICENSE.txt ; \
		rm -rf libstrophe/GPL-LICENSE.txt ; \
		rm -rf libstrophe/examples/README.md ; \
	fi;

configure: libstrophe
	@if [ ! -e $(libstrophe_DIR)/Makefile ]; then \
		cd $(libstrophe_DIR); mkdir -p m4; ACLOCAL_PATH=/usr/share/aclocal autoreconf -ivf; ./configure ; \
	fi;
	@if [ -e $(libstrophe_DIR)/Makefile ]; then \
		cd $(libstrophe_DIR); make ; \
	fi;
.PHONY: configure

