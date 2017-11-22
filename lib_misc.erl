-module(lib_misc).
-compile(export_all).

keep_alive(Name, Fun) ->
	register(Name, Pid = spawn(Fun)),
	on_exit(Pid, fun(_Why) -> keep_alive(Name, Fun) end).

on_exit(Pid, Fun) ->
	spawn(fun() ->
			process_flag(trap_exit, true),
			link(Pid),
			receive
				{'EXIT', Pid, Why} ->
					Fun(Why)
			end
		end).

sleep(T) ->
	receive
	after T ->
		true
	end.

flush_buffer() ->
	receive
		_Any ->
			flush_buffer()
	after 0 ->
		true
	end.

priority_receive() ->
	receive
		{alarm, X} ->
			{alarm, X}
	after 0 ->
		receive
			Any ->
				Any
		end
	end.

sqrt(X) when X < 0 ->
	erlang:error({sqrtNegativeArgument, X});
sqrt(X) ->
	math:sqrt(X).

odds_and_evens_acc(L) ->
	odds_and_evens_acc(L, [], []).

odds_and_evens_acc([H|T], Odds, Evens) ->
	case (H rem 2) of
		1 -> odds_and_evens_acc(T, [H|Odds], Evens);
		0 -> odds_and_evens_acc(T, Odds, [H|Evens])
	end;

odds_and_evens_acc([], Odds, Evens) ->
	{lists:reverse(Odds), lists:reverse(Evens)}.


max1(X,Y) when X > Y -> X;
max1(X,Y) -> Y.

sum(L) -> sum(L, 0).
sum([], N) -> N;
sum([H|T], N) -> sum(T, H+N).

for(Max, Max, F) -> [F(Max)];
for(I, Max, F) -> [F(I)|for(I+1, Max, F)].

qsort([]) -> [];
qsort([Pivot|T]) -> qsort([X || X <- T, X < Pivot])
	++ [Pivot] ++
	qsort([X || X <- T, X>= Pivot]).

pythag(N) -> [ {A,B,C} ||
		A <- lists:seq(1,N),
		B <- lists:seq(1,N),
		C <- lists:seq(1,N),
		A+B+C =< N,
		A*A+B*B =:= C*C
		].

perms([]) -> [[]];
perms(L) -> [[H|T] || H<- L, T <- perms(L--[H])].

filter(P, [H|T]) ->
	case P(H) of
		true -> [H|filter(P, T)];
		false -> filter(P, T)
	end;
filter(P, []) -> [].


odds_and_evens(L) ->
	Odds = [X || X<-L, X rem 2=:=1],
	Evens = [X || X<-L, X rem 2=:=0],
	{Odds,Evens}.
