%% Feel free to use, reuse and abuse the code in this file.

%% @doc Hello world handler.
-module(set_order_cache).

-export([init/2]).

init(Req0, Opts) ->
    HasBody = cowboy_req:has_body(Req0),
    do_record_data(HasBody,Req0),
	Req = cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/plain">>
	}, <<"1">>, Req0),
	{ok, Req, Opts}.

do_record_data(false,_)-> ignore;
do_record_data(true,Req)->
    {ok,Body,_} = cowboy_req:read_body(Req),
    Vals = cow_qs:parse_qs(Body),
    Order_id = util:get_string(<<"Order_id">>, Vals),
    order_cache:set(Order_id,Body).

