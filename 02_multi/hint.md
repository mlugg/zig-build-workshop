You can add multiple C source files to a `Compile` step either by making
multiple calls to `addCSourceFile`, or by using `addCSourceFiles` (plural),
which takes a *slice* of arbitrarily many file paths.

After you get it building, you should observe the first line of output is
correct, but you get a bizarre error instead of the second line:
```
50 + -25 = 25
Illegal instruction
```

Plot twist: this exercise was about more than just including multiple files!

This isn't your fault! In fact, it's indicative of a bug in the C program.
Before reading any further, look at `main.c` and `foo.c` to see if you can
identify what the bug is.

The issue is that this example relies on *undefined behavior*: signed integer
overflow triggers UB in C, even if on most targets it will *typically* give
two's complement overflow behavior. This is being caught because Zig enables
Clang's Undefined Behavior Sanitizer (UBSan) by default when building C code
in Debug mode.

You're likely to hit this in practice when building C projects: since UBSan
isn't a default in most toolchains, most large codebases have accidental UB
somewhere. When this happens, the correct thing to do, of course, is to submit
a patch to the project to fix the undefined behavior. However, to temporarily
work around the issue in your build script, you can disable UBSan.

When you call `addCSourceFile` or `addCSourceFiles`, you can pass flags to the
C compiler invocation. In this case, you can pass `-fno-sanitize=undefined` to
disable UBSan. After doing this, you should be able to run `zig build` and see
the desired output.
