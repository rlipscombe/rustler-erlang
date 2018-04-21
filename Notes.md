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
