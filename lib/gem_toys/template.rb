# frozen_string_literal: true

require 'date'
require 'toys-core'

module GemToys
	## Template with gem tools, should be expanded in toys file
	class Template
		include Toys::Template

		## Module for common code between nested tools
		module CommonCode
			private

			def project_name
				@project_name ||= File.basename context_directory
			end

			def version_file_path
				project_path = project_name.tr '-', '/'
				@version_file_path ||= File.join context_directory, 'lib', project_path, 'version.rb'
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

		on_expand do
			tool :gem do
				subtool_apply do
					include :exec, exit_on_nonzero_status: true, log_level: Logger::UNKNOWN
					include CommonCode
				end

				tool :build do
					def run
						sh 'gem build'
						FileUtils.mkdir_p pkg_directory
						FileUtils.mv "#{context_directory}/#{gem_file_name}", current_gem_file
					end
				end

				tool :install do
					def run
						exec_tool 'gem build'
						sh "gem install #{current_gem_file}"
					end
				end

				tool :release do
					required_arg :version

					def run
						update_version_file

						## Update CHANGELOG
						update_changelog_file

						## Checkout to a new git branch, required for protected `master` with CI
						# sh "git switch -c v#{version}"

						commit_changes

						## Tag commit
						sh "git tag -a v#{version} -m 'Version #{version}'"

						## Build new gem file
						exec_tool 'gem build'

						wait_for_manual_check

						## Push commit
						sh 'git push'

						## Push tags
						sh 'git push --tags'

						push_new_gem
					end

					private

					def update_version_file
						File.write version_file_path, version_file_content.sub(/'.+'/, "'#{version}'")
					end

					TODAY = Date.today.to_s

					def update_changelog_file
						@changelog_lines = File.readlines(changelog_file_path)

						existing_line = find_version_line_in_changelog_file

						if existing_line
							return if (existing_date = existing_line.match(/\((.*)\)/)[1]) == TODAY

							abort "There is already #{version} version with date #{existing_date}"
						end

						File.write changelog_file_path, new_changelog_content
					end

					def find_version_line_in_changelog_file
						@changelog_lines.find { |line| line.start_with? "## #{version} " }
					end

					def new_changelog_content
						@changelog_lines.insert(
							@changelog_lines.index("## master (unreleased)\n") + 2, "## #{version} (#{TODAY})\n\n"
						).join
					end

					def commit_changes
						sh "git add #{version_file_path} #{changelog_file_path}"

						sh "git commit -m 'Update version to #{version}'"
					end

					def wait_for_manual_check
						STDOUT.puts 'Please, validate files and commits before pushing.'
						STDIN.gets
					end

					def push_new_gem
						gem_file = Dir[File.join(context_directory, "#{@project_name}-#{version}.gem")].first
						sh "gem push #{gem_file}"
					end
				end
			end
		end
	end
end
