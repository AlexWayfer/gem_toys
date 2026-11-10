# frozen_string_literal: true

require 'yaml'
require 'open3'
require 'tmpdir'
require 'fileutils'

describe 'Release workflow' do # rubocop:disable RSpec/DescribeClass
	let(:project_directory) { Dir.mktmpdir('gem_toys_workflow') }
	let(:tag) { 'v1.2.3' }
	let(:changelog) { "## 1.2.3 (2026-11-10)\n" }
	let(:validation_script) do
		workflow = YAML.load_file(File.expand_path('../.github/workflows/release.yml', __dir__))
		workflow.fetch('jobs').fetch('verify').fetch('steps')
			.find { |step| step['name'] == 'Validate release tag and changelog' }.fetch('run')
	end
	let(:result) do
		Open3.capture3({ 'RELEASE_TAG' => tag }, 'bash', '-c', validation_script,
			chdir: project_directory)
	end

	before do
		FileUtils.mkdir_p(File.join(project_directory, 'lib', 'gem_toys'))
		File.write(File.join(project_directory, 'lib', 'gem_toys', 'version.rb'),
			"module GemToys; VERSION = '1.2.3'; end\n")
		File.write(File.join(project_directory, 'CHANGELOG.md'), changelog)
	end

	after { FileUtils.remove_entry(project_directory) }

	it 'accepts a tag matching the version and dated changelog' do
		expect(result.last).to be_success
	end

	context 'when the tag differs from the gem version' do
		let(:tag) { 'v1.2.4' }

		it 'stops the release' do
			expect(result.last.exitstatus).to eq(1)
		end

		it 'reports the mismatched tag' do
			expect(result[1]).to include('Tag does not match gem version')
		end
	end

	context 'when the changelog has no dated release entry' do
		let(:changelog) { "## Unreleased\n" }

		it 'stops the release' do
			expect(result.last.exitstatus).to eq(1)
		end

		it 'reports the missing entry' do
			expect(result[1]).to include('Missing dated changelog entry')
		end
	end
end
