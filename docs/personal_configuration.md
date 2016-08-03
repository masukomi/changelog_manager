# Personal Configuration

All configuration options can be overrided by means a `personal_config.json`
file.

`changelog_manager` will read in the configuration for the project in your 
`.changelog_entries/config.json` file. Sometimes those configurations are not 
the best for given user's personal workflow. For example, most users would want
new changelog entries to be automatically added to git upon creation, whilst
some would rather manually add them.

To override any of the values in `.changelog_entries/config.json` you would
create a `.changelog_entries/personal_config.json`. You should NEVER check this
file in, so we recommend adding `.changelog_entries/personal_config.json` to 
your `.gitignore`

This file would contain ONLY the values you wish to override.

For a list of the configurable settings and their acceptable values see the
[configuration](configuration.md) documentation.

For example:

This projects `config.json` says

	{"ticket_url_prefix":"https://github.com/masukomi/changelog_manager/issues/",
	"git_add":true}

To override the `git_add` setting you would create a 
`.changelog_entries/personal_config.json` file that looked like this:

	{"git_add": false}

That's it.

P.S. There is [an open
issue](https://github.com/masukomi/changelog_manager/issues/14) to create a new
config manager tool to make it easier to manage `config.json` and
`personal_config.json`

