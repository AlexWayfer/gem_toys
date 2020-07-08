# frozen_string_literal: true

module GemToys
	## Template with gem tools, should be expanded in toys file
	class Template
		## Module for common code between nested tools
		module CommonCode
			private

			def project_name
				@project_name ||= File.basename context_directory
			end

			def version_file_path
				@version_file_path ||=
					@template.version_file_path ||
					begin
						project_path = project_name.tr '-', '/'
						File.join context_directory, 'lib', project_path, 'version.rb'
					end
			end

			def version_file_content
				File.read version_file_path
			end

			def current_version
				@current_version ||= version_file_content.match(/VERSION = '(.+)'/)[1]
			end

			def changelog_file_path
				@changelog_file_path ||= File.join context_directory, 'CHANGELOG.md'
			end

			def gem_file_name
				@gem_file_name ||= "#{project_name}-#{current_version}.gem"
			end

			def pkg_directory
				@pkg_directory ||= "#{context_directory}/pkg"
			end

			def current_gem_file
				"#{pkg_directory}/#{gem_file_name}"
			end
		end
	end
end
