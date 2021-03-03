# frozen_string_literal: true

module GemToys
	class Template
		## Template with gem release tool, expanding internally
		class Release
			include Toys::Template

			attr_reader :changelog_file_name, :version_file_path, :unreleased_title

			def initialize(
				changelog_file_name:,
				version_file_path:,
				unreleased_title:
			)
				@changelog_file_name = changelog_file_name
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

						handle_new_version

						update_version_file

						## Update CHANGELOG
						update_changelog_file

						## Build new gem file
						exec_tool 'gem build'

						wait_for_manual_check

						## Checkout to a new git branch, required for protected `master` with CI
						# sh "git switch -c v#{@new_version}"

						commit_changes

						## Tag commit
						puts 'Tagging the commit...'
						sh "git tag -a v#{@new_version} -m 'Version #{@new_version}'"

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

					self::VERSION_TYPES = %w[
						major
						minor
						patch
					].freeze

					def handle_new_version
						## https://github.com/dazuma/toys/issues/103
						@new_version =
							if (version_index = self.class::VERSION_TYPES.index(new_version))
								current_version_parts =
									current_version.split('.')[0..(self.class::VERSION_TYPES.count - 1)]
								handle_keyword_in_new_version current_version_parts, version_index
							else
								new_version
							end

						clear_memery_cache! :current_version
					end

					def handle_keyword_in_new_version(current_version_parts, version_index)
						current_version_parts.map.with_index do |version_part, index|
							if index < version_index
								version_part
							elsif index == version_index
								Integer(version_part) + 1
							else
								0
							end
						end.join('.')
					end

					def update_version_file
						puts 'Updating version file...'

						File.write(
							version_file_path,
							version_file_content.sub(/(VERSION = )'.+'/, "\\1'#{@new_version}'")
						)
					end

					def update_changelog_file
						puts 'Updating changelog file...'

						@changelog_lines = File.readlines(changelog_file_path)

						existing_line = @changelog_lines.find { |line| line.start_with? "## #{@new_version} " }

						if existing_line
							return if (existing_date = existing_line.match(/\((.*)\)/)[1]) == @today

							abort "There is already #{version} version with date #{existing_date}"
						end

						File.write changelog_file_path, new_changelog_content
					end

					def new_changelog_content
						unreleased_title = @template.unreleased_title

						unreleased_title_index = @changelog_lines.index("#{unreleased_title}\n")

						abort_without_unreleased_title unless unreleased_title_index

						@changelog_lines.insert(
							unreleased_title_index + 2,
							'#' * unreleased_title.scan(/^#+/).first.size + " #{@new_version} (#{@today})\n\n"
						).join
					end

					def abort_without_unreleased_title
						abort <<~TEXT
							`#{@template.unreleased_title}` not found in the `#{@template.changelog_file_name}` as the title for unreleased changes.
							Please, use `:unreleased_title` option if you have non-default one.
						TEXT
					end

					def commit_changes
						puts 'Committing changes...'

						sh "git add #{version_file_path} #{changelog_file_path}"

						sh "git commit -m 'Update version to #{@new_version}'"
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
