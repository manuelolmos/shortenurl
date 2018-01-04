-module(st_db).

-export([
		create/0,
		save/1,
		get/1
		]).

create() ->
	st_short_long_url = ets:new(st_short_long_url, [set, public, named_table]),
	ok.

save(LongUrl) ->
	Random = generate_random(),
	case ets:insert(st_short_long_url, {Random, LongUrl}) of
		true ->
			{ok, Random};
		_ ->
			{error, ets_insertion_error}
	end.

get(Random) ->
	case ets:lookup(st_short_long_url, Random) of
		[{Random, LongUrl}] ->
			{ok, LongUrl};
		_ ->
			{error, not_found}
	end.

generate_random() ->
	base64:encode(crypto:strong_rand_bytes(10)).
