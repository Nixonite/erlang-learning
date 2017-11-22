-module(dolphins).
-compile(export_all).

dolphin1() ->
	receive
		do_a_flip ->
			io:format("How about no?~n");
		fish ->
			io:format("So long and thanks for all the fish!~n");
		_Else ->
			io:format("Heh, we're smarter than you humans. ~p~n", [_Else])
	end.

dolphin2() ->
	receive
		{From, do_a_flip} ->
			From ! "How about no?";
		{From, fish} ->
			From ! "So long and thanks for the fish!";
		_Else ->
			io:format("Heh, we're smarter than you humans.~n")
	end.

dolphin3() ->
	receive
		{From, do_a_flip} ->
			From ! "How about no?";
			dolphin3();
		{From, fish} ->
			From ! "So long and thanks for the fish!";
			dolphin3();
		_Else ->
			io:format("Heh, we're smarter than you humans.~n")
			dolphin3()
	end.
