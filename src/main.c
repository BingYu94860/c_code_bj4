#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>



#define GET_ARGSTR(argc, argv, i) ((i < argc) ? argv[i] : "")

int main(int argc, char *argv[])
{

#if 1
	int i = 0;
	printf("argc=%d\n", argc);
	for (i = 0; i < argc; ++i) {
		printf("argv[%d]=|%s|\n", i, GET_ARGSTR(argc, argv, i));
	}
#endif

	return 0;
}
