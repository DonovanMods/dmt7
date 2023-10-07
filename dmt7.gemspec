# frozen_string_literal: true

require_relative "lib/dmt7/globals"

Gem::Specification.new do |spec|
  spec.name = "dmt7"
  spec.version = DMT7::VERSION
  spec.authors = [DMT7::AUTHOR]
  spec.email = ["dyoung522@gmail.com"]

  spec.summary = "Tools for modding 7 Days to Die"
  spec.homepage = "https://www.github.com/donovanmods/dmt7"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "awesome_print", "~> 1.9"
  spec.add_dependency "config", "~> 4.2"
  spec.add_dependency "nokogiri", "~> 1.15"
  spec.add_dependency "thor", "~> 1.2"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
