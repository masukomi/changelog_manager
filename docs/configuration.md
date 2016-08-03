# Configuration

`changelog_manager` supports a couple configuration options.

When you first started using it a `.changelog_entries/config.json` file was
created. This file holds all the configuration values for your project's
`changelog_manager` usage. This file should be checked in to your repo.

All of the values in this can be overriden with a [Personal
Configuration](personal_configuration.md). 

## What's configurable?

* `ticket_url_prefix`:
	* Ticketing systems typically have identical urls for all tickets except for the ticket's unique identifier at the end of the url. If you specify `ticket_url_prefix` changelog_manager will ask you for the id, and calculate the url instead of asking.
	* Acceptable values: an url, an empty string. Both would be enclosed in
	  double quotes.
* `git_add`:
	* By default changelog_manager will run `git_add` on the newly created changelog entry immediately after creation. You can turn this off by setting this value to false.
	* Acceptable values: `true`, `false`

## Upgrades

Over time we expect the `changelog_manager` to accrete new configuration
options. When you upgrade those new options will be added to
your `.changelog_entries/config.json` with their default values simply by using
`changelog_manager` to create a new entry.

As such, it is recommended that you [read our CHANGELOG](https://github.com/masukomi/changelog_manager/wiki/CHANGELOG) before upgrading. If you see anything about 
new changelog configuration options you'll probably want to add a commit to your
repo with a new changelog entry saying that you're upgrading the `config.json`.

Adding that entry, will upgrade your `config.json` and you can go back and tweak
it before committing if you don't like the defaults.
