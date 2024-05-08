#include <stdio.h>

extern void print_int(int);

int main(void) {
	puts("First print...");
	print_int(1);
	puts("Second print...");
	print_int(2);
	return 0;
}
