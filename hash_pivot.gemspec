# frozen_string_literal: true

require_relative 'lib/hash_pivot/version'

Gem::Specification.new do |spec|
  spec.name = 'hash_pivot'
  spec.version = HashPivot::VERSION
  spec.authors = ['junara']
  spec.email = ['jun5araki@gmail.com']

  spec.summary = 'Pivot hash.'
  spec.description = 'Pivot hash.'
  spec.homepage = 'https://github.com/junara/hash_pivot'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['documentation_uri'] = 'https://rubydoc.info/gems/hash_pivot'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_development_dependency 'activerecord'
  spec.add_development_dependency 'factory_bot'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-parameterized'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'rubocop-rake'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'timecop'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
