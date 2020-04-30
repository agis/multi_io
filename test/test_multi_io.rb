require "minitest/autorun"
require "multi_io"
require "tempfile"
require 'pry-byebug'

class MultiIOTest < Minitest::Test
  def test_close
    skip("TODO")
  end

  def test_flush
    skip("TODO")
  end

  def test_puts
    targets = ios

    io = MultiIO.new(*targets.keys)

    assert_nil io.puts("hi")

    io.close

    exp = "hi\n"

    targets.each do |_, actualfn|
      assert_equal exp, actualfn.call
    end
  end

  def test_read
    skip("TODO")
  end

  def test_rewind
    skip("TODO")
  end

  def test_write
    targets = ios

    io = MultiIO.new(*targets.keys)

    assert_equal 2*targets.count, io.write("hi")

    io.close

    exp = "hi"

    targets.each do |_, actualfn|
      assert_equal exp, actualfn.call
    end
  end

  private

  def ios
    stringio = StringIO.new
    file = Tempfile.create("multi_io_tmpfile", "test")

    {
      stringio => ->{ stringio.string },
      file     => ->{ File.read(file.path) },
    }
  end
end
