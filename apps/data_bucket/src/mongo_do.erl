-module(mongo_do).
-compile({nowarn_unused_function, [{wrap_default, 2}, {wrap_retries, 4}]}).
-export([find_one/2
       , find_one/3
       , find_all/2
       , find_all/3
       , find/2
       , find/3
       , count/2
       , count/3
       , delete/2
       , delete_one/2
       , delete_limit/3
       , delete_limit/4
       , insert/2
       , insert/3
       , update/3
       , update/5
       , update/6
       , ensure_index/2
       , command/1
    ]).
-define(MC_API,mc_worker_api).
-define(wrap_default(A), wrap_default( ?FUNCTION_NAME, A)).
-define(wrap_retries(A), wrap_retries( ?FUNCTION_NAME, A, 9, 3000)).


%%%============================================================================
%%% API functions
%%%============================================================================
find_one(Collection, Selector) ->
    reformat(?wrap_retries([Collection, Selector])).
find_one(Collection, Selector, Args) ->
    reformat(?wrap_retries([Collection, Selector, Args])).


find_all(Collection, Selector) ->
    case find(Collection, Selector) of
    [] -> []; {ok, Cursor} -> [_ | _]=ResultList = mc_cursor:rest(Cursor),[reformat(Result) || Result <- ResultList]
    end.
find_all( Collection, Selector, Args) ->
    case find( Collection, Selector, Args) of
    [] -> []; {ok, Cursor} -> [_ | _]=ResultList = mc_cursor:rest(Cursor),[reformat(Result) || Result <- ResultList]
    end.


find( Collection, Selector) ->
    reformat(?wrap_retries([ Collection, Selector])).
find( Collection, Selector, Args) ->
    reformat(?wrap_retries([ Collection, Selector, Args])).


count( Collection, Selector) ->
    ?wrap_retries([ Collection, Selector]).
count( Collection, Selector, Args) ->
    ?wrap_retries([ Collection, Selector, Args]).


delete(Collection, Selector) ->
    ?wrap_retries([ Collection, Selector]).
delete_one( Collection, Selector) ->
    ?wrap_retries([ Collection, Selector]).
delete_limit( Collection, Selector, N) ->
    ?wrap_retries([ Collection, Selector, N]).
delete_limit( Collection, Selector, N, WC) ->
    ?wrap_retries([ Collection, Selector, N, WC]).


insert( Collection, DocOrDocs) ->
    ?wrap_retries([ Collection, DocOrDocs]).
insert( Collection, DocOrDocs, WC) ->
    ?wrap_retries([ Collection, DocOrDocs, WC]).


update( Collection, Selector, Doc) ->
    ?wrap_retries([ Collection, Selector, Doc]).
update( Collection, Selector, Doc, Upsert, MultiUpdate) ->
    ?wrap_retries([ Collection, Selector, Doc, Upsert, MultiUpdate]).
update( Collection, Selector, Doc, Upsert, MultiUpdate, WC) ->
    ?wrap_retries([ Collection, Selector, Doc, Upsert, MultiUpdate, WC]).


ensure_index( Collection, IndexSpec) ->
    ?wrap_retries([ Collection, IndexSpec]).
command( QueryOrCommand) ->
    ?wrap_retries([ QueryOrCommand]).


%%%============================================================================
%%% Internal functions
%%%============================================================================
wrap_default( Function,  ArgRest ) ->
    poolboy:transaction(mongo_pool, fun(Worker) ->
        erlang:apply(?MC_API, Function, [Worker | ArgRest])
    end, infinity).


wrap_retries( Function,  [Coll|OtherArgs]=Arguments, Retries, Cooldown) ->
    try
        Arguments2 = if erlang:is_binary(Coll) -> Arguments;
                        true -> [erlang:list_to_binary(Coll)|OtherArgs]
                     end,
        poolboy:transaction(mongo_pool, fun(Worker) ->
            erlang:apply(?MC_API, Function, [Worker | Arguments2])
        end, infinity)
    catch Class:Reason when Retries =< 0 ->
        erlang:raise(Class, Reason, erlang:get_stacktrace());
    Class:Reason ->
        lager:warning("~p retries for: Class = ~p, Reason = ~p~nMFA = ~p"
            , [?MODULE, Class, Reason, {?MC_API, Function, Arguments}]),
        timer:sleep(Cooldown),
        wrap_retries( Function, Arguments, Retries - 1, Cooldown)
    end.

reformat(Document) when is_map(Document) ->
    maps:remove(<<"_id">>, Document);
reformat(Document) -> Document.

%-export([query/2
%        ]).
%
%query(Coll,Selector)->
%    F = fun(MC_Worker)->
%                mc_worker_api:find_one(MC_Worker,Coll,Selector)
%        end,
%    poolboy:transaction(mongo_pool,F).
