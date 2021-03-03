# frozen_string_literal: true

module GemToys
	class Template
		class Release
			## Helper module with methods about `git` for `release` tool
			module Git
				private

				def process_git
					new_version_git_tag = "#{@template.version_tag_prefix}#{@new_version}"

					## Checkout to a new git branch, required for protected `master` with CI
					# sh "git switch -c #{new_version_git_tag}"

					commit_changes

					## Tag commit
					puts 'Tagging the commit...'
					sh "git tag -a #{new_version_git_tag} -m 'Version #{@new_version}'"

					## Push commit
					puts 'Pushing commit...'
					sh 'git push'

					## Push tags
					puts 'Pushing tags...'
					sh 'git push --tags'
				end

				def commit_changes
					puts 'Committing changes...'

					sh "git add #{version_file_path} #{changelog_file_path}"

					sh "git commit -m 'Update version to #{@new_version}'"
				end
			end
		end
	end
end
