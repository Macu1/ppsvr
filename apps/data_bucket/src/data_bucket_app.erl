%%%-------------------------------------------------------------------
%% @doc myrelease public API
%% @end
%%%-------------------------------------------------------------------

-module(data_bucket_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    data_bucket_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================