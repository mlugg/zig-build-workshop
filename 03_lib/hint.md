We want two build steps here. Both are `Compile` steps, but one builds a static
library, while the other builds an executable.

First, we'll use `addStaticLibrary` to make a step that builds a static library
from `lib.c`, by using `addCSourceFile` as before. Also, make sure to call
`linkLibC`, since the library uses libc.

By default, Zig will not put this binary in your "prefix" directory (`zig-out` by
default). The result of a step is only placed here if you use `installArtifact`.
You could use that here, but we actually don't need to: the static library is a
detail of the compilation, and so not something we need to copy to the prefix!

Next, we'll use `addExecutable` to make a step that builds our final binary. Use
`addCSourceFile` as normal to add `main.c`. Then, use `linkLibrary` to link to
the result of your other build step. Remember to call `linkLibC` on this step
too, so that libc is actually linked into the final binary. Since we want this
binary to end up in the prefix directory, make sure to call `installArtifact`!
