#!/bin/bash -eu

function="${1}"

if [ ! -d ./functions/${function} ]; then
    echo "function ${function} does not exist"
    exit 1
fi

(
cd ./functions/${function}

gcloud functions delete ${function} \
    --region=asia-northeast1
)
