{:ok, listen} =
  :gen_tcp.listen(9001, [:binary, active: false, reuseaddr: true, ip: {0, 0, 0, 0}, packet: :raw])

IO.puts("listening on 9001")

loop = fn loop ->
  {:ok, sock} = :gen_tcp.accept(listen)
  IO.puts("accepted tcp connection")
  :gen_tcp.send(sock, "hello\n")
  :gen_tcp.close(sock)
  loop.(loop)
end

loop.(loop)
