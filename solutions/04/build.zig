pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zlib = b.addStaticLibrary(.{
        .name = "z",
        .target = target,
        .optimize = optimize,
    });
    zlib.addCSourceFiles(.{
        // As a handy shortcut, we can use `root` to make all paths relative to the zlib source tree!
        .root = b.path("zlib-1.3.1"),
        .files = &.{
            "compress.c",
            "inffast.c",
            "uncompr.c",
            "gzread.c",
            "inftrees.c",
            "crc32.c",
            "gzlib.c",
            "gzwrite.c",
            "deflate.c",
            "infback.c",
            "zutil.c",
            "gzclose.c",
            "inflate.c",
            "trees.c",
            "adler32.c",
        },
        .flags = &.{
            // zlib uses C89, and depends on its implicit function declarations!
            "-std=c89",
        },
    });
    zlib.linkLibC();

    b.installArtifact(zlib);
}

const std = @import("std");
