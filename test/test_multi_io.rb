require "minitest/autorun"
require "multi_io"
require "tempfile"
require "socket"
require "stringio"

class MultiIOTest < Minitest::Test
  def setup
    @shared_buffer = StringIO.new
    @shared_buffer_mu = Mutex.new
  end

  def test_close
    skip("TODO")
  end

  def test_flush
    skip("TODO")
  end

  def test_puts
    tcp_server = TCPServer.new("localhost", 0)
    tcp_server_port = tcp_server.addr[1]
    tcp_server_thread = Thread.new { start_tcp_server(tcp_server) }

    targets = ios(tcp_port: tcp_server_port)

    io = MultiIO.new(*targets.keys)

    assert_nil io.puts("yo")

    io.close

    exp = "yo\n"

    targets.each do |t, actualfn|
      assert_equal exp, actualfn.call, t
    end

    tcp_server_thread.join
  end

  def test_read
    skip("TODO")
  end

  def test_rewind
    skip("TODO")
  end

  def test_write
    msg = "hi"

    tcp_server = TCPServer.new("localhost", 0)
    tcp_server_port = tcp_server.addr[1]
    tcp_server_thread = Thread.new { start_tcp_server(tcp_server, msg.bytesize) }

    targets = ios(tcp_port: tcp_server_port)

    io = MultiIO.new(*targets.keys)

    assert_equal msg.bytesize*targets.count, io.write(msg)

    io.close

    targets.each do |t, actualfn|
      assert_equal msg, actualfn.call, t
    end

    tcp_server_thread.join
  end

  private

  def ios(tcp_port:)
    stringio = StringIO.new
    file = Tempfile.create("multi_io_tmpfile", "test")

    {
      stringio             => ->{ stringio.string },
      file                 => ->{ File.read(file.path) },
      tcp_client(tcp_port) => ->{
        @shared_buffer_mu.synchronize { @shared_buffer.string }
      },
    }
  end

  # bytes is the number of bytes that the server should attempt to read.
  # If nil, it will attempt to read a whole line (i.e. until '\n').
  def start_tcp_server(server, bytes=nil)
    conn = server.accept

    @shared_buffer_mu.synchronize do
      @shared_buffer.truncate(0)

      if bytes
        @shared_buffer.write(conn.read(bytes))
      else
        @shared_buffer.write(conn.gets)
      end
    end

    conn.close
  end

  def tcp_client(port)
    5.times do
      begin
        return TCPSocket.new("localhost", port)
      rescue Errno::ECONNREFUSED
        sleep 0.2
        next
      end
    end

    raise "Server not up after 5 retries"
  end
end
