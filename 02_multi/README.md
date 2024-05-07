# Task 02: Multiple Files

This task centers around including multiple C source files in one compilation.

As before, you can run `zig init` to get a `build.zig` skeleton, or you can just copy your one
from the previous task. You don't need to copy the `build.zig.zon`, since we're not using it yet.

In the `src` directory, you will see two files: `main.c` and `foo.c`. Your goal is to include both
of these files in a single compilation. You should be able to get a binary with output matching the
following:

```
50 + -25 = 25
1073741824 + 1073741824 = -2147483648
```

If you get stuck, take a look at `hint.md`!
