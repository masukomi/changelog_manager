#!/bin/sh

function confirm {
  read -r -p "Can I install it?" response
  case $response in
      [yY][eE][sS]|[yY]) 
          true
          ;;
      *)
          false
          ;;
  esac
}

echo "Crystal lang is still pretty young, and we're seeing occasional"
echo "problems with linked libraries. This will brew install any missing ones."
echo ""



homebrew=`which brew`
if [ "$homebrew" == "" ]; then
  echo "Oh. I see. Homebrew isn't installed."
  echo "Please go to http://brew.sh/ and follow the installation instructions."
  echo "Run me again when that's been done."
  echo ""
  echo "Note: changelog_manager doesn't require Homebrew. It does require the"
  echo "following libraries to be dynamically linkable, and homebrew"
  echo "makes that easy:"
  echo ""
  echo "* bdw-gc"
  echo "* libevent"
  echo "* pcre"
fi


bdw_gc=`brew ls --versionns bdw-gc`
libevent=`brew ls --versions libevent`
pcre=`brew ls --versions pcre`

if [ "$bdw_gc" == "" ]; then
	echo "\xE2\x98\x90 bwd-gc NOT found"
	confirm && brew install bdw-gc
else
	echo "\xE2\x98\x91 bwd-gc found"
fi

if [ "$libevent" == "" ]; then
	echo "\xE2\x98\x90 libevent NOT found"
	confirm && brew install libevent
else
	echo "\xE2\x98\x91 libevent found"
fi

if [ "$pcre" == "" ]; then
	echo "\xE2\x98\x90 pcre NOT found"
	confirm && brew install pcre
else
	echo "\xE2\x98\x91 pcre found"
fi

echo ""
echo "My work is done here."
echo "Please contact @masukomi on twitter if you have any problems."
