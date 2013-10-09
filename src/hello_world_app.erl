-module(hello_world_app).
-behaviour(application).

-export([
    start/2,
    stop/1
]).

%% public
start(_Type, _Args) ->
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/:resource", toppage_handler, []}
		]}
	]),
	{ok, _} = cowboy:start_http(http, 100, [{port, 8080}], [
		{env, [{dispatch, Dispatch}]}
	]),
	hello_world_sup:start_link().

stop(_State) ->
	ok.
