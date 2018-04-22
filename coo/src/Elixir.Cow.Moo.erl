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
