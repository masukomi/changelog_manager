# Changelog Manager

Changelog Manager helps you generate a `CHANGELOG.md` file for your repo 
that adheres to the [Keep A Changelog](http://keepachangelog.com/) standard, 
and doesn't result in almost constant conflicts.

## Background
There are tons of great reasons to [Keep A Changelog](http://keepachangelog.com/). 
We found that having a Changelog file for our app helped everyone in the
organization to know what was in the upcoming release, but requiring developers
to add lines to it with every PR resulted in constant git conflicts. Changelog
Manager solves that. 

When your want to add a new entry to the changelog Changelog Manager will ask
you some quick questions and store a JSON file in the `.changelog_entries`
folder of your project. Then, when your ready, it will generate a full
CHANGELOG.md organizing everything by tag and change type.


## Installation

## Building from source: 
Changelog Manager is written in Crystal so, you'll need to 
[install the Crystal compiler](http://crystal-lang.org/docs/installation/index.html).

Then 

    `crystal compile --release src/changelog_manager.cr`

Once you've built it, put the new `changelog_manager` file somewhere in your
path. Here's [how to add a directory to your path](http://unix.stackexchange.com/a/26059/124338). Or, if you just run `echo $PATH` on the command line you can simply
move `changelog_manager` to any of the directories in that list (that you have
write access to).

## Usage

### Adding a new entry


To add a new entry just invoke it.
`changelog_manager`

It will ask you a series of questions and generate a new file in
`.changelog_entries` That file will be used when generating the full
CHANGELOG.md file.

### Generating a new CHANGELOG.md

To generate a new CHANGELOG.md just invoke it with the `-l` parameter. The
changelog is printed to STDOUT so that you can shove it into a file or run it
through a Markdown -> HTML conversion, or whatever else you want to do with it.

`chagelog_manager -l > CHANGELOG.md`

### Editing an entry

Developers dun awlayz write gud. 

In our experience developers tend to write Changelog entries at the wrong level
of abstraction. E.g. To damn geeky. We need to tweak them to make sense to the
non-geeks consuming the changelog. Sometimes, we just want to fix typos.

If you see a changelog entry that needs adjusting
1. Find the appropriate file in `.changelog_entries` 
	* If there's a ticken number grep for it.
	* If not, just grep for a short bit of the changlog entry
	* `grep "some text" .changelog_entries/*`
2. Open the file in your favorite text editor, and edit it.
	* Must remain valid JSON.
3. Add and Commit the changes to git.

It doesn't matter that the entry was created with an old commit.
`changelog_manager` will always generate CHANGELOG.md from the latest version
of files found in `.commit_entries`. I.e. 
["new hotness", not "old and busted"](https://www.youtube.com/watch?v=ha-uagjJQ9k).


TODO: hack STDIN so that we can make this a git pre-commit hook


## Development

TODO: Write development instructions here



## Contributors

- [[masukomi]](https://github.com/masukomi) masukomi - creator, maintainer
