pub fn build(b: *std.Build) void {
    // This is very similar to the build script for task 5.
    // The only real difference is that we use NASM as a dependency, and
    // use `addRunArtifact` rather than `addSystemCommand`.
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const nasm_dep = b.dependency("nasm", .{
        // We don't forward a target here, since we want to build nasm
        // for the machine running `zig build`, not for our target!

        // We hardcode the optimization mode to `ReleaseFast`, since we
        // already know that NASM is (relatively) bug-free.
        .optimize = .ReleaseFast,
    });

    const is_32bit = switch (target.result.ptrBitWidth()) {
        32 => true,
        64 => false,
        else => @panic("Unsupported target!"),
    };
    const object_format = switch (target.result.ofmt) {
        .elf => if (is_32bit) "elf32" else "elf64",
        .macho => if (is_32bit) "macho32" else "macho64",
        .coff => if (is_32bit) "win32" else "win64",
        else => @panic("Unsupported target!"),
    };

    const run_nasm = b.addRunArtifact(nasm_dep.artifact("nasm"));
    run_nasm.addArgs(&.{ "-f", object_format, "-o" });
    const assembled_object = run_nasm.addOutputFileArg("test.o");
    run_nasm.addFileArg(b.path("test.asm"));

    const exe = b.addExecutable(.{
        .name = "test",
        .target = target,
        .optimize = optimize,
    });
    exe.addCSourceFile(.{ .file = b.path("test.c") });
    exe.addObjectFile(assembled_object);
    exe.linkLibC();

    b.installArtifact(exe);
}

const std = @import("std");
