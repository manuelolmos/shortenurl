-module(st_db).

-export([
		create/0,
		save/1,
		get/1
		]).

create() ->
	casa = ets:new(casa, [set, public, named_table]),
	ok.

save(LongUrl) ->
	ShortUrl = generate_url(LongUrl),
	case ets:insert(casa, {ShortUrl, LongUrl}) of
		true ->
			{ok, ShortUrl};
		_ ->
			{error, ets_insertion_error}
	end.

get(ShortUrl) ->
	case ets:lookup(cas, ShortUrl) of
		[{ShortUrl, LongUrl}] ->
			{ok, LongUrl};
		_ ->
			{error, not_found}
	end.

generate_url(_LongUrl) ->
	<<"http://google.com">>.