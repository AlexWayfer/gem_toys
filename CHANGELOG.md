# Changelog

## master (unreleased)

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
