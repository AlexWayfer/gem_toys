# frozen_string_literal: true

module GemToys
	class Template
		class Release
			## Helper module with methods about CHANGELOG file for `release` tool
			module Changelog
				private

				def update_changelog_file
					puts 'Updating changelog file...'

					@changelog_lines = File.readlines(changelog_file_path)

					existing_line = @changelog_lines.find { |line| line.start_with? "## #{@new_version} " }

					if existing_line
						return if (existing_date = existing_line.scan(/\(([^()]+)\)/).last.first) == @today

						abort "There is already #{new_version} version with date #{existing_date}"
					end

					File.write changelog_file_path, new_changelog_content
				end

				def new_changelog_content
					unreleased_title = @template.unreleased_title

					unreleased_title_index = @changelog_lines.index("#{unreleased_title}\n")

					unless unreleased_title_index
						sh "git restore --worktree #{version_file_path}"
						abort_without_unreleased_title
					end

					@changelog_lines.insert(
						unreleased_title_index + 1,
						"\n#{'#' * unreleased_title.scan(/^#+/).first.size} #{@new_version} (#{@today})\n"
					).join
				end

				def abort_without_unreleased_title
					abort <<~TEXT
						`#{@template.unreleased_title}` not found in the `#{@template.changelog_file_name}` as the title for unreleased changes.
						Please, use `:unreleased_title` option if you have non-default one.
					TEXT
				end
			end
		end
	end
end
