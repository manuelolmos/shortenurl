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
	case get(st_long_short_url, LongUrl) of
		{ok, Random} ->
			{ok, Random};
		{error, not_found} ->
			Random = generate_random(),
			case ets:insert(st_short_long_url, {Random, LongUrl}) of
				true ->
					case ets:insert(st_long_short_url, {LongUrl, Random}) of
						true ->
							{ok, Random};
						_ ->
							ets:delete(st_short_long_url, Random),
							{error, ets_insertion_error}
					end;
				_ ->
					{error, ets_insertion_error}
			end
	end.
	

get(Random) ->
	get(st_short_long_url, Random).

get(TableName, Key) ->
	case ets:lookup(TableName, Key) of
		[{Key, Value}] ->
			{ok, Value};
		_ ->
			{error, not_found}
	end.

generate_random() ->
	base64:encode(crypto:strong_rand_bytes(10)).
