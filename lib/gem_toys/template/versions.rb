# frozen_string_literal: true

module GemToys
	class Template
		## Template with gem versions tool, expanding internally
		class Versions
			include Toys::Template

			on_expand do
				tool :versions do
					to_run do
						puts_versions rubygems_versions
					end
				end
				alias_tool :releases, :versions
			end
		end
	end
end
