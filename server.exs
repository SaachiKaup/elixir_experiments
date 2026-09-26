{:ok, listen} =
  :gen_tcp.listen(8080, [:binary, active: false, reuseaddr: true, ip: {0, 0, 0, 0}, packet: :raw])

IO.puts("listening on 8080")

loop = fn loop ->
  {:ok, sock} = :gen_tcp.accept(listen)
  IO.puts("accepted connection")
  _ = :gen_tcp.recv(sock, 0)
  :gen_tcp.send(sock, "HTTP/1.1 200 OK\r\ncontent-length: 2\r\n\r\nok")
  :gen_tcp.close(sock)
  loop.(loop)
end

loop.(loop)
