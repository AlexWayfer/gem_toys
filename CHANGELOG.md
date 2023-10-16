# Changelog

## Unreleased

## 0.13.0 (2023-10-16)

*   Drop Ruby 2.6 support.
*   Add Ruby 3.2 support.
*   Add missing runtime `toys-core` dependency.
*   Move development dependencies from gemspec into Gemfile.
*   Update development dependencies.
*   Improve CI config.

## 0.12.1 (2022-02-07)

*   Drop Ruby 2.5 support.
*   Add Ruby 3.1 support.

## 0.12.0 (2022-02-07)

*   Update Faraday to version 2.
*   Update development dependencies.

## 0.11.3 (2021-11-10)

*   Resolve RuboCop offense, take out manual check menu choices.

## 0.11.2 (2021-11-07)

*   Fix version for gem staff after manual refresh too.

## 0.11.1 (2021-11-07)

*   Fix new version for git staff after manual refresh.

## 0.11.0 (2021-10-29)

*   Revert version and changelog files changes at rejection.
*   Revert version file changes at changelog fails.
*   Update development dependencies.

## 0.10.0 (2021-10-15)

*   Process cases with non-JSON String from RubyGems.org.
*   Update development dependencies.
*   Resolve new offenses from RuboCop.
*   Change default for unreleased in Changelog.

## 0.9.0 (2021-08-26)

*   Fix built gem version after `refresh` answer.
*   Update development dependencies.
*   Lock RuboCop version better.
*   Resolve new RuboCop offenses.

## 0.8.0 (2021-04-16)

*   Add `refresh` answer for release confirmation.

## 0.7.1 (2021-03-04)

*   Fix error about non-renamed `version` in one of aborts.
*   Improve Regexp for date of existing release.
    Catch only content inside the last parentheses.

## 0.7.0 (2021-03-04)

*   Add `:changelog_file_name` option.
*   Add `:version_tag_prefix` option.
*   Change date format for `versions` tool.
*   Add documentation about `:version_file_path` option.
*   Split `release` tool into modules for RuboCop satisfaction.

## 0.6.1 (2021-02-10)

*   Gently abort when `unreleased_title` not found.
*   Improve documentation about `:unreleased_title` option.

## 0.6.0 (2021-02-10)

*   Support Ruby 3.
*   Fix error with undefined `FileUtils`.
*   Fix error with `release` tool via updating `alt_memery` to a fixed version.
*   Update development dependencies.

## 0.5.0 (2020-11-29)

*   Add `versions` tool with `releases` alias.
*   Add `version` tool.
*   Add an ability to release new `major`, `minor` or `patch` version.
    Just specify keyword instead of number and it'll increase correctly.
*   Print `git diff` for files which will be commited on `release`.
*   Drop Ruby 2.4 support.
    [Support of Ruby 2.4 has ended](https://www.ruby-lang.org/en/news/2020/04/05/support-of-ruby-2-4-has-ended/).
*   Add and use `memery` dependency.
*   Update `rubocop`, `remark`.

## 0.4.0 (2020-09-21)

*   Improve version update script, support files with other String constants.
*   Update bundle.

## 0.3.0 (2020-07-11)

*   Add support for Ruby 2.4

## 0.2.0 (2020-07-09)

*   Add `:version_file_path` and `:unreleased_title` options
*   Change the order of tasks: check (manually) before committing.
*   Include `:exec` only unless already included.
*   Improve usage documentation.
*   Add output of process steps.

## 0.1.0 (2020-07-08)

*   Initial commit
