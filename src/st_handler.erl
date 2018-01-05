-module(st_handler).

-export([init/2]).

init(Req0 = #{method := <<"POST">>}, State) ->
	{ok, LongUrl, Req1} = cowboy_req:read_body(Req0),
	{ok, Random} = st_db:save(LongUrl),
	ShortUrl = erlang:iolist_to_binary([<<"http://localhost:8080/">>, Random]),
	Req2 = cowboy_req:reply(200,
		#{<<"content-type">> => <<"text/plain">>}, 
		ShortUrl, Req1),
    {ok, Req2, State};
init(Req0 = #{method := <<"GET">>}, State) ->
	case cowboy_req:binding(shortenurl, Req0) of
		undefined ->
			Req = cowboy_req:reply(404, #{
        	<<"content-type">> => <<"text/plain">>
    		}, <<"Not Found!">>, Req0),
    		{ok, Req, State};
		ShortUrl ->
			{ok, LongUrl} = st_db:get(ShortUrl),
			Req1 = cowboy_req:reply(200,
			#{<<"content-type">> => <<"text/plain">>}, 
			LongUrl, Req0),
			{ok, Req1, State}
	end;
init(Req0, State) ->
    Req = cowboy_req:reply(400, #{
        <<"content-type">> => <<"text/plain">>
    }, <<"Bad request!">>, Req0),
    {ok, Req, State}.
