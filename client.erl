-module(client).

-export([get_file/2, list/1, put_file/3]).

list(Server) ->
    Server ! {self(), list_dir},
    receive {Server, {ok, Files}} -> Files end.

get_file(Server, File) ->
    Server ! {self(), {get_file, File}},
    receive {Server, {ok, Content}} -> Content end.

put_file(Server, File, Content) ->
    Server ! {self(), {put_file, File, Content}},
    receive
      {Server, ok} -> ok;
      {Server, {error, Reason}} -> Reason
    end.
