%% Feel free to use, reuse and abuse the code in this file.

%% @doc Hello world handler.
-module(get_order_cache).

-export([init/2]).

init(Req0, Opts) ->
    Qs = cowboy_req:parse_qs(Req0),
    Req = cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/plain">>
	}, <<"Hello world!">>, Req0),
	{ok, Req, Opts}.
