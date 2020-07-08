# Gem Toys

![Cirrus CI - Base Branch Build Status](https://img.shields.io/cirrus/github/AlexWayfer/gem_toys?style=flat-square)
[![Codecov branch](https://img.shields.io/codecov/c/github/AlexWayfer/gem_toys/master.svg?style=flat-square)](https://codecov.io/gh/AlexWayfer/gem_toys)
[![Code Climate](https://img.shields.io/codeclimate/maintainability/AlexWayfer/gem_toys.svg?style=flat-square)](https://codeclimate.com/github/AlexWayfer/gem_toys)
![Depfu](https://img.shields.io/depfu/AlexWayfer/gem_toys?style=flat-square)
[![Inline docs](https://inch-ci.org/github/AlexWayfer/gem_toys.svg?branch=master)](https://inch-ci.org/github/AlexWayfer/gem_toys)
[![license](https://img.shields.io/github/license/AlexWayfer/gem_toys.svg?style=flat-square)](https://github.com/AlexWayfer/gem_toys/blob/master/LICENSE)
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
expand GemToys::Template

# `gem` namespace created, aliases are optional, but handful
alias_tool :g, :gem
```

At invocation it will:

1.  Update `lib/*gem_name*/version.rb` file.
    Can be refined with `:version_file_path` option on `expand`.
2.  Insert Markdown title with changes from `## master (unreleased)` in a `CHANGELOG.md` file.
    Can be refined with `:unreleased_title` option on `expand`.
3.  Execute `gem build`.
4.  Ask you for manual check, if you want (print anything of OK).
    You also can change manually a content of `CHANGELOG.md`, for example, before committing.
5.  Commit these files.
6.  Tag this commit with `vX.Y.Z`.
7.  Push git commit and tag.
8.  Push the new gem.

## Development

After checking out the repo, run `bundle install` to install dependencies.
Then, run `bundle exec rspec` to run the tests.

To install this gem onto your local machine, run `toys gem install`.
To release a new version, update the version number in `version.rb`,
and then run `bundle exec rake release`, which will create a git tag
for the version, push git commits and tags, and push the `.gem` file
to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/AlexWayfer/gem_toys).

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
