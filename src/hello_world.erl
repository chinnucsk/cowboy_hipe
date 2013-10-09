-module(hello_world).

-export([
    demo/0,
    start/0
]).

-define(HOSTNAME, "127.0.0.1").
-define(PORT, 8080).

%% public
demo() ->
    [spawn(fun () -> http_get(10000) end) || _ <- lists:seq(1, 10)].

start() ->
	ok = application:start(crypto),
	ok = application:start(ranch),
	ok = application:start(cowboy),
	ok = application:start(hello_world).

%% private
http_get(N) ->
    http_get(undefined, N).

http_get(Socket, 0) ->
    gen_tcp:close(Socket);
http_get(undefined, N) ->
    {ok, Socket} = gen_tcp:connect(?HOSTNAME, ?PORT, [binary, {packet, 0}]),
    http_get(Socket, N);
http_get(Socket, N) ->
    ok = gen_tcp:send(Socket, <<"GET /hello_world HTTP/1.1\r\nHost: 127.0.0.1:8080\r\n\r\n">>),
    receive
        {tcp, Socket, <<"HTTP/1.1 200 OK", _Rest/binary>>} ->
            http_get(Socket, N-1);
        {tcp_closed, _} ->
            http_get(undefined, N)
    end.
