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
echo "problems with linked libraries. This will \"brew install\" any missing ones."
echo ""



homebrew=`command -v brew`
if [ "$homebrew" == "" ]; then
  echo "Oh. I see. Homebrew isn't installed."
  echo "Please go to http://brew.sh/ and follow the installation instructions."
  echo "Run me again when that's been done."
  echo ""
  echo "Note: changelog_manager doesn't require Homebrew. It does require the"
  echo "crystal, & the following libraries to be dynamically linkable. Homebrew"
  echo "makes that easy:"
  echo ""
  echo "* crystal programming language: https://crystal-lang.org/"
  echo "* bdw-gc"
  echo "* libevent"
  echo "* pcre"
fi

crystal=`command -v crystal`
bdw_gc=`brew ls --versions bdw-gc`
libevent=`brew ls --versions libevent`
pcre=`brew ls --versions pcre`

if [ "$crystal" == "" ]; then
	echo "❌ crystal NOT found"
	confirm && brew install crystal
else
	echo "✅ crystal found"
fi

if [ "$bdw_gc" == "" ]; then
	echo "❌ bwd-gc NOT found"
	confirm && brew install bdw-gc
else
	echo "✅ bwd-gc found"
fi

if [ "$libevent" == "" ]; then
	echo "❌ libevent NOT found"
	confirm && brew install libevent
else
	echo "✅ libevent found"
fi

if [ "$pcre" == "" ]; then
	echo "❌ pcre NOT found"
	confirm && brew install pcre
else
	echo "✅ pcre found"
fi

echo ""
echo "My work is done here."
echo "Run ./build.sh to build the changelog manager tools"
echo ""
echo ""
echo "Please contact me if you have any problems:"
echo "@masukomi@connectified.com on Mastodon"
echo "@masukomi on Twitter"
