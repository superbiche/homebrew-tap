#!/usr/bin/env bash
# Install Casks/marque.rb from this checkout on a macOS runner and check what
# it installed: the app's ad-hoc signature, the universal binary and the
# `marque` command. The app is not launched (no display on the runner).
set -euo pipefail
tap=superbiche/tap
brew tap "$tap" "$PWD"
cp Casks/marque.rb "$(brew --repository "$tap")/Casks/marque.rb"
if brew commands | grep -qx trust; then brew trust "$tap"; fi
brew style "$tap/marque"
brew install --cask "$tap/marque"
app=/Applications/Marque.app
codesign --verify --deep --strict --verbose=2 "$app"
lipo -archs "$app/Contents/MacOS/marque" | tee /dev/stderr | grep -qw arm64
lipo -archs "$app/Contents/MacOS/marque" | grep -qw x86_64
cmd="$(brew --prefix)/bin/marque"
[[ "$(readlink "$cmd")" == "$app/Contents/MacOS/marque" ]] || { echo "::error::$cmd does not point into $app"; exit 1; }
brew uninstall --cask "$tap/marque"
[[ ! -e "$app" && ! -e "$cmd" ]]
echo "cask install check passed"
