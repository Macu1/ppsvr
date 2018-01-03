%% Feel free to use, reuse and abuse the code in this file.

%% @private
-module(web_app).
-behaviour(application).

%% API.
-export([start/2]).
-export([stop/1]).

%% API.
start(_Type, _Args) ->
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/", hello_world_handler, []},
			{"/get_id_range", get_id_range_handler, []},
            {"/set_order", set_order_cache, []},
            {"/get_order", get_order_cache, []},
			{"/index", cowboy_static, {priv_file, web, "index.html"}},
			{"/websocket", ws_handler, []},
			{"/static/[...]", cowboy_static, {priv_dir, web, "static"}}
		]}
	]),
	{ok, _} = cowboy:start_clear(http, [{port, 8848}], #{
		env => #{dispatch => Dispatch}
	}),
    web_sup:start_link().


stop(_State) ->
	ok.
