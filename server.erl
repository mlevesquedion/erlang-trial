-module(server).

-export([loop/1, start/1]).

start(Dir) -> spawn(afile_server, loop, [Dir]).

loop(Dir) ->
    Full = fun (File) -> filename:join(Dir, File) end,
    receive
      {Client, list_dir} ->
	  Client ! {self(), file:list_dir(Dir)};
      {Client, {get_file, File}} ->
	  Client ! {self(), file:read_file(Full(File))};
      {Client, {put_file, File, Content}} ->
	  Status = file:write_file(Full(File), Content),
	  Client ! {self(), Status}
    end,
    loop(Dir).
