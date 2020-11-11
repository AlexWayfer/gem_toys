# frozen_string_literal: true

module GemToys
	class Template
		## Template with gem versions tool, expanding internally
		class Versions
			include Toys::Template

			attr_reader :version_file_path

			def initialize(version_file_path:)
				@version_file_path = version_file_path
			end

			on_expand do |template|
				tool :versions do
					to_run do
						@template = template

						versions = rubygems_versions

						versions.unshift current_version_hash if current_version != versions.first[:number]

						puts_versions versions
					end
				end
				alias_tool :releases, :versions
			end
		end
	end
end
