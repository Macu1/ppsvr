%% Feel free to use, reuse and abuse the code in this file.

%% @doc Hello world handler.
-module(get_id_range_handler).

-export([init/2]).

init(Req0, Opts) ->
    Qs = cowboy_req:parse_qs(Req0),
    ID = util:get_int(<<"id">>,Qs),
    {Max,Min} = id_dispatch:get_id(ID),
    Ret = jsx:encode(#{<<"min">> => Min, <<"max">> => Max}),
	Req = cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/plain">>
	}, Ret ,Req0),
	{ok, Req, Opts}.
