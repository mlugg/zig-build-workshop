# Task 01: Hello World

Your task here is to create a `build.zig` script to compile a C "Hello, World!" program.

Your first step to get started should probably be to run the command `zig init` in this directory.
This will generate a few files:
* `src/` directory -- contains sample Zig code. Delete this!
* `build.zig` -- this is what we're interested in. Contains logic to build the Zig code in `src/`.
* `build.zig.zon` -- not relevant for now, but will be useful later on when we look at package management!

Create a C source file (something like `main.c` or `hello.c`) which contains a Hello World implementation.
If you'd prefer to just use an existing one, an implementation exists in `../resources/01_hello.c`.

Edit your generated `build.zig` script to compile your C program into a binary. You should be able to run
`zig build` and get a working Hello World binary.

If you get stuck, take a look at `hint.md`!
