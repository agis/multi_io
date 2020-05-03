Gem::Specification.new do |s|
  s.name        = "multi_io"
  s.version     = "0.0.1.pre2"
  s.summary     = "An IO object that can be composed of other IO objects"
  s.author      = "Agis Anastasopoulos"
  s.email       = "a@xz0.org"
  s.files       = ["lib/multi_io.rb", "test/test_multi_io.rb", "LICENSE",
                   "README.md"]
  s.homepage    = "https://github.com/agis/multi_io"
  s.license     = "MIT"

  s.add_development_dependency "minitest", "~> 5.14"
  s.add_development_dependency "rake"
end
