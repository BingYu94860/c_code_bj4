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

APP_EXEC:=app

APP_DIR:=.
APP_SRC:=$(APP_DIR)/src
APP_INCLUDE:=$(APP_DIR)/include
APP_INC:=-I$(APP_INCLUDE)
APP_OBJS=$(patsubst $(APP_SRC)/%.c,$(APP_SRC)/%.o,$(wildcard $(APP_SRC)/*.c))
APP_DBJS=$(patsubst $(APP_SRC)/%.c,$(APP_SRC)/%.o.d,$(wildcard $(APP_SRC)/*.c))

APP_CFLAGS_I  :=$(APP_INC)
APP_CFLAGS_D  :=
APP_LDFLAGS   :=
APP_LIBS      :=

#----------#----------#----------#----------#----------#

CFLAGS:=-Wall -Wextra $(filter-out -w -Wall -Wextra -Werror,$(CFLAGS))
CFLAGS:=-O2 $(filter-out -O -O1 -O2 -O3 -Os,$(CFLAGS))
CFLAGS:=$(filter-out -g,$(CFLAGS))

CFLAGS +=$(APP_CFLAGS_I)
CFLAGS +=$(APP_CFLAGS_D)
LDFLAGS+=$(APP_LDFLAGS)
LIBS   +=$(APP_LIBS)

#----------#----------#----------#----------#----------#

ifdef OS
	FIX_APP_EXEC=$(patsubst %,%.exe,$(subst /,\,$(APP_EXEC)))
	FIX_APP_OBJS=$(subst /,\,$(APP_OBJS))
	FIX_APP_DBJS=$(subst /,\,$(APP_DBJS))
else ifeq ($(shell uname), Linux)
	FIX_APP_EXEC=$(APP_EXEC)
	FIX_APP_OBJS=$(APP_OBJS)
	FIX_APP_DBJS=$(APP_DBJS)
endif

#----------#----------#----------#----------#----------#

ifdef OS
	CC=gcc
	RM=del /Q
else ifeq ($(shell uname), Linux)
	CC=gcc
	RM=rm -f
endif

#----------#----------#----------#----------#----------#

all: $(APP_EXEC)
	@echo "==========|$@ END|==========";
.PHONY: all

#----------#----------#----------#----------#----------#

$(APP_EXEC): $(APP_OBJS)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) $(LIBS)

$(APP_SRC)/%.o: $(APP_SRC)/%.c
	$(CC) $(CFLAGS) -MD -MF $@.d  -c $< -o $@ $(LDFLAGS) $(LIBS)

%.o: %.c
	$(CC) $(CFLAGS) -MD -MF $@.d  -c $< -o $@ $(LDFLAGS) $(LIBS)

#----------#----------#----------#----------#----------#

clean:
	$(RM) $(FIX_APP_EXEC) $(FIX_APP_OBJS) $(FIX_APP_DBJS)
	@echo "==========|$@ END|==========";
.PHONY: clean

#----------#----------#----------#----------#----------#

