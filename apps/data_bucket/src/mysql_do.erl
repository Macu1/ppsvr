-module(mysql_do).

-export([query/1
        ,encode/1
        ]).

query(Sql) ->
    squery(Sql).

encode(Data) ->
    F= fun(MySqlConn) -> mysql:encode(MySqlConn,Data) end,
    poolboy:transaction(mysql_pool,F).


squery(Sql) ->
    F = fun(MySqlConn)-> mysql:query(MySqlConn,Sql) end,
    poolboy:transaction(mysql_pool, F).


