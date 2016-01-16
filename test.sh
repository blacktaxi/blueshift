#!/bin/bash
elm-package install -y
console_version=$(node -pe 'JSON.parse(process.argv[1])["laszlopandy/elm-console"]' "$(cat elm-stuff/exact-dependencies.json)")

elm-make --yes --output build/raw-test.js tests/Tests.elm
bash elm-stuff/packages/laszlopandy/elm-console/$console_version/elm-io.sh build/raw-test.js build/test.js
node build/test.js
