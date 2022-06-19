#!/usr/bin/env sh

echo "installing depenencies..."
shards install

# echo ""
# echo "compiling cli_tool..."
# crystal build --release src/cli_tool.cr

echo ""
echo "compiling changelog_manager..."
crystal build --release src/changelog_manager.cr

# echo ""
# echo "compiling changelog_generator..."
# crystal build --release src/changelog_generator.cr


echo ""
echo "Please add the current directory to your path"
echo "if you haven't already, OR copy those to a directory in your PATH"
