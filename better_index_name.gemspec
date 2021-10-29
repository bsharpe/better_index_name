# frozen_string_literal: true

require_relative "lib/better_index_name/version"

Gem::Specification.new do |spec|
  spec.name          = "better_index_name"
  spec.version       = BetterIndexName::VERSION
  spec.authors       = ["Ben Sharpe"]
  spec.email         = ["bsharpe@bsharpe.com"]

  spec.summary       = "Smarter system to get index names to fit in less than 64 characters"
  spec.description   = "Remove friction from development by having smarter index names"
  spec.homepage      = "https://github.com/bsharpe/better_index_name"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] =  "https://github.com/bsharpe/better_index_name"
  spec.metadata["changelog_uri"] =  "https://github.com/bsharpe/better_index_name/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "activerecord", ">= 5.1.7"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
