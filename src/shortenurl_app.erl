-module(shortenurl_app).
-behaviour(application).

-export([start/2,
         stop/1]).

start(_StartType, _StartArgs) ->
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/[:shortenurl]", st_handler, []}
		]}
	]),
	{ok, _} = cowboy:start_clear(http, [{port, 8080}], #{
		env => #{dispatch => Dispatch}
	}),
    shortenurl_sup:start_link().

stop(_State) ->
    ok.
