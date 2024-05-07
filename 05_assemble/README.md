# Task 05: Runing An Assembler

**This task requires you to have `nasm` installed.**

In this task, we'll look at how to run external commands from your build script.
Here, we'll be using the Netwide Assembler (NASM) to assemble some x86 assembly
and link the resulting artifact into a C program. This assembly could be anything,
but in order for this to be trivially cross-platform, the asm here will just declare
a global constant.

## Using NASM

You run commands using a `Run` step, which can be created with the `addSystemCommand`
method on `std.Build`. You pass an initial list of arguments to this function, and a
`Step.Run` is returned.

We could just pass the input and output file paths in this list. However, our build
script might be run from within a different directory (running `zig build` will search
parent directories until a `build.zig` is found!), so we shouldn't rely on passing
file paths directly to NASM. Instead, we use `LazyPath` to allow the build system to
pass the correct file paths as arguments to the command.

A great thing about using the build system like this is that the `Step.Run` will pick
up on the fact that you are using `LazyPath`-based arguments and automatically integrate
your step with the cache system. This means that the output of the `nasm` command will
be automatically cached based on the contents of the input file you pass!

Once you've created a `Step.Run` with the initial argument list `&.{"nasm"}`, you can
add further arguments, which can be based on `LazyPath`. The methods you'll need are:

* `addFileArg` -- add a given `LazyPath` as an argument (used for input paths).
* `addOutputFileArg` -- add a path to a file the command will write to, and return a `LazyPath` referencing that file.
* `addArg` -- add a string as an argument.

The command you're trying to construct looks like this:

```
nasm -f elf64 -o <out file> <in file>
```

If you're using macOS, replace `elf64` with `macho64`. On Windows, replace with `win64`.

The input file is `test.asm`; the output filename (passed to `addOutputFileArg`) can be
whatever you want (you probably want it to end `.o`, since it's an object file).

Once you have a `LazyPath` corresponding to the output file, you can use `b.installFile`
to install it to the prefix directory (`zig-out`). Another advantage of using `LazyPath`
here is that the build system will automatically figure out that it needs to evaluate
the `Run` step to install that file.

## Linking to a C program

Now that we're generating an object file, we want to link it to a C program. Create a
`Compile` step for a C program, and add `test.c`. Then you can use `addObjectFile` to
link your object through its `LazyPath`. Again, the build system will know through the
`LazyPath` usage that it needs to run the assembly step first.

Install the generated executable (you can remove the installation of the assembled object
if you want). You should then be able to run your generated binary and see a Hello World
output!
