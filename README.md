# Using Rustler with Erlang

**[DRAFT]**

## Install Rust

You'll need to install Rust. Use rustup:

   curl https://sh.rustup.rs -sSf | sh

## Use the correct Erlang and Elixir

Assuming you've built Erlang with kerl, and Elixir with kiex (and if you
haven't, why not?):

```
$ source ~/erlang/OTP-20.3.1/activate       # kerl
$ source ~/.kiex/elixirs/elixir-1.6.4.env   # kiex
```

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
Erlang/OTP 20 [erts-9.3] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:10] [hipe] [kernel-poll:false]

Interactive Elixir (1.6.4) - press Ctrl+C to exit (type h() ENTER for help)
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

```
$ mix
Compiling NIF crate :cow_moo (native/cow_moo)...
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
```

### Loading the NIF

```
defmodule Cow.Moo do
  use Rustler, otp_app: :cow, crate: :cow_moo
end
```

`otp_app:` is the name of your Elixir application. This is usually the name you
provided to `mix new` earlier (but you could have overridden it with the
`--app` switch).

`crate:` is (obviously) the name of your crate, as chosen when running
`mix rustler.new` earlier.

### Add stub `add` function

The generated NIF exports (via `rustler_export_nifs!`) the `add` function. If you don't add a stub call in your Elixir code, you'll see the following warning when compiling:

    The on_load function for module Elixir.Cow.Moo returned {:error, {:bad_lib, 'Function not found \'Elixir.Cow.Moo\':add/2'}}

So, add the stub function.

### Try it out

```
$ iex -S mix
Erlang/OTP 20 [erts-9.3] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:10] [hipe] [kernel-poll:false]

Compiling NIF crate :cow_moo (native/cow_moo)...
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
Interactive Elixir (1.6.4) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> Cow.hello
:world
iex(2)> Cow.Moo.add 1, 2
{:ok, 3}
```

## Aside: Elixir from Erlang

```
$ ERL_LIBS=$HOME/.kiex/elixirs/elixir-1.6.4/lib/elixir/lib/:_build/dev/lib erl
Erlang/OTP 20 [erts-9.3] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:10] [hipe] [kernel-poll:false]

Eshell V9.3  (abort with ^G)
1> 'Elixir.Cow':hello().
world
2> 'Elixir.Cow.Moo':add(1, 2).
{ok,3}
```

## From Erlang, then?

### Create a new application

```
$ rebar3 new app name=coo
===> Writing coo/src/coo_app.erl
===> Writing coo/src/coo_sup.erl
===> Writing coo/src/coo.app.src
===> Writing coo/rebar.config
===> Writing coo/.gitignore
===> Writing coo/LICENSE
===> Writing coo/README.md
```

### Create the NIF module

Erlang NIFs assert that the calling module matches the expected name, so we're
going to have to name our Erlang module using Elixir conventions. For now.

```
-module('Elixir.Cow.Moo').
-on_load(on_load/0).
-export([add/2]).

-define(APPLICATION, coo).

on_load() ->
    SoPath = code:priv_dir(?APPLICATION) ++ "/native/" ++ "libcow_moo",
    LoadData = 0,
    erlang:load_nif(SoPath, LoadData).

add(_A, _B) ->
    erlang:nif_error(nif_not_loaded).
```

### Copy the Rust crate

We'll figure out how to compile it later. For now, we'll just copy it.

```
$ cd coo
$ mkdir -p priv/native
$ cp ../cow/native/cow_moo/target/debug/libcow_moo.so priv/native/
```

### Try it

```
$ rebar3 shell
===> Verifying dependencies...
===> Compiling coo
Erlang/OTP 20 [erts-9.3] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:0] [hipe] [kernel-poll:false]

Eshell V9.3  (abort with ^G)
1> 'Elixir.Cow.Moo':add(1, 2).
{ok,3}
2>
```

Well, that appears to work.

## How does it work?

### What does `use Rustler` do?

In an *Erlang* module that invokes a NIF, we have to provide an `-on_load`
attribute, and a bunch of placeholder functions.

The `use Rustler` invokes the `Rustler.__using__` macro, which results in
something like the following:

```
-on_load(on_load/0).

on_load() ->
    OtpApp = cow,
    Crate = "cow_moo",
    SoPath = code:priv_dir(OtpApp) ++ "/native/" ++ Crate,
    LoadData = 0,   % I've never used it, assume zero.
    erlang:load_nif(SoPath, LoadData).
```

Note that, in Erlang/OTP, this must be _in_ a module; it can't be invoked at
the prompt.

### What does the mix plugin do?

## Other stuff

- [rust.mk](https://github.com/goertzenator/rust.mk) -- erlang.mk plugin for
  compiling crates.
- [erlang_nif-sys](https://github.com/goertzenator/erlang_nif-sys) -- rust
  crate for creating NIFS. Rustler uses it.
