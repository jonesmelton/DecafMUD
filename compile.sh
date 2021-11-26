#! /bin/bash
set -e

echo "deleting dist/"
rm -rf dist/

echo "building src -> dist"
yarn swc src -d dist --copy-files

echo "building elm"
elm make src/Main.elm --output=dist/main.js --debug

echo "building css"
yarn postcss --use autoprefixer tailwindcss -o dist/main.css src/main.css

