# Troubleshooting

In OS X you can't fully statically compile an executable. This means you can't
include all the libraries it needs to run. Apple _really_ wants you to use the
ones provided by the operating system. Some libraries can be statically complied
into the app, and these have been, but some users have had problems with other
libraries simply not being there.


If you get an error complaning about missing...

* `libgc` files
	* `brew install bdw-gc` should fix it.
* `libevent` files
	* `brew install libevent` should fix it.
* `pcre` files
	* `brew install prce` should fix it.

It is my sincere hope that future versions of Crystal-lang will eliminate these
problems.
