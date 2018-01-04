-module(st_handler).

-export([init/2]).

init(Req0 = #{method := <<"POST">>}, State) ->
	{ok, LongUrl, Req1} = cowboy_req:read_body(Req0),
	{ok, Random} = st_db:save(LongUrl),
	%% Replace url with the correct one
	ShortUrl = erlang:iolist_to_binary([<<"http://localhost:8080/">>, Random]),
	Req2 = cowboy_req:reply(200,
		#{<<"content-type">> => <<"text/plain">>}, 
		ShortUrl, Req1),
    {ok, Req2, State};
init(Req0, State) ->
    Req = cowboy_req:reply(200, #{
        <<"content-type">> => <<"text/plain">>
    }, <<"Nothing strange here!">>, Req0),
    {ok, Req, State}.
