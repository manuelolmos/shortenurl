-module(st_handler).

-export([init/2]).

init(Req0 = #{method := <<"POST">>}, State) ->
	{ok, NewLongUrl, Req} = cowboy_req:read_body(Req0),
	{ok, ShortUrl} = st_db:save(NewLongUrl),
	Req = cowboy_req:reply(200,
		#{<<"content-type">> => <<"text/plain">>}, 
		ShortUrl, Req0),
    {ok, Req, State};
init(Req0, State) ->
    Req = cowboy_req:reply(200, #{
        <<"content-type">> => <<"text/plain">>
    }, <<"Nothing strange here!">>, Req0),
    {ok, Req, State}.