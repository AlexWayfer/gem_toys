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

			def rubygems_connection
				@rubygems_connection ||= begin
					require 'faraday'
					require 'faraday_middleware'

					Faraday.new 'https://rubygems.org/api/v1' do |conn|
						conn.response :json, parser_options: { symbolize_names: true }
					end
				end
			end

			def rubygems_versions
				@rubygems_versions ||= rubygems_connection.get("versions/#{project_name}.json").body
			end

			def puts_versions(versions)
				require 'date'

				longest_version_number = versions.map { |version| version[:number].length }.max

				versions.each do |version|
					created_at = begin
						DateTime.parse(version[:created_at]).strftime('%b %e %Y %R')
					rescue Date::Error
						version[:created_at]
					end

					puts "#{version[:number].ljust(longest_version_number)}  (#{created_at})"
				end
			end
		end
	end
end
