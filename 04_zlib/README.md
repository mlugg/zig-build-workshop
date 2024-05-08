# Task 04: zlib

Now that we've covered the basics, it's time for something a little more realistic.

Your task here is to build zlib, a general-purpose compression library. This will
test the knowledge you've built so far. The goal is for a static library `libz.a`
to be built and installed to the prefix directory when you run `zig build`.

Your first step should be to download the zlib sources from an *official source*.
Try to avoid mirrors and unofficial tarballs: these might be out-of-date, and worse,
you can't be sure that the author hasn't done something to them! So, download
sources from the official website, or clone the official Git repository.

Next, you should follow the basic steps in compiling any C project. You need to find
out the following:
* Which header directories need to be included?
* Which source files need to be built?
* Which external dependencies are needed?

Here's one for free: zlib has no external dependencies. The rest you must find out.

To add a header directory, you want the `addIncludePath` method on your step.

## Testing

Once you have a build of zlib, you'll need to test it. In this directory, you will find
two files `test.c` and `test.z`. `test.c` is a program which will extract the file `test.z`
into a plaintext file `test`. To test whether your library works, you can run the following
command:

```
zig run test.c zig-out/lib/libz.a -I path/to/zlib -lc
```

If all is well, you should see a file `test` with readable contents. You just built your
first real-world library using the Zig build system!
