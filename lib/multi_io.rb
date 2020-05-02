class MultiIO
  # targets is one or more IO objects that operations will be forwarded to
  def initialize(*targets)
    @targets = targets
  end

  def close
    @targets.each(&:close)
    nil
  end

  # Returns the first target
  def flush
    @targets.map(&:flush).first
  end

  def puts(*args)
    @targets.each { |io| io.puts(*args) }
    nil
  end

  def read(*args)
    @targets.map { |io| io.read(*args) }
  end

  def rewind
    @targets.each(&:rewind)
    0
  end

  # Returns the sum of the bytes written
  def write(string)
    @targets.map { |io| io.write(string) }.inject(:+)
  end
end
