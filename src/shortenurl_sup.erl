-module(shortenurl_sup).
-behaviour(supervisor).

-export([start_link/0,
         init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	ok = st_db:create(),
	lager:start(),
    {ok, { {one_for_all, 0, 1}, []} }.
