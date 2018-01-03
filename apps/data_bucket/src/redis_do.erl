-module(redis_do).

-export([get/1]).

get(Key)->
    squery(["GET",Key]).



squery(Param) ->
    F = fun(Worker)-> gen_server:call(Worker,{squery,Param}) end,
    poolboy:transaction(redis_pool, F).


