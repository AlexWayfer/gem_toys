# frozen_string_literal: true

include :bundler, static: true

require_relative 'lib/gem_toys'
expand GemToys::Template, publish_gem: false

tool :g, delegate_relative: :gem
