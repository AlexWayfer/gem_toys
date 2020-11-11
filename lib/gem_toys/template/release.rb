# frozen_string_literal: true

module GemToys
	class Template
		## Template with gem release tool, expanding internally
		class Release
			include Toys::Template

			attr_reader :version_file_path, :unreleased_title

			def initialize(version_file_path:, unreleased_title:)
				@version_file_path = version_file_path
				@unreleased_title = unreleased_title
			end

			on_expand do |template|
				tool :release do
					required_arg :new_version

					to_run do
						require 'date'

						@template = template

						@today = Date.today.to_s

						update_version_file

						## Update CHANGELOG
						update_changelog_file

						## Build new gem file
						exec_tool 'gem build'

						wait_for_manual_check

						## Checkout to a new git branch, required for protected `master` with CI
						# sh "git switch -c v#{new_version}"

						commit_changes

						## Tag commit
						puts 'Tagging the commit...'
						sh "git tag -a v#{new_version} -m 'Version #{new_version}'"

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

						File.write(
							version_file_path,
							version_file_content.sub(/(VERSION = )'.+'/, "\\1'#{new_version}'")
						)
					end

					def update_changelog_file
						puts 'Updating changelog file...'

						@changelog_lines = File.readlines(changelog_file_path)

						existing_line = @changelog_lines.find { |line| line.start_with? "## #{new_version} " }

						if existing_line
							return if (existing_date = existing_line.match(/\((.*)\)/)[1]) == @today

							abort "There is already #{version} version with date #{existing_date}"
						end

						File.write changelog_file_path, new_changelog_content
					end

					def new_changelog_content
						unreleased_title = @template.unreleased_title
						@changelog_lines.insert(
							@changelog_lines.index("#{unreleased_title}\n") + 2,
							'#' * unreleased_title.scan(/^#+/).first.size + " #{new_version} (#{@today})\n\n"
						).join
					end

					def commit_changes
						puts 'Committing changes...'

						sh "git add #{version_file_path} #{changelog_file_path}"

						sh "git commit -m 'Update version to #{new_version}'"
					end

					def wait_for_manual_check
						$stdout.puts
						sh "git diff #{version_file_path} #{changelog_file_path}"
						$stdout.puts
						$stdout.puts 'Please, validate files before committing and pushing!'
						$stdout.puts 'Press anything to continue, Ctrl+C to cancel.'
						$stdin.gets
					end
				end
			end
		end
	end
end
