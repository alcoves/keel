#!/bin/bash

verbose=yes
min_to_keep=${min_to_keep:-5}
delete_days_old=${delete_days_old:-10}

while [ $# -gt 0 ]; do
  if [[ $1 == *"--"* ]]; then
    param="${1/--/}"
    declare "$param"="$2"
  fi
  shift
done

date_boundary=$(date -d "$delete_days_old days ago" +%s)

for repository in reef pier tidal; do
  [[ -z "$repository" ]] && {
    echo "Error: Need to define '--repository'"
    exit 1
  }

  deletable_tags=$(doctl registry repository list-tags "$repository" --output json | jq ".[5:] | .[] | select ( .updated_at | fromdateiso8601 < $date_boundary) | .tag " -r | tr '\n' ' ')
  
  [[ "$verbose" == "yes" ]] && {
    echo "Cleaning up $repository"
    echo "We are going to DELETE images that are more than $delete_days_old days old"
    echo "We are going to KEEP at least the newer $min_to_keep images"
    echo "Deleteable tags: $deletable_tags"
  }

  [[ -z "$deletable_tags" ]] && {
    [[ "$verbose" == "yes" ]] && echo "Nothing to delete"
    continue
  }

  doctl registry repository delete-tag "$repository" $deletable_tags --force
done 