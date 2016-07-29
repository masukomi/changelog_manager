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

## Why not auto-generate them from Commits or PRs?
There are a lot of solutions out there that offer this. There are a few problems
with this

1. Commit messages are too fine grained and frequently very geeky
2. The Ticket / Story is typically the correct level of abstraction and their titles are rarely appropriately worded for Changelog entries
3. and many, [many more reasons](http://weblog.masukomi.org/2016/06/30/why-you-cant-auto-generate-your-changelog/).


## Usage

### Adding a new entry


To add a new entry just invoke it.
`changelog_manager`

It will ask you a series of questions and generate a new file in
`.changelog_entries` That file will be used when generating the full
CHANGELOG.md file.

### Git Integration

By default new changelog entry will be added to git (but not committed) upon 
creation. This can be changed by changing `"git_add" : true` 
to `"git_add" : false` in the `.changelog_entries/config.json` file that is
auto-created the first time you generate a changelog entry.

### Generating a new CHANGELOG.md

To generate a new CHANGELOG.md just invoke it with the `-c` parameter (or
`--compile`). The changelog is printed to STDOUT so that you can shove it into
a file or run it through a Markdown -> HTML conversion, or whatever else you 
want to do with it.

`chagelog_manager -c > CHANGELOG.md`

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

## Installation

## Download a pre-compiled binary
You can download [changelog_manager for macOS
here](http://masukomi.org/projects/changelog_manager/changelog_manager.tgz).
Just decompress it `tar -xzf changelog_manager.tgz` and add it to your path.
Then follow the Usage guidelines.


## Building from source: 

Changelog Manager is written in Crystal so, you'll need to 
[install the Crystal compiler](http://crystal-lang.org/docs/installation/index.html).

### macOS
If you're on macOS you can make a staticly compiled binary that you _should_
be able to distribute to other macOS users with this command:

	crystal compile --release src/changelog_manager.cr --link-flags "/usr/local/opt/libevent/lib/libevent.a /usr/local/opt/libpcl/lib/libpcl.a /usr/local/opt/bdw-gc/lib/libgc.a"

### Other OSs

	crystal compile --release src/changelog_manager.cr

This is not a static binary. Any system you distribute it on must have the
required headers installed. You can do something similar to the macOS with
`--link-flags` but which ones you link in will be different.


Once you've built it, put the new `changelog_manager` file somewhere in your
path. Here's [how to add a directory to your path](http://unix.stackexchange.com/a/26059/124338). Or, if you just run `echo $PATH` on the command line you can simply
move `changelog_manager` to any of the directories in that list (that you have
write access to).

## Contributors

- [[masukomi]](https://github.com/masukomi) masukomi - creator, maintainer
