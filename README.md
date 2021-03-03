# Gem Toys

[![Cirrus CI - Base Branch Build Status](https://img.shields.io/cirrus/github/AlexWayfer/gem_toys?style=flat-square)](https://cirrus-ci.com/github/AlexWayfer/gem_toys)
[![Codecov branch](https://img.shields.io/codecov/c/github/AlexWayfer/gem_toys/master.svg?style=flat-square)](https://codecov.io/gh/AlexWayfer/gem_toys)
[![Code Climate](https://img.shields.io/codeclimate/maintainability/AlexWayfer/gem_toys.svg?style=flat-square)](https://codeclimate.com/github/AlexWayfer/gem_toys)
[![Depfu](https://img.shields.io/depfu/AlexWayfer/benchmark_toys?style=flat-square)](https://depfu.com/repos/github/AlexWayfer/gem_toys)
[![Inline docs](https://inch-ci.org/github/AlexWayfer/gem_toys.svg?branch=master)](https://inch-ci.org/github/AlexWayfer/gem_toys)
[![license](https://img.shields.io/github/license/AlexWayfer/gem_toys.svg?style=flat-square)](https://github.com/AlexWayfer/gem_toys/blob/master/LICENSE.txt)
[![Gem](https://img.shields.io/gem/v/gem_toys.svg?style=flat-square)](https://rubygems.org/gems/gem_toys)

[Toys](https://github.com/dazuma/toys) template for gems, like building, releasing, etc.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gem_toys'
```

And then execute:

```shell
bundle install
```

Or install it yourself as:

```shell
gem install gem_toys
```

## Usage

```ruby
# .toys.rb
require 'gem_toys'
expand GemToys::Template,
  ## default is `CHANGELOG.md`
  changelog_file_name: 'ChangeLog.md',
  ## default is `## master (unreleased)`
  unreleased_title: '## Unreleased',
  ## default is `"lib/#{project_name_with_slashes_instead_dashes}/version.rb"`
  version_file_path: 'lib/my-awesome_gem.rb'

# `gem` namespace created, aliases are optional, but handful
alias_tool :g, :gem
```

### Build

`toys gem build` builds a gem with the current version and move it to the `pkg/` directory.

### Install

`toys gem install` [builds](#build) a gem and install it locally.

### Release

`toys gem release` does:

1.  Update `lib/*gem_name*/version.rb` file.
    Can be refined with `:version_file_path` option on `expand`.
2.  Insert Markdown title with changes from `## master (unreleased)` in a `CHANGELOG.md` file.
    Can be refined with `:unreleased_title` option on `expand`.
3.  [Builds](#build) a gem.
4.  Ask you for manual check, if you want (print anything of OK).
    You also can change manually a content of `CHANGELOG.md`, for example, before committing.
5.  Commit these files.
6.  Tag this commit with `vX.Y.Z`.
7.  Push git commit and tag.
8.  Push the new gem.

## Development

After checking out the repo, run `bundle install` to install dependencies.

Then, run `toys rspec` to run the tests.

To install this gem onto your local machine, run `toys gem install`.

To release a new version, run `toys gem release %version%`. See how it works [here](#release).

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/AlexWayfer/gem_toys).

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
