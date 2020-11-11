# frozen_string_literal: true

require 'toys-core'

require_relative 'template/common_code'

module GemToys
	## Template with gem tools, should be expanded in toys file
	class Template
		include Toys::Template

		attr_reader :version_file_path, :unreleased_title

		def initialize(version_file_path: nil, unreleased_title: '## master (unreleased)')
			@version_file_path = version_file_path
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

						puts_versions [
							rubygems_versions.find(
								-> { { number: current_version, created_at: 'unreleased' } }
							) do |rubygems_version|
								rubygems_version[:number] == current_version
							end
						]
					end
				end

				require_relative 'template/releases'
				expand Template::Releases

				require_relative 'template/release'
				expand Template::Release,
					version_file_path: template.version_file_path,
					unreleased_title: template.unreleased_title
			end
		end
	end
end
