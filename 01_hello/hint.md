You can use a `std.Build.Step.Compile` to compile arbitrary code, Zig and/or C, into a binary.
When you construct one with `addExecutable`, you will pass various options, including the target
to build the binary for, the Zig root source file (if any), and more.

Since we're not compiling any Zig code here, we can pass `root_source_file` as `null`. The reference
to our C source file will insted come from calling `addCSourceFile` or `addCSourceFiles` on the
returned step.

The target you will typically get from calling `standardTargetOptions`. This function allows the
build target to be specified on the command line by passing a flag such as `-Dtarget=x86_64-linux`.
If none is passed, the target defaults to "native", i.e. build for the host machine.

Similarly, there is a `standardOptimizeOption`. This exposes a CLI flag `-Doptimize=<mode>`, where
`<mode>` can be `Debug`, `ReleaseSafe`, `ReleaseFast`, or `ReleaseSmall`. The call to
`standardOptimizeOption` returns an optimization mode which can be passed into `addExecutable`
via the `optimize` field.
