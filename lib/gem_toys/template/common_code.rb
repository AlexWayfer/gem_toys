# frozen_string_literal: true

require 'memery'

module GemToys
	## Template with gem tools, should be expanded in toys file
	class Template
		## Module for common code between nested tools
		module CommonCode
			include Memery

			private

			memoize def project_name
				File.basename context_directory
			end

			memoize def version_file_path
				@template.version_file_path ||
					begin
						project_path = project_name.tr '-', '/'
						File.join context_directory, 'lib', project_path, 'version.rb'
					end
			end

			def version_file_content
				File.read version_file_path
			end

			memoize def current_version
				parse_version_from_file
			end

			def parse_version_from_file
				version_file_content.match(/VERSION = '(.+)'/)[1]
			end

			memoize def changelog_file_path
				File.join context_directory, @template.changelog_file_name
			end

			memoize def gem_file_name
				"#{project_name}-#{current_version}.gem"
			end

			memoize def pkg_directory
				"#{context_directory}/pkg"
			end

			def current_gem_file
				"#{pkg_directory}/#{gem_file_name}"
			end

			memoize def rubygems_connection
				require 'faraday'
				require 'faraday_middleware'

				Faraday.new 'https://rubygems.org/api/v1' do |connection|
					connection.response :json,
						content_type: /\bjson$/,
						parser_options: { symbolize_names: true }
				end
			end

			memoize def rubygems_versions
				response = rubygems_connection.get("versions/#{project_name}.json").body

				return response if response.is_a?(Array)

				return [] if response == 'This rubygem could not be found.'

				raise "Unexpected response from RubyGems.org: #{response.inspect}"
			end

			def current_version_hash
				{ number: current_version, created_at: 'unreleased' }
			end

			def puts_versions(versions)
				require 'date'

				longest_version_number = versions.map { |version| version[:number].length }.max

				versions.each do |version|
					created_at = begin
						DateTime.parse(version[:created_at]).strftime('%F %R')
					rescue Date::Error
						version[:created_at]
					end

					puts "#{version[:number].ljust(longest_version_number)}  (#{created_at})"
				end
			end
		end
	end
end
