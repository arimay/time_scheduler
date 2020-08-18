lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "time_scheduler/version"

Gem::Specification.new do |spec|
  spec.name          = "time_scheduler"
  spec.version       = TimeScheduler::VERSION
  spec.authors       = ["arimay"]
  spec.email         = ["arima.yasuhiro@gmail.com"]

  spec.summary       = %q{ Library for simple event scheduler. }
  spec.description   = %q{ Yet another library for single/periodical event scheduler. }
  spec.homepage      = "https://github.com/arimay/time_scheduler"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "time_cursor"

  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
