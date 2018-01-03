-module(redis_do).

-export([get/1
        ,incr/1
        ]).

get(Key)->
    squery(["GET",Key]).

incr(Key) ->
    squery(["incr",Key]).



squery(Param) ->
    F = fun(Worker)-> eredis:q(Worker,Param) end,
    poolboy:transaction(redis_pool, F).


