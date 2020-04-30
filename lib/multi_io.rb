# MultiIO aims to be an IO object that is the concatenation of other IO
# objects.
#
# This is useful, for example, when one wants to have an IO object that
# duplicates its writes to STDOUT, a file and maybe a socket too.
#
# NOTE: Not all methods from IO are implemented yet. Feel free to submit
# a patch if you need something that's missing.
class MultiIO
  def initialize(*io)
    @io = io
  end

  def close
    @io.each { |io| io.close }
    nil
  end

  def flush
    @io.map { |io| io.flush }.first
  end

  def puts(*args)
    @io.each { |io| io.puts(*args) }
    nil
  end

  def read(*args)
    @io.map { |io| io.read(*args) }
  end

  def rewind
    @io.each { |io| io.rewind }
    0
  end

  # Returns the sum of the bytes written
  def write(string)
    @io.map { |io| io.write(string) }.inject(:+)
  end
end
