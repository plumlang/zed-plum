#!/usr/bin/env bash
# Check the queries against Plumlang's shared highlighting sample
# (plumlang's tests/highlight/): its keyword list and sample.plum.
#
#   1. every query in languages/plum loads and runs over sample.plum;
#   2. every keyword the lexer has is in sample.plum with a capture from
#      highlights.scm (@keyword*, @boolean, @constant.builtin or
#      @variable.special).
#
# Run it from a checkout of tree-sitter-plum at the revision extension.toml
# pins, so `tree-sitter query` uses that grammar:
#
#   usage: script/check-sample.sh path/to/zed-plum [dir]
#
# dir holds keywords.txt and sample.plum (e.g. ../plumlang/tests/highlight);
# without it they are downloaded from plumlang's main branch.
set -euo pipefail

ext=$(cd "$1" && pwd)
ts=${TREE_SITTER:-tree-sitter}
base=https://raw.githubusercontent.com/plumlang/plumlang/main/tests/highlight
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

if [[ $# -gt 1 ]]; then
  dir=$(cd "$2" && pwd)
else
  dir=$work
  curl -fsSL "$base/keywords.txt" -o "$dir/keywords.txt"
  curl -fsSL "$base/sample.plum" -o "$dir/sample.plum"
fi
status=0

for query in "$ext"/languages/plum/*.scm; do
  if ! "$ts" query "$query" "$dir/sample.plum" >"$work/captures-$(basename "$query")"; then
    echo "$(basename "$query") does not run over sample.plum"
    status=1
  fi
done
[[ $status -eq 0 ]] && echo "queries: all run over sample.plum"

while read -r word; do
  if ! grep -qE "capture: [0-9]+ - (keyword[a-z.]*|boolean|constant\.builtin|variable\.special), .*text: \`$word\`$" \
    "$work/captures-highlights.scm"; then
    echo "highlights.scm does not highlight the keyword '$word' in sample.plum"
    status=1
  fi
done <"$dir/keywords.txt"
[[ $status -eq 0 ]] && echo "highlights: all $(wc -l <"$dir/keywords.txt") keywords in sample.plum are captured"
exit "$status"
