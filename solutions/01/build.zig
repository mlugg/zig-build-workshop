pub fn build(b: *std.Build) void {
    // Allow the user to override the build target.
    // e.g. -Dtarget=x86_64-windows
    // Default: native
    const target = b.standardTargetOptions(.{});

    // Allow the user to override the optimization mode.
    // e.g. -Dtarget=ReleaseFast
    // Default: Debug
    const optimize = b.standardOptimizeOption(.{});

    // Create a `Compile` step to build an executable.
    const exe = b.addExecutable(.{
        .name = "hello",
        .target = target,
        .optimize = optimize,
    });

    // Add the `hello.c` file to the compilation.
    exe.addCSourceFile(.{
        // This is a `LazyPath` relative to the directory this build script is in.
        .file = b.path("hello.c"),
    });

    // Make sure we have libc available!
    // There is also `linkLibCpp` for C++ programs.
    exe.linkLibC();

    // "Install" the compiled binary to our prefix directory.
    // This is `zig-out/` by default, but can be overriden with the `-p path/to/prefix` option.
    b.installArtifact(exe);
}

const std = @import("std");
