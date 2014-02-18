#!/bin/sh

# Usage: rekusiv-edit ()
# Description: rekusiv edit file
# $1 = SUCHE   $2 = ERSETZEN
find ./ -type f -exec sed -i 's/$1/$2/g' {} \;
