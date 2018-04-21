# Using Rustler with Erlang

## Using Rustler with Elixir

### Generate a new Elixir project

```
$ mix new cow
* creating README.md
* creating .formatter.exs
* creating .gitignore
* creating mix.exs
* creating config
* creating config/config.exs
* creating lib
* creating lib/cow.ex
* creating test
* creating test/test_helper.exs
* creating test/cow_test.exs

Your Mix project was created successfully.
You can use "mix" to compile it, test it, and more:

    cd cow
    mix test

Run "mix help" for more commands.

$ cd cow/
$ mix compile
Compiling 1 file (.ex)
Generated cow app
$ iex -S mix
Erlang/OTP 19 [erts-8.3] [source] [64-bit] [smp:12:12] [async-threads:10] [hipe] [kernel-poll:false]

Interactive Elixir (1.6.3) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> Cow.hello
:world
```

### Add Rustler

    {:rustler, "~> 0.16.0"}

```
$ mix deps.get
Resolving Hex dependencies...
Dependency resolution completed:
  rustler 0.16.0
* Getting rustler (Hex package)
  Checking package (https://repo.hex.pm/tarballs/rustler-0.16.0.tar)
  Using locally cached package
roger@roger-pc:~/Source/rlipscombe/rustler-learnings/cow $ mix compile
==> rustler
Compiling 2 files (.erl)
Compiling 6 files (.ex)
Generated rustler app
==> cow
Compiling 1 file (.ex)
Generated cow app
```

### Add a NIF

```
$ mix rustler.new
This is the name of the Elixir module the NIF module will be registered to.
Module name > Cow.Moo
This is the name used for the generated Rust crate. The default is most likely fine.
Library name (cow_moo) >
* creating native/cow_moo/README.md
* creating native/cow_moo/Cargo.toml
* creating native/cow_moo/src/lib.rs
Ready to go! See cow/native/cow_moo/README.md for further instructions.
```

### Enable the :rustler mix compiler

    compilers: [:rustler] ++ Mix.compilers()

### Add configuration to `rustler_crates`

If you try to compile your project now, you'll get:

```
$ mix
** (Mix) Missing required :rustler_crates option in mix.exs.
```

So add `rustler_crates`.
