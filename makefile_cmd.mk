
#----------#----------#----------#----------#----------#

ifdef OS
	MAKE=make
	CC=gcc
	AR=ar
	RANLIB=ranlib
	RM=del /Q
else ifeq ($(shell uname), Linux)
	MAKE=make
	CC=gcc
	AR=ar
	RANLIB=ranlib
	RM=rm -f
endif

#----------#----------#----------#----------#----------#

CFLAGS:=-Wall -Wextra $(filter-out -w -Wall -Wextra -Werror,$(CFLAGS))
CFLAGS:=-O2 $(filter-out -O -O1 -O2 -O3 -Os,$(CFLAGS))
CFLAGS:=$(filter-out -g,$(CFLAGS))

#----------#----------#----------#----------#----------#
