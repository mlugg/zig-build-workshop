extern void try_add(int, int);

int main(void) {
	try_add(50, -25);
	try_add(1 << 30, 1 << 30);
	return 0;
}
