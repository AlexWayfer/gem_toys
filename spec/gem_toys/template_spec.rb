# frozen_string_literal: true

require 'tmpdir'
require 'fileutils'

describe GemToys::Template do
	let(:template_options) { { version_file_path: version_file_path } }
	let(:project_directory) { Dir.mktmpdir('gem_toys') }
	let(:version_file_path) { File.join(project_directory, 'version.rb') }
	let(:changelog_file_path) { File.join(project_directory, 'CHANGELOG.md') }
	let(:release_context) do
		options = template_options
		template_class = described_class
		source = Toys::SourceSpec.block(context_directory: project_directory) do
			expand template_class, **options
		end
		Toys::CLI.new.add_source(source).load_tool('gem', 'release', 'patch') { |context| context }
	end

	def gem_file_path
		File.join(project_directory, 'pkg', "#{File.basename(project_directory)}-1.1.1.gem")
	end

	after { FileUtils.remove_entry(project_directory) }

	before do
		File.write(version_file_path, "VERSION = '1.1.0'\n")
		File.write(changelog_file_path, "# Changelog\n\n## Unreleased\n\n*   Changes.\n")
		allow(release_context).to receive(:wait_for_manual_check) do
			release_context.clear_memery_cache! :current_version
		end
		allow(release_context).to receive(:exec_tool)
		allow(release_context).to receive(:process_git)
		allow(release_context).to receive(:sh)
		release_context.instance_exec(&release_context[Toys::Context::Key::TOOL].run_handler)
	end

	shared_examples 'release preparation' do
		it 'updates the gem version' do
			expect(File.read(version_file_path)).to include("VERSION = '1.1.1'")
		end

		it 'adds a dated changelog section' do
			expect(File.read(changelog_file_path)).to include("## 1.1.1 (#{Date.today})")
		end

		it 'builds the gem' do
			expect(release_context).to have_received(:exec_tool).with('gem build').once
		end

		it 'commits, tags, and pushes the release' do
			expect(release_context).to have_received(:process_git).once
		end
	end

	context 'with the default configuration' do
		it_behaves_like 'release preparation'

		it 'publishes the new gem' do
			expect(release_context).to have_received(:sh).with("gem push #{gem_file_path}").once
		end
	end

	context 'with publishing disabled' do
		let(:template_options) { super().merge(publish_gem: false) }

		it_behaves_like 'release preparation'

		it 'does not publish the gem locally' do
			expect(release_context).not_to have_received(:sh)
		end
	end
end
