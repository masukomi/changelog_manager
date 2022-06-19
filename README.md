[![Build Status](https://travis-ci.org/masukomi/changelog_manager.svg?branch=master)](https://travis-ci.org/masukomi/changelog_manager)

* [Why Use It](#why-use-it)
	* [Background](#background)
	* [Why not auto-generate them from Commits or PRs?](#why-not-auto-generate-them-from-commits-or-prs)
* [How to use it](#how-to-use-it)
	* [Adding a new entry](#adding-a-new-entry)
	* [Git Integration](#git-integration)
		* [New Entries](#new-entries)
		* [Changelog Generation](#changelog-generation)
	* [Generating a new CHANGELOG.md](#generating-a-new-changelogmd)
		* [Filtered CHANGELOG.md generation](#filtered-changelogmd-generation)
	* [Editing an entry](#editing-an-entry)
	* [Configuration](#configuration)
* [How To Get It & Installation](#how-to-get-it)
	* [Building from source](#building-from-source)
* [What you should put in it](#what-you-should-put-in-it)
	* [What's not a good Changelog entry](#whats-not-a-good-changelog-entry)
	* [What you should put in it](#what-you-should-put-in-it-1)
* [How it works](#how-it-works)
* [Contributors](#contributors)


## Why Use It

Changelog Manager helps you generate a `CHANGELOG.md` file for your Git repo 
that adheres to the [Keep A Changelog](http://keepachangelog.com/) standard, 
and doesn't result in almost constant conflicts.


### Background
There are tons of great reasons to [Keep A Changelog](http://keepachangelog.com/). 
We found that having a Changelog file for our app helped everyone in the organization to know what was in the upcoming release, but requiring developers to add lines to it with every PR resulted in constant git conflicts. Changelog Manager solves that. 

When you want to add a new entry to the changelog, Changelog Manager will ask you some quick questions, and store a JSON file in the `.changelog-entries` folder of your project (see [How It Works](#how-it-works)). Then, when you’re ready, it will generate a full CHANGELOG.md file, organizing everything by tag and change type.

### Why not auto-generate them from Commits or PRs?
There are a lot of solutions out there that offer this. There are a few problems
with this

1. Commit messages are too fine grained and frequently very geeky
2. The Ticket / Story is typically the correct level of abstraction and their titles are rarely appropriately worded for Changelog entries
3. And many, [many more reasons](http://weblog.masukomi.org/2016/06/30/why-you-cant-auto-generate-your-changelog/).

## How to use it

### Adding a new entry


To add a new entry just invoke it on the command line with no arguments: 

```bash
changelog_manager
```

It will ask you a series of questions and generate a new file in
`.changelog-entries` (see [How It Works](#how-it-works)). That file will be used when generating the full
CHANGELOG.md file.

If you project uses a ticket tracker you can [configure](docs/configuration.md)
it so that it will generate the url to the ticket without requiring you to
manually enter it.

### Git Integration

#### New Entries

By default new changelog entry will be added to git (but not committed) upon 
creation. This can be changed as part of the [configuration](docs/configuration.md) 
of the Changelog Manager.

#### Changelog Generation

The Changelog version numbers are extracted from git tags. **The presumption is
that your repo will be tagged using semantically versioned numbers** that can
optionally begin with a "v" for example `v1.0.1` and `1.0.1` are both acceptable
version numbers to the `changelog_manager`.

### Generating a new CHANGELOG.md

To generate a new CHANGELOG.md, just invoke it with the `-c` parameter (or
`--compile`). The changelog is printed to STDOUT so that you can shove it into
a file or run it through a Markdown -> HTML conversion, or whatever else you 
want to do with it.

`chagelog_manager -c > CHANGELOG.md`

#### Filtered CHANGELOG.md generation

Changelog entries can be "tagged" with metadata during their creation (think tagging bookmarks, not git tags). For example, if you have a security issue that you've fixed, but should remain internal only, you might tag it with "internal". You might have some items that are specific to one of your clients, so you’d tag those with "client_a" or "client_b". 

Then, when you generate the Changelog, you can choose which tags should be included in the output. The following command would generate a changelog with generic (untagged) items, and items tagged with "client_a" but no "internal" or "client_b" tags.

`changelog_manager -c -w client_a  > CHANGELOG.md`

You can specify multiple tags by providing a comma separated list to `-w` for
example `changelog_manager -c -w internal,awesome`


### Editing an entry

Developers dun awlayz write gud. 

In our experience, developers tend to write Changelog entries at the wrong level of abstraction. E.g. Too damn geeky. We need to tweak them to make sense to the non-geeks consuming the changelog. Sometimes, we just want to fix typos.

If you see a changelog entry that needs adjusting:

1. Find the appropriate file in `.changelog_entries` 
	* If there's a ticken number grep for it.
	* If not, just grep for a short bit of the Changelog entry
	* `grep "some text" .changelog_entries/*`
2. Open the file in your favorite text editor, and edit it.
	* Must remain valid JSON.
	* Yes, we can, and should [make this easier](https://github.com/masukomi/changelog_manager/issues/18).
3. Add and Commit the changes to git.

It doesn't matter that the entry was created with an old commit. `changelog_manager` 
will always generate CHANGELOG.md from the latest version of files found in `.commit_entries`. I.e. 
["new hotness", not "old and busted"](https://www.youtube.com/watch?v=ha-uagjJQ9k).

Note: in the `utils` directory you will find a `description_by_file` bash
script. Run this within the home directory of your app and it'll generate a
listing of the JSON files and the description in each. For example:

    $ description_by_file
    .changelog_entries/101b2bc9f12ab533da6dd9957308fec1.json  new entry creation now honors git_add setting in config file
    .changelog_entries/1857d1f1ef88830d500227dd2b135f07.json  Improved readme, added link to download the latest pre-compiled version

You can then pipe that output through `grep`, or whatever to find the one you're
looking for. Suggestions for improving the editing experience will be welcomed.

### Configuration
Changelog Manager [some optional configurations](docs/configuration.md) you will
want to check out.

## How To Get It
Unfortunately, right now the best way is to build from source. Homebrew install
coming (hopefully) soon.

### Building from source

Changelog Manager is written in Crystal so, you'll need to 
[install the Crystal compiler](http://crystal-lang.org/). 

The `run_me_first.sh` script will take care of installing that, and the libraries it needs if you're on a system with homebrew. If not it'll list what you need. 


1. Clone this repo.
2. on the command line run `./run_me_first.sh`
  * if you're on a system without homebrew, you'll need to manually install the libraries it tells you it needs.
3. on the command line run `./build.sh`

This will generate a `changelog_manager` executable in the current directory.

Put the new `changelog_manager` file somewhere in your
path. Here's [how to add a directory to your path](http://unix.stackexchange.com/a/26059/124338). Or, if you just run `echo $PATH` on the command line you can simply
move `changelog_manager` to any of the directories in that list (that you have
write access to).

That's it. 

## What you should put in it

So we’ve covered how to use the Changelog Manager tool, but how do you write a useful changelog entry? 

Bottom line: your changelog entry should be human-readable by your target audience.

In some cases, the changelog may only ever be viewed by other developers, so writing geeky details in it may be exactly the use case you need.

In other cases, your changelog may be read by a non-developer who may need to communicate about the awesome work you’re doing to other non-developers. 

That means you need to find the right level of abstraction to discuss what your commit contains, and to do it using language that your audience will understand.

If your changelog is intended for consumption by non-developers, think of it this way. A non-developer isn’t familiar with the source, specific integrations, or functions, and as such, has no way to understand your changes unless you find a plain-language way to tell them. And writing that clearly in a changelog entry saves the time later of that non-developer having to hunt you down and ask you about the commit, which then turns into a 15-minute conversation about all the things.

So let’s just head that off now with a useful Changelog entry.

### What's not a good Changelog entry

Monkey see, monkey do. Here are a few examples of what NOT to write in your changelog entries:

* Changed Method X
	* Non-geeks will have no clue
* Added support for X technology
	* Why? To what end?
* Fixed bug on X page
	*  What bug?
* Updated Foo Report
	* What did you update about it? 

### What you should put in it
If you checked out the link at the top of the doc to Keep a Changelog this is
going to look very familiar to you. A good changelog should:

* Be human-readable using language your target audience will understand
* The Changelog Manager tool will ask you what kind of change you’ve made so that others can understand their impact on the project, as follows:
* Added for new features.
	* **Changed** for changes in existing functionality.
	* **Deprecated** for once-stable features removed in upcoming releases.
	* **Removed** for deprecated features removed in this release.
	* **Fixed** for any bug fixes.
	* **Security** to invite users to upgrade in case of vulnerabilities.

You may have multiple changelog entries for a single piece of work, because each entry should describe only one of these types of changes; i.e. you’d have separate entries for **Added** new features vs. **Removed** deprecated features. In this example, you’d run the changelog_manager tool twice.

From a practical standpoint, there are a couple of good rules that can help you make sure you’re writing a useful, human-readable changelog entry:

1. Don’t use internal jargon. If a bug is fixed, speak in terms of the actions that caused it, or the behavior it exhibited, but not the specific classes, unless you absolutely have to.
2. It must be knowledge that’s useful to your users. Speak to the features and flaws that affect your customers. Users don’t care that you refactored some unit test, or reformatted your comments.

And finally, here are a few examples:

* **Added** ordering as a UI option for store users
* **Removed** comments form on page X
* **Fixed** bug so store managers no longer have access to delete locations

## How it works

![](https://cdn.rawgit.com/masukomi/changelog_manager/master/docs/images/how_it_works.svg)


## Contributors

- [masukomi](https://github.com/masukomi) masukomi - creator, maintainer
- [Eric Zell](https://github.com/EricJZell)
- [Dachary](https://github.com/dacharyc)
