pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // This solution uses the target to figure out the correct output format.
    // It's okay if your solution just hardcodes this!
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

    // Add the initial arguments, e.g. `nasm -f elf64 -o`
    const run_nasm = b.addSystemCommand(&.{
        "nasm",
        "-f",
        object_format,
        "-o",
    });
    // Add the output file, so we have `nasm -f elf64 -o zig-cache/something/test.o`
    const assembled_object = run_nasm.addOutputFileArg("test.o");
    // Add the input file, so we have `nasm -f elf64 -o zig-cache/something/test.o test.asm`
    run_nasm.addFileArg(b.path("test.asm"));

    // Now, we'll create our Compile step, and link the generated object to it.
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
