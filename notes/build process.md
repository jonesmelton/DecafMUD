create:
rm -rf compiled
mkdir compiled/css -p

combines:
build js js/disc.settings.js js/dragelement.js js/disc.menu.js js/disc.macro.js js/disc.zmp.js\
 js/decafmud.js js/decafmud.storage.standard.js js/decafmud.interface.discworld.js \
-O BUNDLE --js_output_file=compiled/main.js

build js js/decafmud.encoding.cp437.js -O BUNDLE --js_output_file=compiled/decafmud.encoding.cp437.js
build js js/decafmud.encoding.iso885915.js -O BUNDLE --js_output_file=compiled/decafmud.encoding.iso885915.js

build css closure-stylesheets.${CSS_VERSION}.jar css/\*.css -o compiled/css/main.css

sedit the web_client.html:
"sed '/REMOVED_WHEN_COMPILING/c\ <script src="main.js" type="text/javascript"></script>' web_client.html > compiled/web_client.html"
