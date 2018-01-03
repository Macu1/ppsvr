%% Feel free to use, reuse and abuse the code in this file.

%% @doc Hello world handler.
-module(get_id_range_handler).

-export([init/2]).

init(Req0, Opts) ->
    {Max,Min} = id_dispatch:get_id(1),
    Ret = jsx:encode(#{<<"min">> => Min, <<"max">> => Max}),
	Req = cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/plain">>
	}, Ret ,Req0),
	{ok, Req, Opts}.
