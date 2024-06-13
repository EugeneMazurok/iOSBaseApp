 #!/usr/bin/env bash

mkdir -p tmp
touch tmp/index.html
  mkdir -p public

if ! (swiftlint --reporter html > tmp/index.html) ; then
  mkdir -p public/${CI_PIPELINE_ID}/
  mv tmp/index.html public/${CI_PIPELINE_ID}/index.html
EOF
else
  cp build-scripts/linter/ci/index.html public/index.html
fi
exit 0
