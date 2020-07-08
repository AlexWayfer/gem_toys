# frozen_string_literal: true

require_relative 'lib/gem_toys/version'

Gem::Specification.new do |spec|
	spec.name        = 'gem_toys'
	spec.version     = GemToys::VERSION
	spec.authors     = ['Alexander Popov']
	spec.email       = ['alex.wayfer@gmail.com']

	spec.summary     = 'Toys template for gems'
	spec.description = <<~DESC
		Toys template for gems, like building, releasing, etc.
	DESC
	spec.license = 'MIT'

	spec.required_ruby_version = '>= 2.5'

	source_code_uri = 'https://github.com/AlexWayfer/gem_toys'

	spec.homepage = source_code_uri

	spec.metadata['source_code_uri'] = source_code_uri

	spec.metadata['homepage_uri'] = spec.homepage

	spec.metadata['changelog_uri'] =
		'https://github.com/AlexWayfer/gem_toys/blob/master/CHANGELOG.md'

	spec.files = Dir['lib/**/*.rb', 'README.md', 'LICENSE.txt', 'CHANGELOG.md']

	spec.add_development_dependency 'pry-byebug', '~> 3.9'

	spec.add_development_dependency 'bundler', '~> 2.0'
	spec.add_development_dependency 'toys', '~> 0.10.0'

	spec.add_development_dependency 'codecov', '~> 0.1.0', '< 0.1.18'
	spec.add_development_dependency 'rspec', '~> 3.9'
	spec.add_development_dependency 'simplecov', '~> 0.18.0'

	spec.add_development_dependency 'rubocop', '~> 0.86.0'
	spec.add_development_dependency 'rubocop-performance', '~> 1.0'
	spec.add_development_dependency 'rubocop-rspec', '~> 1.0'
end
