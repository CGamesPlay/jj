#!/usr/bin/env bash
set -euo pipefail

# Fetch latest upstream
jj git fetch --remote upstream

# Rebase everything onto the new main
jj rebase -s 'roots(mutable())' -o main@upstream --simplify-parents

# Fail if ANY commit in the fork lineage is conflicted, even if resolved by descendants
if ! conflicted=$(jj log -G -r 'conflicts() & mutable()' -T 'log_oneline' 2>/dev/null); then
  echo "ERROR: The following mutable commits have conflicts:"
  echo "$conflicted"
  exit 1
fi

echo "Rebase successful, no conflicts."
