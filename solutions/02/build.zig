pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "hello",
        .target = target,
        .optimize = optimize,
    });

    // Add both source files at once.
    exe.addCSourceFiles(.{
        .files = &.{
            "main.c",
            "foo.c",
        },
        .flags = &.{
            // Since this program exhibits Undefined Behavior, we will disable UBSan to
            // allow it to function (at least, when the compiler does what we want).
            "-fno-sanitize=undefined",
        },
    });

    exe.linkLibC();
    b.installArtifact(exe);
}

const std = @import("std");
