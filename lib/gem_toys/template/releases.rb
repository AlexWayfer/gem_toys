# frozen_string_literal: true

module GemToys
	class Template
		## Template with gem releases tool, expanding internally
		class Releases
			include Toys::Template

			on_expand do
				tool :releases do
					to_run do
						require 'date'
						require 'faraday'
						require 'faraday_middleware'

						connection = Faraday.new 'https://rubygems.org/api/v1' do |conn|
							conn.response :json, parser_options: { symbolize_names: true }
						end

						response = connection.get("versions/#{project_name}.json")
						releases = response.body

						longest_release_number = releases.map { |release| release[:number].length }.max

						releases.each do |release|
							puts <<~LINE
								#{release[:number].ljust(longest_release_number)}  (#{DateTime.parse(release[:created_at]).strftime('%b %e %Y %R')})
							LINE
						end
					end
				end
				alias_tool :versions, :releases
			end
		end
	end
end
