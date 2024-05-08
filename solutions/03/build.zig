pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const my_lib = b.addStaticLibrary(.{
        .name = "my_lib",
        .target = target,
        .optimize = optimize,
    });
    my_lib.addCSourceFile(.{ .file = b.path("lib.c") });
    my_lib.linkLibC();

    const exe = b.addExecutable(.{
        .name = "hello",
        .target = target,
        .optimize = optimize,
    });
    exe.addCSourceFile(.{ .file = b.path("main.c") });
    exe.linkLibC();
    exe.linkLibrary(my_lib);

    // We only need to install the executable, since we don't care about having
    // `libmy_lib.a` be installed to the prefix directory!
    b.installArtifact(exe);
}

const std = @import("std");
