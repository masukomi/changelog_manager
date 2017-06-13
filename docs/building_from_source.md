## Building from source: 

Changelog Manager is written in Crystal so, you'll need to 
[install the Crystal compiler](http://crystal-lang.org/docs/installation/index.html).

### macOS
If you're on macOS you can make a staticly compiled binary that you _should_
be able to distribute to other macOS users with this command:

	crystal build --release src/changelog_manager.cr --link-flags "/usr/local/opt/libevent/lib/libevent.a /usr/local/opt/libpcl/lib/libpcl.a /usr/local/opt/bdw-gc/lib/libgc.a"

### Other OSs

	crystal build --release src/changelog_manager.cr

This is not a static binary. Any system you distribute it on must have the
required headers installed. You can do something similar to the macOS with
`--link-flags` but which ones you link in will be different.


Once you've built it, put the new `changelog_manager` file somewhere in your
path. Here's [how to add a directory to your path](http://unix.stackexchange.com/a/26059/124338). Or, if you just run `echo $PATH` on the command line you can simply
move `changelog_manager` to any of the directories in that list (that you have
write access to).

