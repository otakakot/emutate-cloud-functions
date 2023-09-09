#!/bin/bash -eu

function="${1}"

if [ ! -d ./functions/${function} ]; then
    echo "function ${function} does not exist"
    exit 1
fi

head=$(tr '[a-z]' '[A-Z]' <<< ${function:0:1})
tail=${function:1}
entry="${head}${tail}"

(
cd ./functions/${function}

gcloud functions deploy ${function} \
    --gen2 \
    --runtime=go121 \
    --region=asia-northeast1 \
    --source=. \
    --entry-point=${entry} \
    --trigger-http \
    --allow-unauthenticated
)
