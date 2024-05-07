# Task 03: Creating Libraries

In this task, we will generate a static library, and use it in a separate compilation.

As before, create a `build.zig` skeleton with your preferred method. Here, we'll want to
create two build steps. The first will be responsible for creating a static library from
the file `lib.c`. The second will use that static library, and link it into a final
executable, based on the file `main.c`.

Here are the parts of the build API you will need:
* To create a `Compile` step for a static library, use `addStaticLibrary`
* To create a `Compile` step for your executable, use `addExecutable` as before
* To link a library from one `Compile` step into another, use the `linkLibrary` method

That should be all you need to know. As always, check `hint.md` if you need help!
