-module(mysql_pool_sup).

-behaviour(supervisor).

%% API functions
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(CHILD(Id, Mod, Type, Args), {Id, {Mod, start_link, Args},
                                     permanent, 5000, Type, [Mod]}).

%%%===================================================================
%%% API functions
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the supervisor
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever a supervisor is started using supervisor:start_link/[2,3],
%% this function is called by the new process to find out about
%% restart strategy, maximum restart frequency and child
%% specifications.
%%
%% @spec init(Args) -> {ok, {SupFlags, [ChildSpec]}} |
%%                     ignore |
%%                     {error, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->
    Name = mysql_pool,
    {ok,{SizeArg,WorkerArg}} = application:get_env(data_bucket,Name),
    PoolArgs = [{name,{local,Name}},{worker_module,mysql}]++SizeArg,
    PoolSpecs = [poolboy:child_spec(Name,PoolArgs,WorkerArg)],
    lager:error("pa:~w",[WorkerArg]),
    {ok,{{one_for_one,10,10},PoolSpecs}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
