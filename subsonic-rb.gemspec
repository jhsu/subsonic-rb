Gem::Specification.new do |s|
    s.name          = "subsonic-rb"
    s.version       = "0.1"
    s.date          = "2011-03-24"
    s.platform      = Gem::Platform::RUBY
    s.summary       = "Subsonic music streaming api client"
    s.description   = "Interact with a subsonic music streaming server"

    s.authors  = ["Joseph Hsu"]
    s.email    = ["jhsu@josephhsu.com"]
    s.homepage = "http://github.com/jhsu/subsonic-rb"

    s.require_paths = ["lib"]
    s.files = Dir["README*", "lib/**/*"]

    s.required_ruby_version     = '>= 1.8.7'
    s.required_rubygems_version = ">= 1.3.6"
end
