-module(st_handler).

-export([init/2]).

init(Req0 = #{method := <<"POST">>}, State) ->
    case cowboy_req:binding(shortenurl, Req0) of
        undefined ->
            lager:error("There is no shorturl sent"),
            {ok, cowboy_req:reply(404, Req0), State};
        LongUrl ->
            {ok, Random} = st_db:save(LongUrl),
            Uri = cowboy_req:uri(Req0, #{path => undefined}),
            ShortUrl = erlang:iolist_to_binary([Uri, <<"/">>, Random]),
            Req1 = cowboy_req:reply(200,
                                    #{<<"content-type">> => <<"text/plain">>},
                                    ShortUrl, Req0),
            {ok, Req1, State}
    end;
init(Req0 = #{method := <<"GET">>}, State) ->
    case cowboy_req:binding(shortenurl, Req0) of
        undefined ->
            lager:error("There is no shorturl sent"),
            {ok, cowboy_req:reply(404, Req0), State};
        ShortUrl ->
            case st_db:get(ShortUrl) of
                {ok, LongUrl} ->
                    Req1 = cowboy_req:reply(301, 
                                            #{<<"location">> => LongUrl}, Req0),
                    {ok, Req1, State};
                {error, not_found} ->
                    lager:warning("Shorturl not found"),
                    {ok, cowboy_req:reply(404, Req0), State}
            end
    end;
init(Req0, State) ->
    {ok, cowboy_req:reply(400, Req0), State}.
