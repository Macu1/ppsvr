-module(util).

-export([get_int/2
        ,get_string/2
        ,md5/1
        ]).

get_int(Key, List) ->
    case lists:keyfind(Key,1,List) of
        {_,Val} -> erlang:binary_to_integer(Val);
        _ -> 0
    end.

get_string(Key,List)->
    case lists:keyfind(Key,1,List) of
        {_,Val} -> erlang:binary_to_list(Val);
        _ -> ""
    end.


md5(Data) ->
    lists:flatten([io_lib:format("~2.16.0b",[D]) 
                  ||D <- binary_to_list(erlang:md5(Data))]).


