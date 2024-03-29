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

	source_code_uri = 'https://github.com/AlexWayfer/gem_toys'

	spec.homepage = source_code_uri

	spec.metadata['source_code_uri'] = source_code_uri

	spec.metadata['homepage_uri'] = spec.homepage

	spec.metadata['changelog_uri'] =
		'https://github.com/AlexWayfer/gem_toys/blob/main/CHANGELOG.md'

	spec.metadata['rubygems_mfa_required'] = 'true'

	spec.files = Dir['lib/**/*.rb', 'README.md', 'LICENSE.txt', 'CHANGELOG.md']

	spec.required_ruby_version = '>= 3.0', '< 4'

	spec.add_runtime_dependency 'alt_memery', '~> 2.1'
	spec.add_runtime_dependency 'faraday', '~> 2.0'
	spec.add_runtime_dependency 'highline', '~> 3.0'
	spec.add_runtime_dependency 'toys-core', '~> 0.15.1'
end
