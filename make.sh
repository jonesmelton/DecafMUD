#! /bin/bash
set -e

rm -rf dist/

yarn tsc
# mkdir -p dist/js
# cp src/js/*.js dist/js/
cp src/web_client.html dist/

cp -r src/css dist/