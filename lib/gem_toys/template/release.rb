# frozen_string_literal: true

require 'highline'

require_relative 'release/changelog'
require_relative 'release/git'

module GemToys
	class Template
		## Template with gem release tool, expanding internally
		class Release
			include Toys::Template

			attr_reader :changelog_file_name, :version_file_path, :version_tag_prefix, :unreleased_title

			def initialize(
				changelog_file_name:,
				version_file_path:,
				version_tag_prefix:,
				unreleased_title:
			)
				@changelog_file_name = changelog_file_name
				@version_file_path = version_file_path
				@version_tag_prefix = version_tag_prefix
				@unreleased_title = unreleased_title
			end

			on_expand do |template|
				tool :release do
					include Release::Changelog
					include Release::Git

					self::VERSION_TYPES = %w[
						major
						minor
						patch
					].freeze

					self::MANUAL_CHECK_MENU = {
						yes: (proc do
							## `current_version` is using in `git` and `gem` commands
							clear_memery_cache! :current_version
						end),
						no: (proc do
							handle_refusing_to_continue
						end),
						refresh: (proc do
							wait_for_manual_check
						end)
					}.freeze

					required_arg :new_version

					to_run do
						require 'date'

						@template = template

						@today = Date.today.to_s

						handle_new_version

						update_version_file

						## Update CHANGELOG
						update_changelog_file

						wait_for_manual_check

						## Build new gem file
						exec_tool 'gem build'

						## Commit, tag, push
						process_git

						puts 'Pushing gem...'
						sh "gem push #{current_gem_file}"
					end

					private

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

					def wait_for_manual_check
						print_files_diff

						HighLine.new.choose do |menu|
							menu.layout = :one_line

							menu.prompt = 'Are these changes correct? '

							self.class::MANUAL_CHECK_MENU.each do |choice, block|
								menu.choice(choice) { instance_exec(&block) }
							end
						end
					end

					def print_files_diff
						$stdout.puts
						sh "git diff #{version_file_path} #{changelog_file_path}"
						$stdout.puts
					end

					def handle_refusing_to_continue
						[version_file_path, changelog_file_path].each do |file_path|
							sh "git restore --worktree #{file_path}"
						end
						abort
					end
				end
			end
		end
	end
end
