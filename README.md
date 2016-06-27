# Changelog Manager

Changelog Manager helps you generate a `CHANGELOG.md` file for your repo 
that adheres to the [Keep A Changelog](http://keepachangelog.com/) standard, 
and doesn't result in nigh-constant conflicts. 

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

    `crystal build --release src/changelog_manager.cr`

Once you've built it, put the new `changelog_manager` file somewhere in your
path. Here's [how to add a directory to your path](http://unix.stackexchange.com/a/26059/124338). Or, if you just run `echo $PATH` on the command line you can simply
move `changelog_manager` to any of the directories in that list (that you have
write access to).

## Usage

### Adding a new entry


## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/[your-github-name]/changelog_manager/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[your-github-name]](https://github.com/[your-github-name]) masukomi - creator, maintainer
