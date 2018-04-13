%%%-------------------------------------------------------------------
%% @doc myrelease top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(data_bucket_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    %redis_pool_sup:start_link(),
    %mysql_pool_sup:start_link(),
    mongo_pool_sup:start_link(),
    {ok, { {one_for_one, 5, 10},
             [{data_bucket, {data_bucket, start_link,[]}
                ,temporary, brutal_kill, worker,[data_bucket]}
            ]
        } }.

%%====================================================================
%% Internal functions
%%====================================================================
