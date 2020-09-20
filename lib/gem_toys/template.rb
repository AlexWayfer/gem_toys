# frozen_string_literal: true

require 'date'
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

				tool :release do
					required_arg :version

					to_run do
						@template = template

						@today = Date.today.to_s

						update_version_file

						## Update CHANGELOG
						update_changelog_file

						## Build new gem file
						exec_tool 'gem build'

						wait_for_manual_check

						## Checkout to a new git branch, required for protected `master` with CI
						# sh "git switch -c v#{version}"

						commit_changes

						## Tag commit
						puts 'Tagging the commit...'
						sh "git tag -a v#{version} -m 'Version #{version}'"

						## Push commit
						puts 'Pushing commit...'
						sh 'git push'

						## Push tags
						puts 'Pushing tags...'
						sh 'git push --tags'

						puts 'Pushing gem...'
						sh "gem push #{current_gem_file}"
					end

					private

					def update_version_file
						puts 'Updating version file...'

						File.write version_file_path, version_file_content.sub(/'.+'/, "'#{version}'")
					end

					def update_changelog_file
						puts 'Updating changelog file...'

						@changelog_lines = File.readlines(changelog_file_path)

						existing_line = find_version_line_in_changelog_file

						if existing_line
							return if (existing_date = existing_line.match(/\((.*)\)/)[1]) == @today

							abort "There is already #{version} version with date #{existing_date}"
						end

						File.write changelog_file_path, new_changelog_content
					end

					def find_version_line_in_changelog_file
						@changelog_lines.find { |line| line.start_with? "## #{version} " }
					end

					def new_changelog_content
						unreleased_title = @template.unreleased_title
						@changelog_lines.insert(
							@changelog_lines.index("#{unreleased_title}\n") + 2,
							'#' * unreleased_title.scan(/^#+/).first.size + " #{version} (#{@today})\n\n"
						).join
					end

					def commit_changes
						puts 'Committing changes...'

						sh "git add #{version_file_path} #{changelog_file_path}"

						sh "git commit -m 'Update version to #{version}'"
					end

					def wait_for_manual_check
						$stdout.puts 'Please, validate files and commits before pushing.'
						$stdin.gets
					end
				end
			end
		end
	end
end
