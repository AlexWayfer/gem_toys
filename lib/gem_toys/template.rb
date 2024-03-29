# frozen_string_literal: true

require 'toys-core'

require_relative 'template/common_code'

module GemToys
	## Template with gem tools, should be expanded in toys file
	class Template
		include Toys::Template

		attr_reader :changelog_file_name, :version_file_path, :version_tag_prefix, :unreleased_title

		def initialize(
			changelog_file_name: 'CHANGELOG.md',
			version_file_path: nil,
			version_tag_prefix: 'v',
			unreleased_title: '## Unreleased'
		)
			@changelog_file_name = changelog_file_name
			@version_file_path = version_file_path
			@version_tag_prefix = version_tag_prefix
			@unreleased_title = unreleased_title
		end

		on_expand do |template|
			tool :gem do
				subtool_apply do
					unless include? :exec
						include :exec, exit_on_nonzero_status: true, log_level: Logger::UNKNOWN
					end

					include CommonCode
				end

				tool :build do
					to_run do
						@template = template

						sh 'gem build'

						require 'fileutils'
						FileUtils.mkdir_p pkg_directory
						FileUtils.mv "#{context_directory}/#{gem_file_name}", current_gem_file
					end
				end

				tool :install do
					to_run do
						@template = template

						exec_tool 'gem build'
						sh "gem install #{current_gem_file}"
					end
				end

				tool :version do
					to_run do
						@template = template

						version = rubygems_versions.find(-> { current_version_hash }) do |rubygems_version|
							rubygems_version[:number] == current_version
						end

						puts_versions [version]
					end
				end

				require_relative 'template/versions'
				expand Template::Versions,
					version_file_path: template.version_file_path

				require_relative 'template/release'
				expand Template::Release,
					changelog_file_name: template.changelog_file_name,
					version_file_path: template.version_file_path,
					version_tag_prefix: template.version_tag_prefix,
					unreleased_title: template.unreleased_title
			end
		end
	end
end
