multi_io
==============================================================================
[![Gem Version](https://badge.fury.io/rb/multi_io.svg)](https://badge.fury.io/rb/multi_io)
[![Build Status](https://travis-ci.org/agis/multi_io.svg?branch=master)](https://travis-ci.org/agis/multi_io)
[![License](https://img.shields.io/github/license/mashape/apistatus.svg)](LICENSE)

`MultiIO` is a Ruby [`IO`](https://ruby-doc.org/core-2.7.1/IO.html) object that
is composed of other IO objects. It is meant to be a drop-in replacement for
regular IO objects like files, sockets, stdout/stderr streams etc.

Depending on the method called, it forwards operations to the underlying
objects.

This is useful, for example, when one wants to duplicate writes to multiple destinations (e.g. standard output, a
file and a socket). Similarly, it can be used to read the concatenation of multiple IO sources.


Status
------------------------------------------------------------------------------
This is an alpha release. Not all methods from IO are implemented yet so it
can't be used in all cases as a drop-in replacement for regular IO objects.

The goal is to eventually implement the complete [`IO`](https://ruby-doc.org/core-2.7.1/IO.html)
interface.

IO methods implemented:

- `#close`
- `#flush`
- `#puts`
- `#read`
- `#rewind`
- `#write`

Feel free to submit a patch if you need something that's missing.


Usage
------------------------------------------------------------------------------

Assuming we want to duplicate writes to a string buffer, stdout and a file:

```ruby
> require "stringio"
> str = StringIO.new
> io = MultiIO.new(str, $stdout, File.new("foo", "w"))
>
> # write a message to all underlying IO objects (stdout is printed immediately
> # since it's attached to the terminal)
> io.puts "bar"
hi
> io.flush
> str.string # => "bar\n"
> File.read("foo") # => "bar\n"
```

Development
------------------------------------------------------------------------------
Running the tests:

```shell
$ bundle exec rake
```

License
--------------------------------------------------------------------------
MultiIO is licensed under MIT. See [LICENSE](LICENSE).
