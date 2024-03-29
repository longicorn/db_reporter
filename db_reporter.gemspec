# frozen_string_literal: true

require_relative "lib/db_reporter/version"

Gem::Specification.new do |spec|
  spec.name = "db_reporter"
  spec.version = DbReporter::VERSION
  spec.authors = ["longicorn"]
  spec.email = ["longicorn.c@gmail.com"]

  spec.summary = "Generate Document Database"
  spec.description = "Generate Document Database"
  spec.homepage = "https://github.com/longicorn/db_reporter"
  spec.required_ruby_version = ">= 2.5.0"
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pg"
  spec.add_development_dependency "mysql2"

  spec.add_dependency "activerecord"
  spec.add_dependency "rake"
end
