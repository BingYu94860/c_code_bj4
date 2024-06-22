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

APP_EXEC:=app

APP_DIR:=.
APP_SRC:=$(APP_DIR)/src
APP_INC:=-I$(APP_DIR)/include
APP_OBJS=$(patsubst $(APP_SRC)/%.c,$(APP_SRC)/%.o,$(wildcard $(APP_SRC)/*.c))
APP_DBJS=$(patsubst $(APP_SRC)/%.c,$(APP_SRC)/%.o.d,$(wildcard $(APP_SRC)/*.c))

ifdef OS
	FIX_APP_EXEC=$(patsubst %,%.exe,$(subst /,\,$(APP_EXEC)))
	FIX_APP_OBJS=$(subst /,\,$(APP_OBJS))
	FIX_APP_DBJS=$(subst /,\,$(APP_DBJS))
else ifeq ($(shell uname), Linux)
	FIX_APP_EXEC=$(APP_EXEC)
	FIX_APP_OBJS=$(APP_OBJS)
	FIX_APP_DBJS=$(APP_DBJS)
endif

APP_CFLAGS_I  :=$(APP_INC)
APP_CFLAGS_D  :=
APP_LDFLAGS   :=
APP_LIBS      :=

CFLAGS +=$(APP_CFLAGS_I)
CFLAGS +=$(APP_CFLAGS_D)
LDFLAGS+=$(APP_LDFLAGS)
LIBS   +=$(APP_LIBS)

#----------#----------#----------#----------#----------#

all: build_libstrophe $(APP_EXEC)
	@echo "==========|$@ END|==========";
.PHONY: all

distclean: clean distclean_libstrophe
	@echo "==========|$@ END|==========";
.PHONY: distclean

clean: clean_libstrophe
	$(RM) $(FIX_APP_EXEC) $(FIX_APP_OBJS) $(FIX_APP_DBJS)
	@echo "==========|$@ END|==========";
.PHONY: clean

#----------#----------#----------#----------#----------#

build_libstrophe:
	@echo "==========|$@|==========";
	make -f makefile_libstrophe.mk
	@echo "==========|$@ END|==========";
.PHONY: build_libstrophe

distclean_libstrophe: clean_libstrophe
	@echo "==========|$@|==========";
	make distclean -f makefile_libstrophe.mk
	@echo "==========|$@ END|==========";
.PHONY: distclean_libstrophe

clean_libstrophe:
	@echo "==========|$@|==========";
	make clean -f makefile_libstrophe.mk
	@echo "==========|$@ END|==========";
.PHONY: clean_libstrophe

#----------#----------#----------#----------#----------#

$(APP_EXEC): $(APP_OBJS)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) $(LIBS)

$(APP_SRC)/%.o: $(APP_SRC)/%.c
	$(CC) $(CFLAGS) -MD -MF $@.d  -c $< -o $@ $(LDFLAGS) $(LIBS)

%.o: %.c
	$(CC) $(CFLAGS) -MD -MF $@.d  -c $< -o $@ $(LDFLAGS) $(LIBS)

#----------#----------#----------#----------#----------#
