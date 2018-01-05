-module(st_db).

-export([
		create/0,
		save/1,
		get/1
		]).

create() ->
	st_short_long_url = ets:new(st_short_long_url, [set, public, named_table]),
	st_long_short_url = ets:new(st_long_short_url, [set, public, named_table]),
	ok.

save(LongUrl) ->
	case exists(LongUrl) of
		{ok, Random} ->
			{ok, Random};
		{error, not_found} ->
			Random = generate_random(),
			ets:insert(st_long_short_url, {LongUrl, Random}),
			case ets:insert(st_short_long_url, {Random, LongUrl}) of
				true ->
					{ok, Random};
				_ ->
					{error, ets_insertion_error}
			end
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

exists(LongUrl) ->
	case ets:lookup(st_long_short_url, LongUrl) of
		[{LongUrl, Random}] ->
			{ok, Random};
		_ ->
			{error, not_found}
	end.