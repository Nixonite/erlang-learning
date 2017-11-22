-module(ch_8_prob_1).
-export([start/2]).

start(AnAtom, Fun) ->
    try register(AnAtom, spawn(Fun)) of
        true -> true
    catch
        error:X -> {error, X}
    end.
