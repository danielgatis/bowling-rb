# frozen_string_literal: true

require_relative "lib/bowling/version"

Gem::Specification.new do |spec|
  spec.name = "bowling"
  spec.version = Bowling::VERSION
  spec.authors = ["Daniel Gatis"]
  spec.email = ["danielgatis@gmail.com"]

  spec.summary = spec.description
  spec.description = "Bowling is a gem for parsing bowling scores."
  spec.homepage = "https://foo.com"
  spec.required_ruby_version = ">= 3.1.2"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://foo.com"
  spec.metadata["changelog_uri"] = "https://foo.com"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
