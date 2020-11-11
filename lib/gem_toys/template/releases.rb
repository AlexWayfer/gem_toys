# frozen_string_literal: true

module GemToys
	class Template
		## Template with gem releases tool, expanding internally
		class Releases
			include Toys::Template

			on_expand do
				tool :releases do
					to_run do
						puts_versions rubygems_versions
					end
				end
				alias_tool :versions, :releases
			end
		end
	end
end
