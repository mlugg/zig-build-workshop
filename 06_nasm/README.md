# Task 06: NASM

The previous task used the `nasm` installed on your system to build, but we would
like to be able to compile our program easily with minimal external dependencies.
That means it would be nice if our build script could compile NASM from source by
itself, so we can use that binary rather than depending on system NASM.

So, in this task, we will build NASM from source. To start, do what you did with
zlib: clone the sources, and see if you can figure out which source files and
include directories are needed. NASM is a fair bit more complex than zlib, so it's
okay if you need to ask for help with this one!

Something that NASM needs which zlib did not is an automatically-generated config
header. It's quite common that C codebases will perform feature detection and
generate a header defining which libc/POSIX features the target supports, whether
debug features should be enabled, etc. Zig packages do not typically need to do
feature detection, because Zig ships with Clang, so we can assume a particular
feature set. The Zig build system gives us a nice way to generate these headers
with fixed values, but first, we need to figure out what the values should be!

NASM uses GNU autoconf to generate its `config.h` file. We can use the official build
system to look at the results and use those as a base for our generated config header.

First, run `./autogen.sh` to generate `config/config.h.in`. This file lists all of the
macros which `config.h` may define - you'll want to keep it around, since the Zig build
system will want it. This *doesn't* mean you have to make your Zig build script run
`autogen.sh` - this file is the same regardless of target, so you can generate it once
and check it into your project.

Then, run `./configure` to actually generate `config/config.h`. We won't use this file in
our final build script, but it's useful to us since it contains the config used on your
system, and most of those values will be correct for all sane targets.

Let's look at how we generate this file from the build system. The function
`b.addConfigHeader` will create a step that generates a config header from a list of values
you provide. By setting `.style = .{ .autoconf = b.path("config/config.h.in") }` in the
options you pass to that function, Zig will know to use the given autoconf file as a
template. The second parameter to this function is the options to set. They are specified
using a Zig struct literal; the value can be `null` to indicate that a macro should not be
defined, or an integer, string, etc to define the macro to the corresponding value.

For instance, the following call does not define `FOO`, but defines `BAR` to 1:

```
const config_header = b.addConfigHeader(.{
    .style = .{ .autoconf = b.path("config/config.h.in") }, // template file
    .include_path = "config/config.h", // the path to the file we're generating
}, .{
    .FOO = null,
    .BAR = 1,
});
```

You can use your manually-generated `config.h` to get sane values for everything. After
that, it's a good idea to read through them (you can also use the comments in `config.h.in`
as a reference) to figure out if any should be dependant on target, optimization mode, etc.

NASM actually also requires a second config header. It's called `version.h`, and just indicates
the version of NASM. This one is not generated from an autoconf template; you can pass
`.style = .blank` to indicate this to the build system. You can generate this locally using
`make version.h` (this runs a Perl script in the NASM source tree), and again, just use
the values from this header.

After generating a config header, you can make it accessible to `Compile` steps using their
`addConfigHeader` method with the step you just created.

Hopefully that'll give you enough information to package NASM. If you get stuck, as always,
feel free to ask for help!

Once you're done, you can just try running `zig-out/bin/nasm -h`. If you get a help menu, you
probably did everything right!
