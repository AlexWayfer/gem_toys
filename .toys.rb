# frozen_string_literal: true

require 'bundler/setup'
Bundler.setup

require_relative 'lib/gem_toys'
expand GemToys::Template

alias_tool :g, :gem
