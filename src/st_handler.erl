-module(st_handler).

-export([init/2]).

init(Req0 = #{method := <<"POST">>}, State) ->
	{ok, LongUrl, Req1} = cowboy_req:read_body(Req0),
	{ok, Random} = st_db:save(LongUrl),
	Path = iolist_to_binary(cowboy_req:uri(Req1)),
	ShortUrl = erlang:iolist_to_binary([Path, Random]),
	Req2 = cowboy_req:reply(200,
		#{<<"content-type">> => <<"text/plain">>}, 
		ShortUrl, Req1),
    {ok, Req2, State};
init(Req0 = #{method := <<"GET">>}, State) ->
	case cowboy_req:binding(shortenurl, Req0) of
		undefined ->
			lager:error("There is no shorturl sent"),
			{ok, cowboy_req:reply(404, Req0), State};
		ShortUrl ->
			case st_db:get(ShortUrl) of
				{ok, LongUrl} ->
					Req1 = cowboy_req:reply(200,
					#{<<"content-type">> => <<"text/plain">>},
					LongUrl, Req0),
					{ok, Req1, State};
				{error, not_found} ->
					lager:warning("Shorturl not found"),
					{ok, cowboy_req:reply(404, Req0), State}
			end
	end;
init(Req0, State) ->
    {ok, cowboy_req:reply(400, Req0), State}.
