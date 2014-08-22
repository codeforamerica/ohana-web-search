## How to Contribute
In the spirit of open source software, **everyone** is encouraged to help
improve this project.

### Ways *you* can contribute:
* by [installing and testing the software][install_instructions]
* by [using the issue tracker][issue_tracker] for...
  * reporting bugs
  * suggesting new features
  * suggesting labels for our issues
* by improving the code through:
  * writing or editing documentation
  * writing test specifications
  * refactoring the code (**no patch is too small**: fix typos, add comments,
  clean up inconsistent whitespace).
  * reviewing [open Pull Requests][open_prs]
* by [donating to Code for America][donate]

### Reporting a bug or other issue
We use the GitHub issue tracker to track bugs and feature
requests. To submit a bug report or feature request:

1. **[Browse][issue_tracker] or [search][issue_search] our issues** to make
sure your issue hasn't already been submitted.

2. **[Submit an issue][new_issue]**.
If you're submitting a bug report, it's helpful to include any details that
may be necessary to reproduce the bug, including:

    - a screenshot
    - your operating system (Windows 7, Mac OSX 10.9.2, etc.)
    - your web browser and version (Internet Explorer 9, Chrome 27, etc.)
    - a stack trace of any errors encountered
    - your Ruby version (use `ruby -v` from the command line)

For developers, a bug report should ideally include a pull request with
failing specs.

### Tackle a Hack Request
Some issues in particular we'd be happy if contributors like yourself were
interested in fixing. Browse the issues [labelled `hack request`][hack_request]
and see if there's something there that you could fix.

### Updating the Code? Open a Pull Request
To submit a code change to the project for review by the team:

1. **Setup:** Make sure you have the [prerequisites installed][prerequisites]
on your computer.

2. **Fork:** [Fork this repository and clone it on your computer][fork].

3. **Install Dependencies:** From the root directory of the app, run `bundle`.

4. **Branch:** [Create a topic branch][branch] for the one specific issue
you're addressing.

5. **Write Specs:** Add specs for your unimplemented feature or bug fix in the
`/spec/` directory.

6. **Test to fail:** Run `spring rspec`. If your specs pass, return to
**step 5**. In the spirit of Test-Driven Development, you want to write a
failing test first, then implement the feature or bug fix to make the test
pass.

7. **Implement:** Implement your feature or bug fix. Please follow the
[community-driven Ruby Style Guide][style_guide]*.

8. **Test to pass:** Run `script/test` to run the test suite in addition to the
style checkers. If your specs fail and/or style offenses are reported, return
to **step 7**.

9. _(If applicable)_ **Clean up JavaScript code:** Run `rake jshint` to check
JavaScript code quality.

10. **Commit changes:** Add, commit, and push your changes.

11. **Pull request:** [Submit a pull request][pr] to send your changes to this
repository for review.

_*If you use Sublime Text, please make sure to set your tab indentation to 2
spaces. We also highly recommend you use the [TrailingSpaces][trailing_spaces]
plugin and set it to [Trim On Save][trim_on_save]._

[install_instructions]: https://github.com/codeforamerica/ohana-web-search/blob/master/INSTALL.md
[open_prs]: https://github.com/codeforamerica/ohana-web-search/pulls?q=is%3Aopen+is%3Apr
[hack_request]: https://github.com/codeforamerica/ohana-web-search/labels/hack%20request
[donate]: http://codeforamerica.org/support-us/
[issue_tracker]: https://github.com/codeforamerica/ohana-web-search/issues
[issue_search]: https://github.com/codeforamerica/ohana-web-search/search?ref=cmdform&type=Issues
[new_issue]: https://github.com/codeforamerica/ohana-web-search/issues/new
[prerequisites]: https://github.com/codeforamerica/ohana-web-search/blob/master/INSTALL.md#install-prerequisites
[fork]: http://help.github.com/fork-a-repo/
[branch]: https://help.github.com/articles/creating-and-deleting-branches-within-your-repository
[style_guide]: https://github.com/bbatsov/ruby-style-guide
[pr]: http://help.github.com/send-pull-requests/
[trailing_spaces]: https://github.com/SublimeText/TrailingSpaces
[trim_on_save]: https://github.com/SublimeText/TrailingSpaces#trim-on-save
