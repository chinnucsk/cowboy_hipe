-module(toppage_handler).

-export([
    init/3,
    handle/2,
    terminate/3
]).

%% public
init(_Transport, Req, []) ->
	{ok, Req, undefined}.

handle(Req, State) ->
    {Method, Req2} = cowboy_req:method(Req),
    {Resource, Req3} = cowboy_req:binding(resource, Req2),
    route(Method, Resource, Req3, State).

terminate(_Reason, _Req, _State) ->
	ok.

%% private
route(<<"GET">>, <<"hello_world">>, Req, State) ->
	{ok, Req2} = cowboy_req:reply(200, [], <<"Hello world!">>, Req),
	{ok, Req2, State};
route(Method, Resource, Req, State) ->
    io:format("404: ~p ~p~n", [Method, Resource]),
	{ok, Req2} = cowboy_req:reply(404, [], [], Req),
	{ok, Req2, State}.
